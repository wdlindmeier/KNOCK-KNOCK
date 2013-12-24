//
//  NOCOpenGLHelpers.h
//  Nature of Code
//
//  Created by William Lindmeier on 2/2/13.
//  Copyright (c) 2013 wdlindmeier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "CGGeometry.h"

#pragma once

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#pragma mark - Structs

typedef struct
{
    GLKVector3 size;
    GLKVector3 origin;
} NOCBox3D;

typedef enum NOCWallSides
{
    WallSideNone = 0,
    WallSideBack,
    WallSideFront,
    WallSideLeft,
    WallSideRight,
    WallSideTop,
    WallSideBottom
} NOCWallSide;

#pragma mark - Textures

extern GLKTextureInfo * NOCLoadGLTextureWithImage(UIImage *texImage);
extern GLKTextureInfo * NOCLoadGLTextureWithName(NSString *texName);

#pragma mark - Debug

extern void NOCCheckGLError(NSString *contextString);

#pragma mark - Position Conversion

// Assumes that the GL world coords are -1..1 1..-1 / aspect
extern GLKVector2 NOCGLPositionFromCGPointInRect(CGPoint screenPoint, CGRect viewRect);
extern GLKVector2 NOCGLPositionInWorldFrameFromCGPointInRect(CGRect worldFrame, CGPoint screenPoint, CGRect viewRect);
extern void NOCSetGLVertCoordsForRect(GLfloat *glCoords, CGRect rect);

#pragma mark - NOC Box

extern BOOL NOCBox3DContainsPoint(NOCBox3D box, GLKVector3 point);
extern GLKVector3 NOCVecModBox3D(GLKVector3 point, NOCBox3D box);

#pragma mark - GLK Vector 2

#define GLKVector2Zero  GLKVector2Make(0, 0)
extern GLKVector2 GLKVector2Random();
extern GLKVector2 GLKVector2Normal(GLKVector2 vec);
extern GLKVector2 NOCGLKVector2Normal(GLKVector2 vec);
extern GLKVector2 GLKVector2Limit(GLKVector2 vec, float max);
extern BOOL GLKVector2Equal(GLKVector2 vecA, GLKVector2 vecB);

#pragma mark - GLK Vector 3

#define GLKVector3Zero  GLKVector3Make(0, 0, 0)
extern GLKVector3 GLKVector3Random();
extern GLKVector3 GLKVector3Limit(GLKVector3 vec, float max);
extern GLKVector3 NOCSurfaceNormalForTriangle(GLKVector3 ptA, GLKVector3 ptB, GLKVector3 ptC);
extern BOOL GLKVector3Equal(GLKVector3 vecA, GLKVector3 vecB);

#pragma mark - GLK Matrix 4

#define GLKMatrix4Zero GLKMatrix4Make(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
extern GLKMatrix4 GLKMatrix4AlignWithVector3Heading(GLKMatrix4 mat, GLKVector3 vecHeading);
extern GLKMatrix4 GLKMatrix4Lerp(GLKMatrix4 matLeft, GLKMatrix4 matRight, float amount);
extern GLKMatrix4 GLKMatrix4Divide(GLKMatrix4 mat, float divisor);
