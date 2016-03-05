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
    
    player.frame = CGRectMake(0, 0, 375, 375 / 16 * 9);
    
    player.mediaURL = [NSURL URLWithString:@"http://113.215.3.11/youku/65731F487423A8313FB9C5375E/030008070056D90DFE0A0C03BAF2B1C2B40EEC-6325-B612-C7B6-10B4F9BE70B3.mp4"];
    
    [player showIn:self.view];
}

- (void)viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
