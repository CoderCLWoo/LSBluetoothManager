//
//  LSAnimationButton.m
//  AnimationButton
//
//  Created by LIUS on 16/6/20.
//  Copyright © 2016年 LIUS. All rights reserved.
//

#import "LSAnimationButton.h"
#import "LSBorderAnimationCircleView.h"

@interface LSAnimationButton(){
    
}

@property (nonatomic, assign) CGRect originRect;

@property (nonatomic, strong) LSBorderAnimationCircleView *circleView;

@end


static NSTimeInterval kStartAnimationDuration = 0.3;
static NSTimeInterval kEndAnimationDuration = 0.5;


@implementation LSAnimationButton
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize originRect = _originRect;

- (LSBorderAnimationCircleView *)circleView{
    if (_circleView == nil) {
        _circleView = [[LSBorderAnimationCircleView alloc]viewWithButton:self];
        [self addSubview:_circleView];
    }
    return _circleView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = NO;
        self.originRect = self.frame;
    }
    return self;
}

- (void)startAnimation{
    CGPoint center = self.center;
    CGFloat width = self.layer.cornerRadius * 2;
    CGFloat height = self.frame.size.height;
    CGRect frame = CGRectMake(center.x - width / 2, center.y - height / 2, width, height);
    
    self.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(LSAnimationButtonDidStartAnimation:)]) {
        [self.delegate LSAnimationButtonDidStartAnimation:self];
    }
    
    [UIView animateWithDuration:kStartAnimationDuration animations:^{
        self.titleLabel.alpha = 0.0f;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self.circleView startAnimation];
    }];
}

- (void)stopAnimation{
    self.userInteractionEnabled = YES;
    
    if ([self.delegate respondsToSelector:@selector(LSAnimationButtonDidWillFinishAnimation:)]) {
        [self.delegate LSAnimationButtonDidWillFinishAnimation:self];
    }
    
    [self.circleView removeFromSuperview];
    self.circleView  = nil;
    
    [UIView animateWithDuration:kEndAnimationDuration animations:^{
        self.frame = _originRect;
        self.titleLabel.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(LSAnimationButtonDidFinishAnimation:)]) {
            [self.delegate LSAnimationButtonDidFinishAnimation:self];
        }
    }];
}



@end
