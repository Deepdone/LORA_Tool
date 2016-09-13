//
//  UIImage+CreateImage.h
//  IceboxPartner
//
//  Created by SlightlySweetPro on 16/7/27.
//  Copyright © 2016年 SlightlySweet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CreateImage)

/**
 *  创建纯色Image
 *
 *  @param color 颜色
 *
 *  @return 返回Image
 */
+(UIImage*) createImageWithColor:(UIColor*) color andRect:(CGRect)rect;




+ (void)imageTurnCornerRadiusWith:(UIView *)view andImage:(UIImage *)image andRadius:(CGFloat)R backImageBlock:(void(^)(UIImage *img))backImageBlock;

/**
 *  view  --- > image
 *
 *  @param view view源
 *
 *  @return 返回image
 */
+ (UIImage *)getImageFromView:(UIView *)view;


@end
