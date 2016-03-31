//
//  RemoteViewController.m
//  MRVLCPlayer
//
//  Created by Maru on 16/3/20.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "RemoteViewController.h"
#import "MRVLCPlayer.h"

@implementation RemoteViewController

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self prefersStatusBarHidden];
        
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        
    }
}

- (IBAction)remotePlay:(id)sender {

    MRVLCPlayer *player = [[MRVLCPlayer alloc] init];
    
    player.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9);
    player.center = self.view.center;
    player.mediaURL = [NSURL URLWithString:@"http://202.198.176.113/video002/2015/mlrs.rmvb"];
    
    [player showInView:self.view.window];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
