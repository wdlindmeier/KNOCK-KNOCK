//
//  NOCCameraPerspective.m
//  ARFlightTracker
//
//  Created by William Lindmeier on 1/5/14.
//  Copyright (c) 2014 William Lindmeier. All rights reserved.
//

#import "NOCCameraPerspective.h"

@implementation NOCCameraPerspective

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.fovVertRadians = GLKMathDegreesToRadians(65.0f);
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.aspect = screenSize.width / screenSize.height; // Use screen bounds as default
        self.nearZ = 0.1f;
        self.farZ = 1000.0f;
        self.target = GLKVector3Make(0, 0, 0);
        self.eye = GLKVector3Make(0, 0, -3.0f);
        self.up = GLKVector3Make(0, 1, 0);
    }
    return self;
}

- (GLKMatrix4)projectionMatrix
{
    GLKMatrix4 projectionMat = GLKMatrix4MakePerspective(self.fovVertRadians,
                                                         self.aspect,
                                                         self.nearZ,
                                                         self.farZ);
    GLKMatrix4 camMat = GLKMatrix4MakeLookAt(_eye.x, _eye.y, _eye.z,
                                             _target.x, _target.y, _target.z,
                                             _up.x, _up.y, _up.z);
    return GLKMatrix4Multiply(projectionMat, camMat);
}

@end
