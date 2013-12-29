//
//  WFObject.h
//  ObjLoader
//
//  Created by William Lindmeier on 8/27/12.
//  Copyright (c) 2012 William Lindmeier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NOCVertexArrayBuffer.h"
#import "NOCVertexElementBuffer.h"

@interface NOCOBJ : NSObject

- (id)initWithFilename:(NSString *)filename;
- (void)render:(GLenum)renderMode;

@property (nonatomic, strong) NOCVertexArrayBuffer *vertexBuffer;

@end
