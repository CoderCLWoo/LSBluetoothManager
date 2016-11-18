//
//  LSBorderAnimationCircleView.m
//  AnimationButton
//
//  Created by LIUS on 16/6/20.
//  Copyright © 2016年 LIUS. All rights reserved.
//

#import "LSBorderAnimationCircleView.h"


@interface LSBorderAnimationCircleView()

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGFloat timeFlag;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LSBorderAnimationCircleView
@synthesize borderColor = _borderColor;
@synthesize timer = _timer;
@synthesize timeFlag = _timeFlag;

- (instancetype)viewWithButton:(UIButton *)button{
    LSBorderAnimationCircleView *circleView = [[LSBorderAnimationCircleView alloc]init];
    circleView.frame = CGRectMake(-8, -8, button.frame.size.width + 16, button.frame.size.height + 16);
    circleView.backgroundColor = [UIColor clearColor];
    circleView.borderColor = button.titleLabel.textColor;
    circleView.timeFlag = 0;
    return circleView;
}

- (void)removeFromSuperview{
    [_timer invalidate];
    [super removeFromSuperview];
}

- (void)startAnimation{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(circleViewContinueAnimation) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)circleViewContinueAnimation{
    _timeFlag = _timeFlag + 0.02;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    
    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius = rect.size.width / 2 - 2;
    CGFloat start = - M_PI_2 + _timeFlag * 2 * M_PI;
    CGFloat end = -M_PI_2 + 0.45 * 2 * M_PI + _timeFlag * 2 * M_PI;
    
    [path addArcWithCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    
    [_borderColor setStroke];
    path.lineWidth = 1.5;
    
    [path stroke];
}
@end
