//
//  ParentView.h
//  WinFamily
//
//  Created by winext on 15/9/25.
//  Copyright (c) 2015年 Momon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ViewBtnClickBlock) (NSInteger viewBtnTag);

typedef void(^ViewBtnClickBtnSenderBlock) (UIButton * sender);


@interface ParentView : UIView
// 使用 block tag 传递响应事件
@property (nonatomic,copy) ViewBtnClickBlock viewBtnClickBlock;

// 使用 block Btn 传递btn响应事件
@property (nonatomic,copy) ViewBtnClickBtnSenderBlock viewBtnClickBtnSenderBlock;

// 使用xib加载
- (instancetype)initWithFrame:(CGRect)frame andNibName:(NSString *)nibName;

// btnClick 
//- (void)viewBtnClick:(UIButton *)sender;

@end
