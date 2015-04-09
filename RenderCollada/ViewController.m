//
//  ViewController.m
//  RenderCollada
//
//  Created by killa on 1/21/15.
//  Copyright (c) 2015 lianliantech. All rights reserved.
//

#import "ViewController.h"
#import "LianLianColladaParser.h"

@interface ViewController ()
{
    GLuint vertexid;
}
@property (nonatomic) GLKBaseEffect *baseEffect;
@property (nonatomic) LianLianDae *dae;

@property (nonatomic) NSInteger frameIndex;
@property (nonatomic) NSDate *now;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LianLianColladaParser *parser = [LianLianColladaParser new];
    [parser parserxml];
    self.dae = parser.dae;
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    glEnable(GL_CULL_FACE);
    
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    [self.dae prepareToDraw];
    glGenBuffers(1, &vertexid);
    glBindBuffer(GL_ARRAY_BUFFER, vertexid);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SceneVertex) * self.dae.vertexCount, self.dae.vertexs, GL_STATIC_DRAW);
    
    [self effectLight];
    [self modelTransform];
    self.frameIndex = 0;
}

- (void)animate
{
    [self.dae setupSkeleton:self.frameIndex];
    [self.dae prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, vertexid);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SceneVertex) * self.dae.vertexCount, self.dae.vertexs, GL_STATIC_DRAW);
    if (++self.frameIndex > 100){
        self.frameIndex = 0;
    }
    [self animateModelTransform];
    
}

- (void)animateModelTransform
{
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, GLKMathDegreesToRadians(-90.0));
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(-90.0));
    CGFloat scale = 0.005;
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, scale, scale, scale);
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)modelTransform
{
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, GLKMathDegreesToRadians(-90.0));
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, GLKMathDegreesToRadians(-90.0));
    //    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians( 90.0));
    CGFloat scale = 0.005;
    modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, scale, scale, scale);
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)effectLight
{
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.7, .7f, .7f, 1.0f);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.baseEffect.light0.position = GLKVector4Make(1.0f, 0.8f, 0.4f, 0.0f);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    [self animate];
    glClear(GL_COLOR_BUFFER_BIT);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex,positionCoords));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex,normalCoords));
    
    glDrawArrays(GL_TRIANGLES, 0, (int)self.dae.vertexCount);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
