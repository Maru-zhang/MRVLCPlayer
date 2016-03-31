//
//  MRVideoControl.m
//  MRVLCPlayer
//
//  Created by Maru on 16/3/8.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "MRVideoControlView.h"

#define MRRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

static const CGFloat MRProgressWidth = 3.0f;
static const CGFloat MRVideoControlBarHeight = 40.0;
static const CGFloat MRVideoControlSliderHeight = 10.0;
static const CGFloat MRVideoControlAnimationTimeinterval = 0.3;
static const CGFloat MRVideoControlTimeLabelFontSize = 10.0;
static const CGFloat MRVideoControlBarAutoFadeOutTimeinterval = 4.0;
static const CGFloat MRVideoControlCorrectValue = 3;


@interface MRVideoControlView ()
@property (nonatomic,strong) MRVideoAlertView *alertView;
@end
@implementation MRVideoControlView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.topBar.frame             = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), MRVideoControlBarHeight);
    self.closeButton.frame        = CGRectMake(CGRectGetWidth(self.topBar.bounds) - CGRectGetWidth(self.closeButton.bounds), CGRectGetMinX(self.topBar.bounds), CGRectGetWidth(self.closeButton.bounds), CGRectGetHeight(self.closeButton.bounds));
    self.bottomBar.frame          = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - MRVideoControlBarHeight, CGRectGetWidth(self.bounds), MRVideoControlBarHeight);
    self.progressSlider.frame     = CGRectMake(0, -0, CGRectGetWidth(self.bounds), MRVideoControlSliderHeight);
    self.playButton.frame         = CGRectMake(CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2 + CGRectGetHeight(self.progressSlider.frame) * 0.6, CGRectGetWidth(self.playButton.bounds), CGRectGetHeight(self.playButton.bounds));
    self.pauseButton.frame        = self.playButton.frame;
    self.fullScreenButton.frame   = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds) - 5, self.playButton.frame.origin.y, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    self.indicatorView.center     = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    self.timeLabel.frame          = CGRectMake(CGRectGetMaxX(self.playButton.frame), self.playButton.frame.origin.y, CGRectGetWidth(self.bottomBar.bounds), CGRectGetHeight(self.timeLabel.bounds));
    self.alertView.center         = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}


#pragma mark - Public Method
- (void)animateHide
{
    [UIView animateWithDuration:MRVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 0;
        self.bottomBar.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

- (void)animateShow
{
    [UIView animateWithDuration:MRVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 1;
        self.bottomBar.alpha = 1;
    } completion:^(BOOL finished) {
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:MRVideoControlBarAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}


#pragma mark - Private Method
- (void)setupView {
    
    self.backgroundColor = [UIColor clearColor];

    [self.layer addSublayer:self.bgLayer];
    [self addSubview:self.topBar];
    [self addSubview:self.indicatorView];
    [self addSubview:self.bottomBar];
    [self addSubview:self.indicatorView];
    [self addSubview:self.alertView];

    [self.topBar    addSubview:self.closeButton];
    [self.bottomBar addSubview:self.playButton];
    [self.bottomBar addSubview:self.pauseButton];
    [self.bottomBar addSubview:self.fullScreenButton];
    [self.bottomBar addSubview:self.shrinkScreenButton];
    [self.bottomBar addSubview:self.progressSlider];
    [self.bottomBar addSubview:self.timeLabel];
    
    self.pauseButton.hidden = YES;
    self.shrinkScreenButton.hidden = YES;
}


- (void)responseTapImmediately {
    self.bottomBar.alpha == 0 ? [self animateShow] : [self animateHide];
}

#pragma mark - Override
#pragma mark Touch Event

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    CGPoint prePoint = [touch previousLocationInView:self];
    
    CGFloat d_value_x = nowPoint.x - prePoint.x;
    CGFloat d_value_y = nowPoint.y - prePoint.y;
    
    if (ABS(d_value_x) > ABS(d_value_y)) {
            [self.topBar setHidden:NO];
            [self.bottomBar setHidden:NO];
        if (d_value_x > MRVideoControlCorrectValue) {
            if ([_delegate respondsToSelector:@selector(controlViewFingerMoveRight)]) {
                [self.delegate controlViewFingerMoveRight];
            }
        }else if(d_value_x < - MRVideoControlCorrectValue) {
            if ([_delegate respondsToSelector:@selector(controlViewFingerMoveLeft)]) {
                [self.delegate controlViewFingerMoveLeft];
            }
        }
    }else {
        
        if (nowPoint.x > kMRSCREEN_BOUNDS.size.width / 2) {
            // 音量大小
            if (d_value_y > MRVideoControlCorrectValue) {
                if ([_delegate respondsToSelector:@selector(controlViewFingerMoveDown)]) {
                    [self.delegate controlViewFingerMoveDown];
                }
            }else if(d_value_y < - MRVideoControlCorrectValue) {
                if ([_delegate respondsToSelector:@selector(controlViewFingerMoveUp)]) {
                    [self.delegate controlViewFingerMoveUp];
                }
            }
        }else {
            // 亮度大小
            if (d_value_y > MRVideoControlCorrectValue) {
                [UIScreen mainScreen].brightness -= 0.01;
            }else if(d_value_y < - MRVideoControlCorrectValue) {
                [UIScreen mainScreen].brightness += 0.01;
            }
        }
        
        
    }
    
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:MRVideoControlBarAutoFadeOutTimeinterval];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.tapCount > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self responseTapImmediately];
        });

    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self responseTapImmediately];
}

