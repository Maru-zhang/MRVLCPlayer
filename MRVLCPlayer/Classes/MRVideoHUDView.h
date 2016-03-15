//
//  MRVideoHUDView.h
//  MRVLCPlayer
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHUDCenter CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);

@interface MRVideoHUDView : UIView

@end
@interface MRVideoAlertView : UIView
@property (nonatomic,strong) UILabel *msgLable;
+ (instancetype)shareInstance;
- (void)show;
@end
