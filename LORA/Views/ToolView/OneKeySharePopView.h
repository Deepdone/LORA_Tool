//
//  OneKeySharePopView.h
//  IceboxPartner
//
//  Created by SlightlySweetPro on 16/8/12.
//  Copyright © 2016年 SlightlySweet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeftMenuController;

@protocol OneKeySharePopViewDelegate<NSObject>

- (void)oneKeyShare:(UIButton *)sender;
@end


@interface OneKeySharePopView : UIView
@property (nonatomic,weak) LeftMenuController <OneKeySharePopViewDelegate> *delegate;


- (void)show;
- (void)hide;
@end
