//
//  UIImage+CreateImage.m
//  IceboxPartner
//
//  Created by SlightlySweetPro on 16/7/27.
//  Copyright © 2016年 SlightlySweet. All rights reserved.
//

#import "UIImage+CreateImage.h"

@implementation UIImage (CreateImage)

/**
 *  获取纯色图
 *
 *  @param color 颜色
 *
 *  @return 返回纯色图
 */
+(UIImage*) createImageWithColor:(UIColor*) color andRect:(CGRect)rect
{
    if (!rect.size.width) {
        rect=CGRectMake(0.0f, 0.0f, 2.0f, 2.0f);
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (void)imageTurnCornerRadiusWith:(UIView *)view andImage:(UIImage *)image andRadius:(CGFloat)R backImageBlock:(void(^)(UIImage *img))backImageBlock{
    
    
    CGRect viewF = view.frame;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(viewF.size, NO, [UIScreen mainScreen].scale);
       
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewF.size.width, viewF.size.height) cornerRadius:R] addClip];
        [image drawInRect:CGRectMake(0, 0, viewF.size.width, viewF.size.height)];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
       
        if (backImageBlock) {
            backImageBlock(img);
        }
    });
    
    // 画圆
//    CGFloat side = MIN(image.size.width, image.size.height);
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), false, [UIScreen mainScreen].scale);
//    CGContextAddPath(UIGraphicsGetCurrentContext(),
//                     [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
//    
//    CGContextClip(UIGraphicsGetCurrentContext());
//    CGFloat marginX = -(image.size.width - side) / 2.f;
//    CGFloat marginY = -(image.size.height - side) / 2.f;
//    [image drawInRect:CGRectMake(marginX, marginY, image.size.width,image.size.height)];
//    
//    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
//    
//    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return output;
}


#pragma mark  ===  view  ====>> image
+ (UIImage *)getImageFromView:(UIView *)view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale); // 不加这行会出有模糊
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
