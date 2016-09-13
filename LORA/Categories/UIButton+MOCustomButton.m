//
//  UIButton+MOCustomButton.m
//  SmartKit
//
//  Created by SlightlySweetPro on 16/2/25.
//  Copyright © 2016年 Winext Corporation. All rights reserved.
//

#import "UIButton+MOCustomButton.h"

@implementation UIButton (MOCustomButton) //

/**
 *  创建一个按钮
 *
 *  @param target   响应对象
 *  @param action   响应事件
 *  @param norImage 普通状态图片
 *  @param higImage 高亮图片
 *  @param btnTag   按按钮标识
 *  @param title    文字
 * //  @param btnframe 尺寸位置
 *
 *  @return 返回画好的按钮
 */
+ (UIButton *)buttonWithTarget:(id)target action:(SEL)action normalImageName:(NSString *)norImage highlightImageName:(NSString *)higImage selectedImageName:(NSString *)selecteImage tag:(NSInteger)btnTag title:(NSString *)title higTitle:(NSString *)higTitle{
    
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = btnTag;
    // 添加事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:higImage] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:selecteImage] forState:UIControlStateSelected];
    
    // 文字
    [btn setTitle:title forState:0];
    
    [btn setTitle:higTitle forState:UIControlStateHighlighted];
    
    [btn setBackgroundColor:RedColor];
    
    return btn;
}

@end
