//
//  MRVLCPlayer.m
//  MRVLCPlayer
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "MRVLCPlayer.h"
#import "KRVideoPlayerControlView.h"

static const NSTimeInterval kVideoPlayerAnimationTimeinterval = 0.3f;

@interface MRVLCPlayer ()
{
    VLCTime *_totalTime;
    CGRect _originFrame;
}
@property (nonatomic,strong) VLCMediaPlayer *player;
@property (nonatomic, nonnull,strong) KRVideoPlayerControlView *controlView;
@end

@implementation MRVLCPlayer

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self setupPlayer];
    
    [self setupView];
    
    [self setupControlView];
}


#pragma mark - Public Method
- (void)showIn:(UIView *)view {
    
    [view addSubview:self];
    
    self.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerAnimationTimeinterval animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self play];
    }];
}

- (void)dismiss {
    
}

#pragma mark - Private Method
- (void)setupView {
    [self setBackgroundColor:[UIColor blackColor]];
}

- (void)setupPlayer {
    [self.player setDrawable:self];
    self.player.media = [[VLCMedia alloc] initWithURL:self.mediaURL];
}

- (void)setupControlView {

    [self addSubview:self.controlView];
    
    //添加控制界面的监听方法
    [self.controlView.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.progressSlider addTarget:self action:@selector(progressClick) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark Button Event
- (void)playButtonClick {
    
    [self play];
    self.controlView.playButton.hidden = YES;
    self.controlView.pauseButton.hidden = NO;
    
}

- (void)pauseButtonClick {
    
    [self pause];
    self.controlView.playButton.hidden = NO;
    self.controlView.pauseButton.hidden = YES;
}

- (void)closeButtonClick {
    
    [self.player stop];
    self.player.delegate = nil;
    self.player.drawable = nil;
    self.player = nil;
    
    [self removeFromSuperview];
    
}

- (void)fullScreenButtonClick {
    self.isFullscreenModel = YES;
}

- (void)shrinkScreenButtonClick {
    self.isFullscreenModel = NO;
}

- (void)progressClick {
    
    if (!_totalTime) { _totalTime = self.player.media.length; }
    
    int targetIntvalue = (int)(self.controlView.progressSlider.value * (float)_totalTime.intValue);
    
    VLCTime *targetTime = [[VLCTime alloc] initWithInt:targetIntvalue];
    
    [self.player setTime:targetTime];
}

#pragma mark Player Logic
- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    
}

#pragma mark - Delegate
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    if (self.player.media.state == VLCMediaStateBuffering) {
        self.controlView.indicatorView.hidden = NO;
    }else if (self.player.media.state == VLCMediaStatePlaying) {
        self.controlView.indicatorView.hidden = YES;
    }
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    
    [self bringSubviewToFront:self.controlView];
    
    if (self.controlView.progressSlider.state != UIControlStateNormal) {
        return;
    }

    if (!_totalTime) { _totalTime = self.player.media.length;}
    
    float precentValue = ([self.player.time.value floatValue]) / ([_totalTime.value floatValue]);
    
    [self.controlView.progressSlider setValue:precentValue animated:YES];
    
    [self.controlView.timeLabel setText:[NSString stringWithFormat:@"%@/%@",_player.time.stringValue,_totalTime.stringValue]];
}

#pragma mark - Property
- (VLCMediaPlayer *)player {
    if (!_player) {
        _player = [[VLCMediaPlayer alloc] init];
        _player.delegate = self;
    }
    return _player;
}

- (KRVideoPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[KRVideoPlayerControlView alloc] initWithFrame:self.bounds];
    }
    return _controlView;
}


- (void)setIsFullscreenModel:(BOOL)isFullscreenModel {
    
    if (_isFullscreenModel == isFullscreenModel) {
        return;
    }
    
    _isFullscreenModel = isFullscreenModel;
    
    if (isFullscreenModel) {
        //全屏模式
        _originFrame = self.frame;
        CGFloat height = [[UIScreen mainScreen] bounds].size.width;
        CGFloat width = [[UIScreen mainScreen] bounds].size.height;
        CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
        [UIView animateWithDuration:kVideoPlayerAnimationTimeinterval animations:^{
            self.frame = frame;
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.controlView.frame = self.bounds;
            [self.controlView layoutIfNeeded];
            self.controlView.fullScreenButton.hidden = YES;
            self.controlView.shrinkScreenButton.hidden = NO;
        } completion:^(BOOL finished) {}];
        
    }else {
        //自定义模式
        [UIView animateWithDuration:kVideoPlayerAnimationTimeinterval animations:^{
            self.transform = CGAffineTransformIdentity;
            self.frame = _originFrame;
            self.controlView.frame = self.bounds;
            [self.controlView layoutIfNeeded];
            self.controlView.fullScreenButton.hidden = NO;
            self.controlView.shrinkScreenButton.hidden = YES;
            
        } completion:^(BOOL finished) {}];

        
    }
    
    
}

@end
