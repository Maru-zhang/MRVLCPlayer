//
//  ViewController.m
//  MRVLCPlayer
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "ViewController.h"
#import "MRVLCMediaController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
 
}

- (void)viewDidAppear:(BOOL)animated {
    MRVLCMediaController *vc = [[MRVLCMediaController alloc] init];
    
    vc.mediaURL = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
