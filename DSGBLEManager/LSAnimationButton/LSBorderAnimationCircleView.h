//
//  LSBorderAnimationCircleView.h
//  AnimationButton
//
//  Created by LIUS on 16/6/20.
//  Copyright © 2016年 LIUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSBorderAnimationCircleView : UIView
/**
 *  初始化方法
 *
 *  @param button 根据传入的 button 来生成 circleview
 *
 *  @return 返回 CircleView
 */
- (instancetype)viewWithButton:(UIButton *)button;

/**
 *  CircleView 开始动画
 */
- (void)startAnimation;

@end
