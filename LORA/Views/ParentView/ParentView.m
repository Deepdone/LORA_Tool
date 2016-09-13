//
//  ParentView.m
//  WinFamily
//
//  Created by winext on 15/9/25.
//  Copyright (c) 2015年 Momon. All rights reserved.
//

#import "ParentView.h"

@implementation ParentView
// nib加载
- (instancetype)initWithFrame:(CGRect)frame andNibName:(NSString *)nibName{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        self = [nibArr firstObject];
    }
    return self;
}

//  btnClick
//- (void)viewBtnClick:(UIButton *)sender{
//    if (self.viewBtnClickBlock) {
//        self.viewBtnClickBlock(sender.tag);
//    }
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
