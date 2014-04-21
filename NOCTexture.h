//
//  NOCTexture.h
//  ARManhattan
//
//  Created by William Lindmeier on 12/22/13.
//  Copyright (c) 2013 William Lindmeier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface NOCTexture : NSObject
{
    GLKTextureInfo *_glTexture;
}

- (id)initWithImageNamed:(NSString *)imageName;
- (id)initWithImageNamed:(NSString *)imageName premultiply:(BOOL)premultiply;
- (id)initWithImage:(UIImage *)image;
- (id)initWithImage:(UIImage *)image premultiply:(BOOL)premultiply;

- (void)enableAndBind:(int)textureLoc;
- (void)enableAndBindToUniform:(GLuint)uniformSamplerLocation;
- (void)enableAndBindToUniform:(GLuint)uniformSamplerLocation atPosition:(int)textureNum;
- (void)unbind;
- (void)render;
- (GLuint)textureID;
- (void)updateWithImage:(UIImage *)image;

@property (nonatomic, assign) GLuint vertAttribLocation;
@property (nonatomic, assign) GLuint texCoordAttribLocation;
@property (nonatomic, readonly) CGSize size;

@end
