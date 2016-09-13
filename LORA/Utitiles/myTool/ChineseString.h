//
//  ChineseString.h
//  IceboxPartner
//
//  Created by SlightlySweetPro on 16/7/20.
//  Copyright © 2016年 SlightlySweet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "PinYin.h"

@class FoodSubSorteModel;

@interface ChineseString : NSObject

@property(copy,nonatomic) NSString *string;
@property(copy,nonatomic) NSString *pinYin;

@property (nonatomic,strong) FoodSubSorteModel *subSorteModel;  // 

/**
 *  TableView右方IndexArray
 */
+(NSMutableArray *) IndexArray:(NSArray *) stringArr;

/**
 *  文本列表
 */
+(NSMutableArray *) LetterSortArray:(NSArray *)stringArr;

/**
 *返回一组字母排列数组(中英混排)
 */
+(NSMutableArray *) SortArray:(NSArray *)stringArr;

@end
