//
//  KRVLCMediaController.h
//  MRVLCVideoPlayer
//
//  Created by Maru on 15/9/17.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRVLCMediaController : UIViewController

@property (nonatomic,strong) NSURL *mediaURL;
@property (nonatomic,assign) BOOL isFullscreenModel;

@end
