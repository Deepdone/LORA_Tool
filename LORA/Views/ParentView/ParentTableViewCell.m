//
//  ParentTableViewCell.m
//  WinFamily
//
//  Created by winext on 15/10/9.
//  Copyright (c) 2015年 Momon. All rights reserved.
//

#import "ParentTableViewCell.h"

@implementation ParentTableViewCell

#pragma mark ----- initWith TableView
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *cellID = [NSString stringWithFormat:@"%@ID",NSStringFromClass([self class])];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return (__typeof(self))cell;
}
#pragma mark ----- initWith TableView and NibName
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andNib:(NSString *)nibName{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
        self = [nibArr firstObject];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView andNib:(NSString *)nibName{
    NSString *cellID = [NSString stringWithFormat:@"%@ID",NSStringFromClass([self class])];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID andNib:nibName];
    }
    return (__typeof(self))cell;
}

#pragma mark   ----- btnClick
- (void)cellBtnClick:(UIButton *)sender{
    if (self.cellBtnClickBlock) {
        self.cellBtnClickBlock(sender.tag);
    }
}



- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
