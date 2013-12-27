//
//  NOCVertexBuffer.m
//  NOCVertexBuffer
//
//  Created by William Lindmeier on 12/26/13.
//  Copyright (c) 2013 William Lindmeier. All rights reserved.
//

#import "NOCVertexElementBuffer.h"

@implementation NOCVertexElementBuffer
{
    GLuint _elementBuffer;
}

- (id)initWithSize:(GLsizeiptr)size
              data:(const GLvoid *)data
{
    self = [super init];
    if ( self )
    {
        glGenBuffers(1, &_elementBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _elementBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                     size,
                     data,
                     GL_STATIC_DRAW);
    }
    return self;
}

- (void)dealloc
{
    glDeleteBuffers(1, &_elementBuffer);
}

- (void)bind
{
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _elementBuffer);
}

- (void)bind:(void(^)())drawingBlock
{
    [self bind];
    drawingBlock();
    [self unbind];
}

- (void)unbind
{
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _elementBuffer);
}

@end
