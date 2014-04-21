//
//  NOCShaderDefaults.h
//  ARManhattan
//
//  Created by William Lindmeier on 12/23/13.
//  Copyright (c) 2013 William Lindmeier. All rights reserved.
//

#pragma once

// Default shader variable names

#pragma mark - Uniforms

static NSString * const NOCUniformNameMVProjectionMatrix = @"uModelViewProjectionMatrix";
static NSString * const NOCUniformNameModelViewMatrix = @"uModelViewMatrix";
static NSString * const NOCUniformNameProjectionMatrix = @"uProjectionMatrix";
static NSString * const NOCUniformNameNormalMatrix = @"uNormalMatrix";
static NSString * const NOCUniformNameTextureSampler = @"uSampler";
static NSString * const NOCUniformNamePointSize = @"uPointSize";
static NSString * const NOCUniformNameColor = @"uColor";

#pragma mark - Attributes

static NSString * const NOCAttributeNamePosition = @"aPosition";
static NSString * const NOCAttributeNameNormal = @"aNormal";
static NSString * const NOCAttributeNameTexCoord0 = @"aTexCoord0";
static NSString * const NOCAttributeNameTexCoord1 = @"aTexCoord1";
static NSString * const NOCAttributeNameTexCoord2 = @"aTexCoord2";
static NSString * const NOCAttributeNameTexCoord3 = @"aTexCoord3";
static NSString * const NOCAttributeNameColor = @"aColor";
static NSString * const NOCAttributeNamePointSize = @"aPointSize";

#pragma mark - Additional Constants 

const static int GLKVertexAttribPointSize = 10;
