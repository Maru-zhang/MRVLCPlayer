//
//  MRVideoHUDView.h
//  MRVLCPlayer
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRVideoHUDView : UIView

@end
@interface MRVideoAlertView : UIView
@property (nonatomic,strong) UILabel *msgLable;
+ (instancetype)shareInstance;
- (void)show;
@end
