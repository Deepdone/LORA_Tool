//
//  MMWebViewProgressView.h
//  SmartKit
//
//  Created by SlightlySweetPro on 16/1/21.
//  Copyright © 2016年 Winext Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMWebViewProgressView : UIView


@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView;

@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
