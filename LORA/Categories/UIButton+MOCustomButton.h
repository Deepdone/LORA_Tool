//
//  UIButton+MOCustomButton.h
//  SmartKit
//
//  Created by SlightlySweetPro on 16/2/25.
//  Copyright © 2016年 Winext Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MOCustomButton) // 延展


+ (UIButton *)buttonWithTarget:(id)target action:(SEL)action normalImageName:(NSString *)norImage highlightImageName:(NSString *)higImage selectedImageName:(NSString *)selecteImage tag:(NSInteger)btnTag title:(NSString *)title higTitle:(NSString *)higTitle;
@end
