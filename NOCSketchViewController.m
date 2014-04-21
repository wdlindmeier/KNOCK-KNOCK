//
//  WDLViewController.m
//  Nature of Code
//
//  Created by William Lindmeier on 1/30/13.
//  Copyright (c) 2013 wdlindmeier. All rights reserved.
//

#import "NOCSketchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import "NOCOpenGLHelpers.h"
#import "NOCGeometry.h"

@interface NOCSketchViewController ()
{
    long _frameCount;
    NSMutableDictionary *_shaders;
    long _fpsLastSampleFrame;
    NSTimeInterval _fpsLastSampleTime;
    NSTimeInterval _averageFPSSampleInterval;
    float _averageFPS;    
}

@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;
- (BOOL)loadShaders;

@end

@implementation NOCSketchViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self initNOCSketchViewController];
    }
    return self;    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initNOCSketchViewController];
    }
    return self;
}

- (void)initNOCSketchViewController
{
    _shaders = [NSMutableDictionary dictionaryWithCapacity:10];
    _fpsLastSampleFrame = -1;
    _fpsLastSampleTime = [NSDate timeIntervalSinceReferenceDate];
    _averageFPS = 0;
    _averageFPSSampleInterval = 1.0f;
}

#pragma mark - Memory

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context)
    {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil))
    {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context)
        {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (NOCShaderProgram *)shaderNamed:(NSString *)shaderName
{
    NOCShaderProgram *shader = [_shaders valueForKey:shaderName];
    if(!shader){
        NSLog(@"ERROR: Could not find shader with name %@", shaderName);
    }
    return shader;
}

- (void)addShader:(NOCShaderProgram *)shader named:(NSString *)shaderName
{
    [_shaders setValue:shader forKey:shaderName];
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#ifdef USE_SKETCH_CONTROLS
    
    UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                target:self
                                                                                action:@selector(buttonActionPressed:)];
    
    self.navigationItem.rightBarButtonItem = actionItem;
    
#endif
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resize];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resize];
}

#pragma mark - GL

- (void)loadGLContext
{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
}

- (void)setupGL
{
    _frameCount = 0;
    [self loadGLContext];
    [self resize];
    [self setup];
    [self loadShaders];
}

- (void)tearDownGL
{
    [self teardown];
    for(NSString *shaderName in _shaders)
    {
        NOCShaderProgram *shader = [self shaderNamed:shaderName];
        [shader unload];
    }
    [EAGLContext setCurrentContext:nil];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self calculateFPS];
    [self draw];
    _frameCount++;
}

- (void)calculateFPS
{
    uint32_t framesPassed = _frameCount - _fpsLastSampleFrame;
    NSTimeInterval _now = [NSDate timeIntervalSinceReferenceDate];
    if ( _now - _fpsLastSampleTime >= _averageFPSSampleInterval )
    {
        _averageFPS = (float)(framesPassed / (_now - _fpsLastSampleTime));
        _fpsLastSampleTime = _now;
        _fpsLastSampleFrame = _frameCount;
    }
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    for(NSString *shaderName in _shaders)
    {
        NOCShaderProgram *shader = [self shaderNamed:shaderName];
        BOOL didLoad = [shader load];
        if(!didLoad){
            return NO;
        }
    }
    return YES;
}

#pragma mark - Subclass Loop

- (void)setup
{
    //..
}

- (void)update
{
    //...
}

- (void)resize
{
    _sizeView = self.view.frame.size;
    if ( UIInterfaceOrientationIsLandscape(self.interfaceOrientation) )
    {
        _sizeView = CGSizeMake(_sizeView.height, _sizeView.width);
    }
    
    _viewAspect = _sizeView.width / _sizeView.height;
    
    for( int i=0; i < 4; i++ )
    {
        _screen3DBillboardVertexData[i*3+0] = kSquare3DBillboardVertexData[i*3+0] * 2;
        _screen3DBillboardVertexData[i*3+1] = kSquare3DBillboardVertexData[i*3+1] * 2 / _viewAspect;
        _screen3DBillboardVertexData[i*3+2] = kSquare3DBillboardVertexData[i*3+2] * 2;
    }
}

- (void)draw
{
    //...
}

- (void)clear
{
    glClearColor(0,0,0,1);
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
}

- (void)teardown
{
    //...
}

@end
