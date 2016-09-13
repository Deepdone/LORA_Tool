//
//  CPShowPromptMessageTool.m
//  CarrierPigeon
//
//  Created by SlightlySweetPro on 15/7/23.
//  Copyright (c) 2015年 ColumbiaMobileComputing. All rights reserved.
//

#import "ShowPromptMessageTool.h"

@implementation ShowPromptMessageTool
//弹出框
+(void)showMessage:(NSString *)message
{
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
                UIWindow * window = [UIApplication sharedApplication].keyWindow;
                __block UIView *showview =  [[UIView alloc]init];
                showview.backgroundColor = [UIColor blackColor];
                showview.frame = CGRectMake(1, 1, 1, 1);
                showview.alpha = 0.0f;                  // 初始透明度
                showview.layer.cornerRadius = 3.5f;
                showview.layer.masksToBounds = YES;
                [window addSubview:showview];
            
                UILabel *label = [[UILabel alloc]init];
//            CGSize LabelSize = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
                CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];             // 根据文本计算显示框大小
                label.frame           = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
                label.text            = message;
                label.numberOfLines   = 0;
                label.textColor       = [UIColor whiteColor];
                label.textAlignment   = 1;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont boldSystemFontOfSize:15];
                [showview addSubview:label];
                showview.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - LabelSize.width - 20)/2, [UIScreen mainScreen].bounds.size.height - 100, LabelSize.width+20, LabelSize.height+10);
                
                [UIView animateWithDuration:0.8 animations:^{         // 动画显示
                    showview.alpha = 0.6;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.8 animations:^{  // 动画消失
                        showview.alpha = 0;
                    } completion:^(BOOL finished) {
                        showview = nil;
                        [showview removeFromSuperview];
                    }];
                }];
   
        });
    }
    else{
        
     __block   UIWindow * window = [UIApplication sharedApplication].keyWindow;
        __block UIView *showview =  [[UIView alloc]init];
        showview.backgroundColor = [UIColor blackColor];
        showview.frame = CGRectMake(1, 1, 1, 1);
        showview.alpha = 0.0f;                  // 初始透明度
        showview.layer.cornerRadius = 3.5f;
        showview.layer.masksToBounds = YES;
        [window addSubview:showview];
        
        UILabel *label = [[UILabel alloc]init];
//        CGSize LabelSize = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
        CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];             // 根据文本计算显示框大小
        label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
        label.text = message;
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = 1;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:15];
        [showview addSubview:label];
        showview.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - LabelSize.width - 20)/2, [UIScreen mainScreen].bounds.size.height - 100, LabelSize.width+20, LabelSize.height+10);
        
        [UIView animateWithDuration:0.8 animations:^{         // 动画显示
            showview.alpha = 0.6;
        } completion:^(BOOL finished) {
            __strong __block __typeof(showview)strongShowView = showview;
            [UIView animateWithDuration:0.8 animations:^{  // 动画消失
                strongShowView.alpha = 0;
            } completion:^(BOOL finished) {
                [strongShowView removeFromSuperview];
                strongShowView = nil;
            }];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [showview removeFromSuperview];
            showview = nil;
        });
    }

   }
@end
