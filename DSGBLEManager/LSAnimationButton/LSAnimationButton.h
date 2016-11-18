//
//  LSAnimationButton.h
//  AnimationButton
//
//  Created by LIUS on 16/6/20.
//  Copyright © 2016年 LIUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSAnimationButton;
@protocol LSAnimationButtonDelegate <NSObject>
/**
 *  动画刚开始的代理方法
 *
 *  @param AnimationButton
 */
- (void)LSAnimationButtonDidStartAnimation:(LSAnimationButton *)AnimationButton;
/**
 *  动画已经完成时候的代理方法
 *
 *  @param AnimationButton
 */
- (void)LSAnimationButtonDidFinishAnimation:(LSAnimationButton *)AnimationButton;
/**
 *  动画将要结束的时候的代理
 *
 *  @param AnimationButton
 */
- (void)LSAnimationButtonDidWillFinishAnimation:(LSAnimationButton *)AnimationButton;

@end

@interface LSAnimationButton : UIButton

@property (nonatomic, weak) id <LSAnimationButtonDelegate> delegate;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGFloat borderWidth;

- (void)startAnimation;

- (void)stopAnimation;



@end
