//
//  MaskAnimation.h
//  UIBezierPathTest
//
//  Created by zjhaha on 16/2/15.
//  Copyright © 2016年 zjhaha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    KViewControllerPresent,
    KViewControllerDismiss,
    KViewControllerPop
}KViewControllerType;

@interface MaskAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign)CGPoint startPoint;

@property (nonatomic, assign) KViewControllerType animationType;

@end
