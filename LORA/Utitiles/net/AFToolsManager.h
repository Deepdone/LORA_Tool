//
//  AFToolsManager.h
//  WXZhongJiu
//
//  Created by mac on 15/5/27.
//  Copyright (c) 2015年 Sweet. All rights reserved.
//

#import <Foundation/Foundation.h>
//导入请求库
#import "AFNetworking.h"


// 请求成功Block
typedef void(^SuccessBlock) (id responseObject);

// 请求失败Block
typedef void(^FailBlock) (id error);


@interface AFToolsManager : NSObject

/**
 *  AF的get请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */
+ (void)getRequestWithURL:(NSString *)urlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock  orFailure:(FailBlock)failBlock;

/**
 *  AF的post请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */
+ (void)postRequestWithURL:(NSString *)utlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFailure:(FailBlock)failureBlock;

/**
 *  AF的PUT请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */
+ (void)putRequestWithURL:(NSString *)utlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFailure:(FailBlock)failureBlock;
/**
 *  AF的delete请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */
+ (void)deleteRequestWithURL:(NSString *)utlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFailure:(FailBlock)failureBlock;
@end
