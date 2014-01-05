//
//  NOCCameraPerspective.h
//  ARFlightTracker
//
//  Created by William Lindmeier on 1/5/14.
//  Copyright (c) 2014 William Lindmeier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface NOCCameraPerspective : NSObject

@property float fovVertRadians;
@property float aspect;
@property float nearZ;
@property float farZ;

@property (nonatomic, assign) GLKVector3 target;
@property (nonatomic, assign) GLKVector3 eye;
@property (nonatomic, assign) GLKVector3 up;

- (GLKMatrix4)projectionMatrix;

@end
