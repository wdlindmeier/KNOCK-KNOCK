//
//  NOCVBO.h
//  NOCVBO
//
//  Created by William Lindmeier on 12/26/13.
//  Copyright (c) 2013 William Lindmeier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface NOCVBO : NSObject

- (id)initWithSize:(GLsizeiptr)size
              data:(const GLvoid *)data
             setup:(void(^)())geometrySetupBlock;
- (void)bind;
- (void)unbind;

@end