#pragma mark - Property
- (MRVideoHUDView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[MRVideoHUDView alloc] init];
        _indicatorView.bounds = CGRectMake(0, 0, 100, 100);
    }
    return _indicatorView;
}

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = MRRGB(27, 27, 27);
    }
    return _bottomBar;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"Play Icon"] forState:UIControlStateNormal];
        _playButton.bounds = CGRectMake(0, 0, MRVideoControlBarHeight, MRVideoControlBarHeight);
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"Pause Icon"] forState:UIControlStateNormal];
        _pauseButton.bounds = CGRectMake(0, 0, MRVideoControlBarHeight, MRVideoControlBarHeight);
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"Full Screen Icon"] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, MRVideoControlBarHeight, MRVideoControlBarHeight);
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton
{
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:@"Min. Icon"] forState:UIControlStateNormal];
        _shrinkScreenButton.bounds = CGRectMake(0, 0, MRVideoControlBarHeight, MRVideoControlBarHeight);
    }
    return _shrinkScreenButton;
}


- (MRProgressSlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[MRProgressSlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"Player Control Nob"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:MRRGB(239, 71, 94)];
        [_progressSlider setMaximumTrackTintColor:MRRGB(157, 157, 157)];
        [_progressSlider setBackgroundColor:[UIColor clearColor]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"Player close"] forState:UIControlStateNormal];
        _closeButton.bounds = CGRectMake(0, 0, MRVideoControlBarHeight, MRVideoControlBarHeight);
    }
    return _closeButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:MRVideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.bounds = CGRectMake(0, 0, MRVideoControlTimeLabelFontSize, MRVideoControlBarHeight);
    }
    return _timeLabel;
}

- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
        _bgLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Video Bg"]].CGColor;
        _bgLayer.bounds = self.frame;
        _bgLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    }
    return _bgLayer;
}

- (UISlider *)volumeSlider {
    if (!_volumeSlider) {
        for (UIControl *view in self.volumeView.subviews) {
            if ([view.superclass isSubclassOfClass:[UISlider class]]) {
                _volumeSlider = (UISlider *)view;
            }
        }
    }
    return _volumeSlider;
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
    }
    return _volumeView;
}

- (MRVideoAlertView *)alertView {
    if (!_alertView) {
        _alertView = [MRVideoAlertView shareInstance];
        _alertView.bounds = CGRectMake(0, 0, 100, 50);
    }
    return _alertView;
}

@end
@implementation MRProgressSlider
- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, self.bounds.size.height * 0.8, self.bounds.size.width, MRProgressWidth);
}

@end