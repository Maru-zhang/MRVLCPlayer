//
//  ViewController.m
//  MRVLCPlayer
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "ViewController.h"
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

    MRVLCPlayer *player = [[MRVLCPlayer alloc] init];
    
    player.frame = CGRectMake(0, 100, 375, 375 / 16 * 9);
    
    player.mediaURL = [NSURL URLWithString:@"http://202.198.176.113/video/v8/jlp/zjkx/0901.rmvb"];
    
    [player showIn:self.view];
}

- (void)viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
