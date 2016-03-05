//
//  ViewController.m
//  MRVLCPlayer
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "ViewController.h"
#import "MRVLCMediaController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "MRVLCPlayer.h"

@interface ViewController ()
{
    VLCMediaPlayer *_vlcPlayer;
    UIView *testView;
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    
//    testView.backgroundColor = [UIColor redColor];
//    
//    [self.view addSubview:testView];
//    
//    
//    _vlcPlayer = [[VLCMediaPlayer alloc] initWithOptions:nil];
//    _vlcPlayer.drawable = testView;
//    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString: @"rtmp://live.hkstv.hk.lxdns.com/live/hks"]];
//    [_vlcPlayer setMedia:media];
//    [_vlcPlayer play];
    


    
}

- (void)viewDidAppear:(BOOL)animated {
//    MRVLCMediaController *vc = [[MRVLCMediaController alloc] init];
//    vc.mediaURL = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
//    [self presentViewController:vc animated:YES completion:nil];
    
    MRVLCPlayer *player = [[MRVLCPlayer alloc] init];
    
    player.frame = CGRectMake(0, 0, 375, 375 / 16 * 9);
    
    player.mediaURL = [NSURL URLWithString:@"http://113.215.3.11/youku/65731F487423A8313FB9C5375E/030008070056D90DFE0A0C03BAF2B1C2B40EEC-6325-B612-C7B6-10B4F9BE70B3.mp4"];
    
    [player showIn:[UIApplication sharedApplication].keyWindow];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
