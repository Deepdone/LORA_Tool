//
//  ParentTableViewCell.h
//  WinFamily
//
//  Created by winext on 15/10/9.
//  Copyright (c) 2015年 Momon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellBtnClickBlock) (NSInteger cellBtnTag);

@interface ParentTableViewCell : UITableViewCell

@property(nonatomic,copy) CellBtnClickBlock cellBtnClickBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView andNib:(NSString *)nibName;

// cell 点击事件
- (void)cellBtnClick:(UIButton *)sender;
@end
