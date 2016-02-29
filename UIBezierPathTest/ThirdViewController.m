//
//  ThirdViewController.m
//  UIBezierPathTest
//
//  Created by zjhaha on 16/2/17.
//  Copyright © 2016年 zjhaha. All rights reserved.
//

#import "ThirdViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>
#define KAngleToRadians(angle) (angle * M_PI)/180.0
#define LIGHT_DIRECTION 0,1,-0.5
#define AMBIENT_LIGHT 0.5


@interface ThirdViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *collectionView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (strong,nonatomic)CAShapeLayer *myLayer;
@property (strong,nonatomic)CAGradientLayer *grandient;

@property (weak, nonatomic) IBOutlet UISlider *mySlider;

@end

@implementation ThirdViewController

-(void)addLightingToFace:(CALayer*)face{
//    CALayer *layer = [CALayer layer];
//    layer.frame = face.bounds;
//    [face addSublayer:layer];
//    
//    //添加光照
//    CATransform3D tansform = face.transform;
////    GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换
//    GLKMatrix4 matrix4 = *(GLKMatrix4*)&tansform;
//    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
//    
//    //
//    GLKVector3 normal = GLKVector3Make(0, 0, 1);
//    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
//    normal = GLKVector3Normalize(normal);
//    
//    //获取光照角度值
//    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(Light_Direction));
//    float dotProduct = GLKVector3DotProduct(light, normal);
//    
//    //设置光照图层透明度
//    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
//    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
//    layer.backgroundColor = color.CGColor;
    
    
    //add lighting layer
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    //convert the face transform to matrix
    //(GLKMatrix4 has the same structure as CATransform3D)
    //译者注：GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换，感谢[@zihuyishi](https://github.com/zihuyishi)同学~
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    //get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    //get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(0,1,-0.5));
    float dotProduct = GLKVector3DotProduct(light, normal);
    //set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
    
    
}

//设置每个面的transform
-(void)addFace:(NSInteger)index withTransform:(CATransform3D)transform{
    UIView *faceView = self.collectionView[index];
    [self.containView addSubview:faceView];
    faceView.layer.transform = transform;
    
    CGSize containerSize = self.containView.bounds.size;
    faceView.center = CGPointMake(containerSize.width/2.0, containerSize.height/2.0);
    [self addLightingToFace:faceView.layer];
    
}

#pragma mark -设置立方体
-(void)setCurb{
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.containView.layer.sublayerTransform = perspective;
    //add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    
    //add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    
    //add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    //add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    //add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    
    //add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.view.bounds;
    [self.view.layer addSublayer:emitter];
    
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width/2.0, emitter.frame.size.height/2.0);
    
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"fire1"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = MAXFLOAT;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.5;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI*2.0;
    
    emitter.emitterCells = @[cell];
}


-(void)setRotateCircle{
    _myLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(100, 50) radius:100 startAngle:KAngleToRadians(30) endAngle:KAngleToRadians(150) clockwise:NO];
    _myLayer.path = path.CGPath;
    _myLayer.frame = CGRectMake(20, 100, 320, 300);
    _myLayer.strokeColor = [UIColor redColor].CGColor;
    _myLayer.fillColor = [UIColor clearColor].CGColor;
    _myLayer.lineCap = kCALineCapRound;
    _myLayer.lineWidth = 2;
    //    _myLayer.strokeStart = 0;
    _myLayer.strokeEnd = 0;
    
    
    _grandient = [CAGradientLayer layer];
    _grandient.colors = @[(id)[UIColor blueColor].CGColor,(id)[UIColor purpleColor].CGColor,(id)[UIColor greenColor].CGColor];
    _grandient.frame = _myLayer.bounds;
    _grandient.locations = @[@(0.0),@(0.4),@(0.7)];
    _grandient.startPoint = CGPointMake(0, 0);
    _grandient.endPoint = CGPointMake(1, 0);
    _grandient.mask = _myLayer;
    [self.view.layer addSublayer:_grandient];
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    
    // 复原
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0];
    _myLayer.strokeEnd = 0;
    [CATransaction commit];
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0.001];
    _myLayer.strokeEnd = sender.value;
    [CATransaction commit];
    
}


- (IBAction)dismissViewController:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
