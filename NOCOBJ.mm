//
//  WFObject.m
//  ObjLoader
//
//  Created by William Lindmeier on 8/27/12.
//  Copyright (c) 2012 William Lindmeier. All rights reserved.
//

#import "NOCOBJ.h"
#import "NOCOpenGLHelpers.h"
#import "NOCOpenGLHelpers.h"
#import "NOCGeometry.h"
#import "NOCFileReader.h"
#import <GLKit/GLKit.h>

#include <vector>

@implementation NOCOBJ
{
    long _numVerts;
}

- (id)initWithFilename:(NSString *)filename
{
    self = [super init];
    if( self )
    {
        // Parse it on up
        NSString *objPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"obj"];
        assert( [[NSFileManager defaultManager] fileExistsAtPath:objPath] );
        [self parseObjFileAtPath:objPath];
    }
    return self;
}

- (void)parseObjFileAtPath:(NSString *)filePath
{
    NOCFileReader *fileReader = [[NOCFileReader alloc] initWithFilePath:filePath];
    
    __block std::vector<GLKVector3> verts;
    __block std::vector<GLKVector3> normals;
    __block std::vector<GLKVector2> texCoords;
    __block std::vector<std::vector<int> > elementIndeces;
    
    [fileReader enumerateTrimmedLinesUsingBlock:^(NSString *line, BOOL *shouldStop)
    {
        // Check if it's a comment
        if ([line rangeOfString:@"#"].location == 0 ||
            line.length == 0)
        {
            return;
        }
        
        NSArray *tokens = [line componentsSeparatedByString:@" "];
        if (tokens > 0 )
        {
            NSString *lineType = tokens[0];
            if ( [lineType isEqualToString:@"v"] ) // vert
            {
                float x = [tokens[1] floatValue];
                float y = [tokens[2] floatValue];
                float z = [tokens[3] floatValue];
                verts.push_back(GLKVector3Make(x,y,z));
            }
            else if ( [lineType isEqualToString:@"vn"] ) // normal
            {
                float x = [tokens[1] floatValue];
                float y = [tokens[2] floatValue];
                float z = [tokens[3] floatValue];
                normals.push_back(GLKVector3Make(x,y,z));
            }
            else if ( [lineType isEqualToString:@"vt"] ) // texture coord
            {
                float s = [tokens[1] floatValue]; // u / x
                float t = [tokens[2] floatValue]; // v / y
                texCoords.push_back(GLKVector2Make(s,t));
            }
            else if ( [lineType isEqualToString:@"f"] ) // face indexes
            {
                for ( int i = 1; i < tokens.count; ++i )
                {
                    NSString *element = tokens[i];
                    NSArray *elementTokens = [element componentsSeparatedByString:@"/"];
                    assert(elementTokens.count == 3);
                    std::vector<int> indexes;
                    for ( NSString *tok in elementTokens )
                    {
                        // NOTE: it's possible that the token is "", and the int value is 0
                        indexes.push_back([tok intValue]);
                    }
                    elementIndeces.push_back(indexes);
                }
            }
        }
    }];
    
    // Now construct the data
    _numVerts = elementIndeces.size();
    
    long numDataValues = (_numVerts * 3) + (_numVerts * 3) + (_numVerts * 2);
    GLfloat *geomData = new GLfloat[numDataValues];

    // NOTE: Just soring the vert/text/norm data in order.
    // Not bothering with an Element VBO for now.
    for ( long i = 0; i < _numVerts; ++i )
    {
        std::vector<int> idxs = elementIndeces[i];
        
        // NOTE: Indexes aren't zero indexed, they're 1 indexed.
        // NOTE: If the value doesn't exist, it will default to 0.
        
        // Vert (0)
        int vertIdx = idxs[0] - 1; // 1 => 0
        GLKVector3 vert;
        if ( vertIdx >= 0 )
        {
            vert = verts[vertIdx];
        }
        geomData[i*8+0] = vert.x;
        geomData[i*8+1] = vert.y;
        geomData[i*8+2] = vert.z;

        // Tex Coord (1)
        int texIdx = idxs[1] - 1; // 1 => 0
        GLKVector2 texCoord;
        if ( texIdx >= 0 )
        {
           texCoord = texCoords[texIdx];
        }
        geomData[i*8+3] = texCoord.x;
        geomData[i*8+4] = texCoord.y;
        
        // Normal (2)
        int normalIdx = idxs[2] - 1; // 1 => 0
        GLKVector3 normal;
        if ( normalIdx >= 0 )
        {
            normal = normals[normalIdx];
        }
        geomData[i*8+5] = normal.x;
        geomData[i*8+6] = normal.y;
        geomData[i*8+7] = normal.z;
    }
    
    _vertexBuffer = [[NOCVertexArrayBuffer alloc] initWithSize:sizeof(GLfloat) * numDataValues
                                                          data:geomData
                                                         setup:^{
                                                             glEnableVertexAttribArray(GLKVertexAttribPosition);
                                                             glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE,
                                                                                   32, BUFFER_OFFSET(0));
                                                             
                                                             glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
                                                             glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE,
                                                                                   32, BUFFER_OFFSET(12));
                                                             
                                                             glEnableVertexAttribArray(GLKVertexAttribNormal);
                                                             glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE,
                                                                                   32, BUFFER_OFFSET(20));
                                                         }];
    
    free(geomData);
    geomData = NULL;
}

- (void)render:(GLenum)renderMode
{
    [_vertexBuffer bind:^
    {
        glDrawArrays(renderMode, 0, (int)_numVerts);
    }];
}

@end
