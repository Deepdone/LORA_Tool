//
//  MMWebViewProgress.h
//  SmartKit
//
//  Created by SlightlySweetPro on 16/1/21.
//  Copyright © 2016年 Winext Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#undef mm_weak
#if __has_feature(objc_arc_weak)
#define mm_weak weak
#else
#define mm_weak unsafe_unretained
#endif

extern const float NJKInitialProgressValue;
extern const float NJKInteractiveProgressValue;
extern const float NJKFinalProgressValue;

typedef void (^MMWebViewProgressBlock)(float progress);

@protocol MMWebViewProgressDelegate;



@interface MMWebViewProgress : NSObject<UIWebViewDelegate>

@property (nonatomic, mm_weak) id<MMWebViewProgressDelegate> progressDelegate;

@property (nonatomic, mm_weak) id<UIWebViewDelegate        > webViewProxyDelegate;

@property (nonatomic, copy    ) MMWebViewProgressBlock    progressBlock;

@property (nonatomic, readonly) float progress;// 0.0..1.0

- (void)reset;

@end


@protocol MMWebViewProgressDelegate <NSObject>

- (void)webViewProgress:(MMWebViewProgress *)webViewProgress updateProgress:(float)progress;

@end