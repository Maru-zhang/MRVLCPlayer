//
//  MRProgressSlider.m
//  MRVLCPlayer
//
//  Created by Maru on 16/3/8.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "MRProgressSlider.h"

static const CGFloat MRProgressWidth = 8.0f;

@implementation MRProgressSlider

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 0;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, self.bounds.size.height / 2 - MRProgressWidth / 2, self.bounds.size.width, MRProgressWidth);
}

@end
