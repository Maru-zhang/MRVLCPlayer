//
//  LocalViewConrtoller.m
//  MRVLCPlayer
//
//  Created by Maru on 16/3/20.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "LocalViewConrtoller.h"
#import "MRVLCPlayer.h"

@implementation LocalViewConrtoller

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self prefersStatusBarHidden];
        
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        
    }
    
}

- (IBAction)localPlay:(id)sender {
    
    MRVLCPlayer *player = [[MRVLCPlayer alloc] init];
    
    player.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9);
    player.center = self.view.center;
    player.mediaURL = [[NSBundle mainBundle] URLForResource:@"02" withExtension:@"mov"];

    [player showInView:self.view.window];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
