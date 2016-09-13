//
//  ParentModel.h
//  WinFamily
//
//  Created by winext on 15/9/28.
//  Copyright (c) 2015年 Momon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface ParentModel : NSObject  <NSCoding>
- (instancetype)initWithDict:    (NSDictionary *)dictionary;
+ (instancetype)initModelWithDict:(NSDictionary *)dictionary;

@end
