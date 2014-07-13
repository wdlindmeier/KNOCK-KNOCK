//
//  NOCTexture.m
//  ARManhattan
//
//  Created by William Lindmeier on 12/22/13.
//  Copyright (c) 2013 William Lindmeier. All rights reserved.
//

#import "NOCTexture.h"
#import "NOCGeometry.h"

@implementation NOCTexture
{
    NSString *_imageName;
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image premultiply:NO];
}

- (id)initWithImage:(UIImage *)image premultiply:(BOOL)premultiply
{
    self = [super init];
    if (self)
    {
        self.vertAttribLocation = GLKVertexAttribPosition;
        self.texCoordAttribLocation = GLKVertexAttribTexCoord0;
        
        // Clear the error in case there's anything in the pipes.
        glGetError();
        NSError *texError = nil;
        
        // Don't pre-multiply
        // http://stackoverflow.com/questions/4012035/opengl-es-iphone-alpha-blending-looks-weird
        // IPHONE_OPTIMIZE_OPTIONS | -skip-PNGs
        _glTexture = [GLKTextureLoader textureWithCGImage:image.CGImage
                                                  options:@{ GLKTextureLoaderApplyPremultiplication : @(premultiply) }
                                                    error:&texError];
        _size = CGSizeMake(_glTexture.width, _glTexture.height);
        if(texError)
        {
            NSLog(@"ERROR: Could not load the texture (named \"%@\"): %@", _imageName, texError);
            return nil;
        }
    }
    return self;
}

- (id)initWithImageNamed:(NSString *)imageName
{
    return [self initWithImageNamed:imageName premultiply:NO];
}

- (id)initWithImageNamed:(NSString *)imageName premultiply:(BOOL)premultiply
{
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image)
    {
        NSLog(@"ERROR: Could not find the texture image: %@", imageName);
        return nil;
    }
    _imageName = imageName;
    return [self initWithImage:image premultiply:premultiply];
}

- (void)dealloc
{
    GLuint index = _glTexture.name;
    glDeleteTextures(1, &index);
}

- (GLuint)textureID
{
    return _glTexture.name;
}

- (void)enableAndBind:(int)textureLoc
{
    glActiveTexture(GL_TEXTURE0+textureLoc);
    glBindTexture(GL_TEXTURE_2D, [self textureID]);
}

- (void)enableAndBindToUniform:(GLuint)uniformSamplerLocation
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, [self textureID]);
    glUniform1i(uniformSamplerLocation, 0);
}

- (void)enableAndBindToUniform:(GLuint)uniformSamplerLocation atPosition:(int)textureNum
{
    assert(GL_TEXTURE1 == GL_TEXTURE0 + 1);
    glActiveTexture(GL_TEXTURE0 + textureNum);
    glBindTexture(GL_TEXTURE_2D, [self textureID]);
    glUniform1i(uniformSamplerLocation, textureNum);
}

- (void)unbind
{
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (void)render
{
    glVertexAttribPointer(self.vertAttribLocation, 3, GL_FLOAT, GL_FALSE, 0, &kSquare3DBillboardVertexData);
    glVertexAttribPointer(self.texCoordAttribLocation, 2, GL_FLOAT, GL_FALSE, 0, &kSquare2DTexCoords);
    glEnableVertexAttribArray(self.vertAttribLocation);
    glEnableVertexAttribArray(self.texCoordAttribLocation);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableVertexAttribArray(self.vertAttribLocation);
    glDisableVertexAttribArray(self.texCoordAttribLocation);
}

- (void)updateWithImage:(UIImage *)image
{
    CGImageRef imageRef = [image CGImage];
    int width = CGImageGetWidth(imageRef);
    int height = CGImageGetHeight(imageRef);
    
    GLubyte* textureData = (GLubyte *)malloc(width * height * 4); // if 4 components per pixel (RGBA)
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(textureData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 //kCGImageAlphaOnly | kCGBitmapByteOrder32Big);
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
	glBindTexture( _glTexture.target, _glTexture.name );
	glPixelStorei( GL_UNPACK_ALIGNMENT, 1 );
    glTexImage2D( _glTexture.target, 0, GL_RGBA, width, height,
                  0, GL_RGBA, GL_UNSIGNED_BYTE, textureData );
    
    free(textureData);
}

@end
