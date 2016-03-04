//
//  MRVideoHUDView.m
//  MRVLCPlayer
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "MRVideoHUDView.h"


@interface MRVideoHUDView ()
{
    CAShapeLayer *_leftLayer;
    CAShapeLayer *_rightLayer;
}
@end
@implementation MRVideoHUDView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupAnimation];
    }
    return self;
}


- (void)setupAnimation {
    
    _leftLayer = [CAShapeLayer layer];
    _leftLayer.frame = self.bounds;
    _leftLayer.fillColor = [UIColor clearColor].CGColor;
    _leftLayer.strokeColor = [UIColor whiteColor].CGColor;
    _leftLayer.lineWidth = 2.0f;
    _leftLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)].CGPath;
    _leftLayer.strokeEnd = 0.25;
    
    _rightLayer = [CAShapeLayer layer];
    _rightLayer.frame = self.bounds;
    _rightLayer.fillColor = [UIColor clearColor].CGColor;
    _rightLayer.strokeColor = [UIColor whiteColor].CGColor;
    _rightLayer.lineWidth = 2.0f;
    _rightLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)].CGPath;
    _rightLayer.strokeStart = 0.5;
    _rightLayer.strokeEnd = 0.75;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    animation.duration = 2.0f;
    animation.repeatCount = 0;
    animation.fromValue = [NSNumber numberWithFloat:M_PI];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    
    [_rightLayer addAnimation:animation forKey:nil];
    [_leftLayer addAnimation:animation forKey:nil];
    
    [self.layer addSublayer:_rightLayer];
    [self.layer addSublayer:_leftLayer];
    
    
    
}

@end
