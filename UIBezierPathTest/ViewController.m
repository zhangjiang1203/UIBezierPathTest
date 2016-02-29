//
//  ViewController.m
//  UIBezierPathTest
//
//  Created by zjhaha on 16/2/15.
//  Copyright © 2016年 zjhaha. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "MaskAnimation.h"
@interface ViewController ()<UIViewControllerTransitioningDelegate>
@property (strong,nonatomic)MaskAnimation *maskAnimation;
@property (weak, nonatomic) IBOutlet UIButton *bubbleBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maskAnimation = [[MaskAnimation alloc]init];
    self.view.backgroundColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.9 alpha:1.0];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(110, 100, 200, 200) cornerRadius:50];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    
    [self.view.layer addSublayer:layer];
    
    //绘制曲线
    CGPoint startPoint = CGPointMake(100, 300);
    CGPoint endPoint = CGPointMake(300, 300);
    CGPoint controlPoint = CGPointMake(200, 200);
    
    UIBezierPath *controlPath = [UIBezierPath bezierPath];
    [controlPath moveToPoint:startPoint];
    [controlPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    CAShapeLayer *controlLayer = [CAShapeLayer layer];
    controlLayer.fillColor = [UIColor clearColor].CGColor;
    controlLayer.strokeColor = [UIColor redColor].CGColor;
    controlLayer.path = controlPath.CGPath;
    
    [self.view.layer addSublayer:controlLayer];
    //开始变换到结束
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation1.fromValue = @(0.5);
    animation1.toValue = @(0.0);
    animation1.duration = 1.5;
    [controlLayer addAnimation:animation1 forKey:@"strokeStart"];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.fromValue = @(0.5);
    animation2.toValue = @(1);
    animation2.duration = 1.5;
    [controlLayer addAnimation:animation2 forKey:@"strokeEnd"];
    
    //创建一个不规则的底部图像
    CGSize finalSize = CGSizeMake(CGRectGetWidth(self.view.frame), 500);
    CGFloat layerHeight = finalSize.height*0.2;
    UIBezierPath *shapePath = [UIBezierPath bezierPath];
    [shapePath moveToPoint:CGPointMake(0, finalSize.height - layerHeight)];
    [shapePath addLineToPoint:CGPointMake(0, finalSize.height - 1)];
    [shapePath addLineToPoint:CGPointMake(finalSize.width, finalSize.height -1)];
    [shapePath addLineToPoint:CGPointMake(finalSize.width, finalSize.height-layerHeight)];
    [shapePath addQuadCurveToPoint:CGPointMake(0, finalSize.height - layerHeight) controlPoint:CGPointMake(finalSize.width/2, (finalSize.height - layerHeight)-40)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = shapePath.CGPath;
    shapeLayer.fillColor = [UIColor colorWithRed:0.1 green:0.9 blue:0.5 alpha:1].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (IBAction)startPresent:(id)sender {
    
    SecondViewController *vc = [[SecondViewController alloc]initWithNibName:@"SecondViewController" bundle:nil];
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.maskAnimation.animationType = KViewControllerDismiss;
    self.maskAnimation.startPoint = self.bubbleBtn.center;
    return self.maskAnimation;
}


-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.maskAnimation.animationType = KViewControllerPresent;
    self.maskAnimation.startPoint = self.bubbleBtn.center;
    return self.maskAnimation;
}

@end
