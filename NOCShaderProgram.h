//
//  NOCShaderProgram.h
//  Nature of Code
//
//  Created by William Lindmeier on 2/2/13.
//  Copyright (c) 2013 wdlindmeier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "NOCShaderDefaults.h"

@class NOCTexture;

@interface NOCShaderProgram : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) GLuint glPointer;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSArray *uniformNames;
@property (nonatomic, readonly) NSDictionary *uniformLocations;

- (id)initWithName:(NSString *)name;
- (id)initWithVertexShader:(NSString *)vertShaderName fragmentShader:(NSString *)fragShaderName;
- (BOOL)load;
- (void)unload;
- (void)use;

// Convenience methods
- (void)setFloat:(const GLfloat)f forUniform:(NSString *)uniformName;
- (void)setInt:(const GLint)i forUniform:(NSString *)uniformName;

- (void)setMatrix3:(const GLKMatrix3)mat forUniform:(NSString *)uniformName;
- (void)setMatrix4:(const GLKMatrix4)mat forUniform:(NSString *)uniformName;

- (void)set1DFloatArray:(const GLfloat[])array withNumElements:(int)num forUniform:(NSString *)uniformName;
- (void)set2DFloatArray:(const GLfloat[])array withNumElements:(int)num forUniform:(NSString *)uniformName;
- (void)set3DFloatArray:(const GLfloat[])array withNumElements:(int)num forUniform:(NSString *)uniformName;
- (void)set4DFloatArray:(const GLfloat[])array withNumElements:(int)num forUniform:(NSString *)uniformName;

- (void)setVec4:(GLKVector4)vec4 forUniform:(NSString *)uniformName;
- (void)setVec3:(GLKVector3)vec3 forUniform:(NSString *)uniformName;
- (void)setVec2:(GLKVector2)vec2 forUniform:(NSString *)uniformName;

- (void)bindTexture:(NOCTexture *)texture forUniform:(NSString *)uniformName;

- (void)enableAttribute2D:(NSString *)attribName withArray:(const GLvoid*)arrayValues;
- (void)enableAttribute3D:(NSString *)attribName withArray:(const GLvoid*)arrayValues;
- (void)disableAttributeArray:(NSString *)attribName;

@end
