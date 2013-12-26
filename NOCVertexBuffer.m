//
//  NOCVertexBuffer.m
//  NOCVertexBuffer
//
//  Created by William Lindmeier on 12/26/13.
//  Copyright (c) 2013 William Lindmeier. All rights reserved.
//

#import "NOCVertexBuffer.h"

@implementation NOCVertexBuffer
{
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}

- (id)initWithSize:(GLsizeiptr)size
              data:(const GLvoid *)data 
             setup:(void(^)())geometrySetupBlock
{
    self = [super init];
    if ( self )
    {
        glEnable(GL_DEPTH_TEST);
        
        glGenVertexArraysOES(1, &_vertexArray);
        glBindVertexArrayOES(_vertexArray);

        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        
        glBufferData(GL_ARRAY_BUFFER,
                     size,
                     data,
                     GL_STATIC_DRAW);

        geometrySetupBlock();
        
        glBindVertexArrayOES(0);
    }
    return self;
}

- (void)dealloc
{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
}

- (void)bind
{
    glBindVertexArrayOES(_vertexArray);
}

- (void)bind:(void(^)())drawingBlock
{
    [self bind];
    drawingBlock();
    [self unbind];
}

- (void)unbind
{
    glBindVertexArrayOES(0);
}

@end
