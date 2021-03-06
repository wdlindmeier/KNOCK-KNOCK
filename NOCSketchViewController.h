//
//  WDLViewController.h
//  Nature of Code
//
//  Created by William Lindmeier on 1/30/13.
//  Copyright (c) 2013 wdlindmeier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "NOCShaderProgram.h"
#import "NOCOpenGLHelpers.h"
#ifdef RETAIN_BACKING_BUFFER
#import "CAEAGLLayer+Retained.h"
#endif

#ifndef USE_SKETCH_CONTROLS
#ifndef NOCSketchViewControllerBase
#define NOCSketchViewControllerBase NOCSketchViewController
#endif
#else
#ifndef NOCSketchViewControllerBase
#define NOCSketchViewControllerBase NOCControlsSketchViewController
#endif
#endif

@interface NOCSketchViewController : GLKViewController <UIActionSheetDelegate>
{
    // Geometry
    CGSize _sizeView;
    float _viewAspect;
    GLfloat _screen3DBillboardVertexData[12];
}

// Properties
@property (nonatomic, readonly) long frameCount;
@property (nonatomic, readonly) float averageFPS;

// Outlets
@property (strong, nonatomic) EAGLContext *context;

// Shaders
- (NOCShaderProgram *)shaderNamed:(NSString *)shaderName;
- (void)addShader:(NOCShaderProgram *)shader named:(NSString *)shaderName;

- (float)averageFPS;

// Loop
- (void)setup;
- (void)update;
- (void)resize;
- (void)draw;
- (void)clear;
- (void)teardown;

@end
