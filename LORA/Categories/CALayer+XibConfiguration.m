//
//  CALayer+XibConfiguration.m
//  SmartKit
//
//  Created by SlightlySweetPro on 15/12/30.
//  Copyright © 2015年 Winext Corporation. All rights reserved.

// 在xib设置边框颜色

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)
/*
 
 layer.cornerRadius      Number
 layer.borderWidth       Number
 
 
 layer.borderUIColor     color
 */

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
