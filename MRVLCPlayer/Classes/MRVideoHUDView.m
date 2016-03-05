//
//  MRVideoHUDView.m
//  MRVLCPlayer
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "MRVideoHUDView.h"

#define kHUDCenter CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);

static const NSTimeInterval kHUDCycleTimeInterval = 0.8f;
static const CGFloat kHUDCycleLineWidth = 3.0f;

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
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setupAnimation];
}


- (void)setupAnimation {
    
    _leftLayer = [CAShapeLayer layer];
    _leftLayer.bounds = CGRectMake(0, 0, [self getCycleLayerSize].width, [self getCycleLayerSize].height);
    _leftLayer.position = kHUDCenter;
    _leftLayer.fillColor = [UIColor clearColor].CGColor;
    _leftLayer.strokeColor = [UIColor whiteColor].CGColor;
    _leftLayer.lineWidth = kHUDCycleLineWidth;
    _leftLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, [self getCycleLayerSize].width, [self getCycleLayerSize].height)].CGPath;
    _leftLayer.strokeEnd = 0.25;
    
    _rightLayer = [CAShapeLayer layer];
    _rightLayer.bounds = CGRectMake(0, 0, [self getCycleLayerSize].width, [self getCycleLayerSize].height);
    _rightLayer.position = kHUDCenter;
    _rightLayer.fillColor = [UIColor clearColor].CGColor;
    _rightLayer.strokeColor = [UIColor whiteColor].CGColor;
    _rightLayer.lineWidth = kHUDCycleLineWidth;
    _rightLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, [self getCycleLayerSize].width, [self getCycleLayerSize].height)].CGPath;
    _rightLayer.strokeStart = 0.5;
    _rightLayer.strokeEnd = 0.75;
    
    CAGradientLayer *gLayer_l = [CAGradientLayer layer];
    gLayer_l.backgroundColor = [UIColor redColor].CGColor;
    gLayer_l.bounds = self.bounds;
    gLayer_l.position = kHUDCenter;
    gLayer_l.colors = @[(id)[UIColor cyanColor].CGColor,
                        (id)[UIColor orangeColor].CGColor,
                        (id)[UIColor yellowColor].CGColor];
    
    CAGradientLayer *gLayer_r = [CAGradientLayer layer];
    gLayer_r.backgroundColor = [UIColor redColor].CGColor;
    gLayer_r.bounds = self.bounds;
    gLayer_r.position = kHUDCenter;
    gLayer_r.colors = @[(id)[UIColor yellowColor].CGColor,
                        (id)[UIColor orangeColor].CGColor,
                        (id)[UIColor cyanColor].CGColor];
    
    gLayer_l.mask = _leftLayer;
    gLayer_r.mask = _rightLayer;
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    animation.duration = kHUDCycleTimeInterval;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    
    [_rightLayer addAnimation:animation forKey:nil];
    [_leftLayer addAnimation:animation forKey:nil];
    
    [self.layer addSublayer:gLayer_l];
    [self.layer addSublayer:gLayer_r];
    
}

- (CGSize)getCycleLayerSize {
    return CGSizeMake(CGRectGetWidth(self.bounds) - kHUDCycleLineWidth, CGRectGetHeight(self.bounds) - kHUDCycleLineWidth);
}

@end
