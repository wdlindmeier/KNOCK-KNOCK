KNOCK-KNOCK iOS
========

KNOCK-KNOCK is a collection of convenience classes for OpenGL ES 2 that were originally created for the [Nature-of-Code iOS App](https://github.com/wdlindmeier/Nature-Of-Code). Among these classes are:

* 2D & 3D scene view controllers
* A Particle System
* FBO and VBO
* A Camera
* Shader and Texture representations
* An .obj Loader

It's built upon the GLKit framework.

##A Simple Example

```objc

@interface MySketchViewController : NOC2DSketchViewController
{
    NOCShaderProgram *_shader;
    NOCParticle2D *_particle;
}
@end

@implementation MySketchViewController

- (void)setup
{
    // Setup the shader
    _shader = [[NOCShaderProgram alloc] initWithName:@"BasicShader"];
    
    _shader.attributes = @{ @"position" : @(GLKVertexAttribPosition), 
                            @"color" : @(GLKVertexAttribColor) };
    _shader.uniformNames = @[ @"uModelViewProjectionMatrix" ];
    
    [self addShader:_shader named:@"BasicShader"];

    // Setup the Particle
    _particle = [[NOCParticle2D alloc] initWithSize:GLKVector2Make(0.01, 0.01)
                                           position:GLKVector2Make(0,0)];
}

- (void)update
{
    [super update];
    [_particle applyForce:GLKVector2Make(0.25, -0.1)];
    [_particle step];
}

- (void)clear
{
    glClearColor(0.2, 0.2, 0.2, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

- (void)draw
{
    [self clear];
    
    [_shader use];

    // Get the model matrix from the particle
    GLKMatrix4 modelMat = [_particle modelMatrix];
    
    // Multiply by the projection matrix
    GLKMatrix4 mvProjMat = GLKMatrix4Multiply(_projectionMatrix2D, modelMat);
    
    // Pass mvp into shader
    [_shader setMatrix4:mvProjMat forUniform:@"uModelViewProjectionMatrix"];
    
    [_particle render];
}

- (void)teardown
{
    //..
}

@end


```
