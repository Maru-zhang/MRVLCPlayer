//
//  KRVLCMediaController.m
//  MRVLCVideoPlayer
//
//  Created by Maru on 15/9/17.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "MRVLCMediaController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "KRVideoPlayerControlView.h"

#define KConW self.view.frame.size.width

@interface MRVLCMediaController () <VLCMediaPlayerDelegate>
{
    VLCTime *_totalTime;
    CGRect _originFrame;
}

@property (nonatomic,strong) UIView *displayView;
@property (nonatomic,strong) VLCMediaPlayer *vlcPlayer;
@property (nonatomic,strong) KRVideoPlayerControlView *controlView;

@end

@implementation MRVLCMediaController

#pragma mark - Life Cycyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBaseView];
    
    [self setupPlayer];
    
    [self setupControlView];
}


#pragma mark - Private Method
- (void)setupBaseView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.displayView];
    
    //隐藏状态栏
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setupPlayer {
    
    self.vlcPlayer.drawable = self.displayView;
    self.vlcPlayer.delegate = self;
    
    NSAssert(self.mediaURL != nil,@"url参数为空！");
    
    [_vlcPlayer setMedia:[[VLCMedia alloc] initWithURL:self.mediaURL]];
    
    //默认打开自动播放
    [self playButtonClick];
    
}

- (void)setupControlView {
    
    self.controlView.frame = self.displayView.frame;
    
    [self.view addSubview:self.controlView];
    
    //添加控制界面的监听方法
    [self.controlView.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.progressSlider addTarget:self action:@selector(progressClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)playButtonClick {
    
    [_vlcPlayer play];
    self.controlView.playButton.hidden = YES;
    self.controlView.pauseButton.hidden = NO;
    
}

- (void)pauseButtonClick {
    
    [_vlcPlayer pause];
    self.controlView.playButton.hidden = NO;
    self.controlView.pauseButton.hidden = YES;
}

- (void)closeButtonClick {
    
    _vlcPlayer.delegate = nil;
    
    [_vlcPlayer stop];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)fullScreenButtonClick {
    self.isFullscreenModel = YES;
}

- (void)shrinkScreenButtonClick {
    self.isFullscreenModel = NO;
}

- (void)progressClick {
    
    if (!_totalTime) {
        _totalTime = _vlcPlayer.media.length;
    }
    
    int targetIntvalue = (int)(self.controlView.progressSlider.value * (float)_totalTime.intValue);
    
    VLCTime *targetTime = [[VLCTime alloc] initWithInt:targetIntvalue];
    
    [_vlcPlayer setTime:targetTime];
}

#pragma mark - Override
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Delegate
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    
    if (!_totalTime) {
        _totalTime = _vlcPlayer.media.length;
    }

    float precentValue = (float(_vlcPlayer.time.intValue) / float(_totalTime.intValue));
    
    [self.controlView.progressSlider setValue:precentValue animated:YES];
    
    [self.controlView.timeLabel setText:[NSString stringWithFormat:@"%@:%@",_vlcPlayer.time.stringValue,_totalTime.stringValue]];
    
    NSLog(@"%d/%d====%f",_vlcPlayer.time.intValue,_totalTime.intValue,precentValue);
    
}

#pragma mark - property
- (VLCMediaPlayer *)vlcPlayer {
    
    if (!_vlcPlayer) {
        
        _vlcPlayer = [[VLCMediaPlayer alloc] init];
        
    }
    
    return _vlcPlayer;
}

- (UIView *)displayView {
    
    if (!_displayView) {
        
        _displayView = [[UIView alloc] init];
        
        _displayView.backgroundColor = [UIColor blackColor];
        
        _displayView.frame = CGRectMake(0, 0, KConW, (KConW /16) * 9);
    }
    
    return _displayView;
}

- (KRVideoPlayerControlView *)controlView {
    
    if (!_controlView) {
        
        _controlView = [[KRVideoPlayerControlView alloc] init];
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
        _originFrame = self.displayView.frame;
        CGFloat height = [[UIScreen mainScreen] bounds].size.width;
        CGFloat width = [[UIScreen mainScreen] bounds].size.height;
        CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
        [UIView animateWithDuration:0.3f animations:^{
            self.displayView.frame = frame;
            [self.displayView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            self.controlView.frame = frame;
            [self.controlView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            [self.controlView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.controlView.fullScreenButton.hidden = YES;
            self.controlView.shrinkScreenButton.hidden = NO;
        }];
        
    }else {
        //自定义模式
        [UIView animateWithDuration:0.3f animations:^{
            [self.displayView setTransform:CGAffineTransformIdentity];
            self.displayView.frame = _originFrame;
            [self.controlView setTransform:CGAffineTransformIdentity];
            self.controlView.frame = _originFrame;
            [self.controlView layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.controlView.fullScreenButton.hidden = NO;
            self.controlView.shrinkScreenButton.hidden = YES;
        }];
    }
    
    NSLog(@"%d",self.isFullscreenModel);

}



@end
