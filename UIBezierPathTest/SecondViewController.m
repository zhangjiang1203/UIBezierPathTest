//
//  SecondViewController.m
//  UIBezierPathTest
//
//  Created by zjhaha on 16/2/15.
//  Copyright © 2016年 zjhaha. All rights reserved.
//

#import "SecondViewController.h"
#import <pop/POP.h>
#import "ThirdViewController.h"
#define KAngleToRadians(angle) (angle * M_PI)/180.0
@interface SecondViewController (){
    int angle;
}
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIView *testBackView;
@property (weak, nonatomic) IBOutlet UIView *testForntView;


@end

@implementation SecondViewController
//实现视图的斜切
CGAffineTransform CGAffineTransformMakeShear(CGFloat x,CGFloat y){
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.c = -x;
    transform.b = y;
    return transform;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    angle = 0;
    //加载旋转动画
    [self startAnimation];
    
    
    self.testBackView.layer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    self.testForntView.layer.transform =  CATransform3DMakeRotation(-M_PI_4, 0, 0, 1);
}


-(void)addMaskLayer{
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.myImageView.frame;
    UIImage *maskImage = [UIImage imageNamed:@"testImage2"];
    maskLayer.contents = (__bridge id _Nullable)(maskImage.CGImage);
    self.myImageView.layer.mask = maskLayer;
}

-(void) startAnimation{
    
    POPBasicAnimation *rotation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation1.beginTime = CACurrentMediaTime();
    rotation1.duration = 1;
    rotation1.toValue = @(M_PI);
    rotation1.repeatCount = HUGE_VALF;
    [self.myImageView.layer pop_addAnimation:rotation1 forKey:@"rotation"];
    
    
//    //系统调用动画执行
//    [UIView animateWithDuration:0.01 animations:^{
//         _myImageView.transform = CGAffineTransformMakeRotation(KAngleToRadians(angle));
//    } completion:^(BOOL finished) {
//        angle += 5;
//        [self startAnimation];
//    }];
}


- (IBAction)startDismiss:(UIButton*)sender {
    
    switch (sender.tag) {
        case 1:
        {
            ThirdViewController *VC = [[ThirdViewController alloc]initWithNibName:@"ThirdViewController" bundle:nil];
            [self presentViewController:VC animated:YES completion:nil];
        }
            break;
            
        case 2:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
    
}

-(void)dealloc{
    [self.view pop_removeAllAnimations];
}

@end
