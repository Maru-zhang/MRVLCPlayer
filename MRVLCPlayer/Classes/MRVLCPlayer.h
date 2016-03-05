//
//  MRVLCPlayer.h
//  MRVLCPlayer
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>

@interface MRVLCPlayer : UIView <VLCMediaPlayerDelegate>

@property (nonatomic,strong,nonnull) NSURL *mediaURL;
@property (nonatomic,assign) BOOL isFullscreenModel;


- (void)showIn:(UIView * _Nonnull)view;

@end
