//
//  NOCOpenGLState.h
//  CoffeeGrapher
//
//  Created by William Lindmeier on 7/12/14.
//  Copyright (c) 2014 wdlindmeier. All rights reserved.
//

#ifndef NOCOpenGLState_h
#define NOCOpenGLState_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

static inline void NOCGLEnableAlphaBlending()
{
    glEnable(GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
};

static inline void NOCGLEnableAdditiveBlending()
{
    glEnable(GL_BLEND);
    glBlendFunc (GL_ONE, GL_ONE);
};

#endif
