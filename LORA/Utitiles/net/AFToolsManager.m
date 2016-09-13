//
//  AFToolsManager.m
//  WXZhongJiu
//
//  Created by mac on 15/5/27.
//  Copyright (c) 2015年 Sweet. All rights reserved.
//

#import "AFToolsManager.h"


//#import "UIKit+AFNetworking.h"

@implementation AFToolsManager
/**
 *  AF的get请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */
+ (void)getRequestWithURL:(NSString *)urlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFailure:(FailBlock)failBlock{
    // manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 请求类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
     // 请求超时
    manager.requestSerializer.timeoutInterval = 15;

    
    // 响应返回类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 请求成功回调方法
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        // 回传
        if (successBlock) {
            successBlock(dataDic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ShowPromptMessageTool  showMessage:@"网络错误/请求超时，请检查网络！error - 1041"];
        // 请求失败回调方法
        if(failBlock){
            failBlock(error);
        }
    }];
}

/**
 *  AF的post请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */
+ (void)postRequestWithURL:(NSString *)utlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFailure:(FailBlock)failureBlock{
    // manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 请求数据
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
     // 请求超时
    manager.requestSerializer.timeoutInterval = 15;

    // 响应返回类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:utlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // 成功回调方法
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
      
        // 回传
        if(successBlock){
            successBlock(dataDic);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [ShowPromptMessageTool  showMessage:@"网络错误/请求超时，请检查网络！error - 1042"];
        // 请求失败回调方法
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

/**
 *  AF的put请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */
+ (void)putRequestWithURL:(NSString *)utlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFailure:(FailBlock)failureBlock{
    // manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 请求数据
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
     // 请求超时
    manager.requestSerializer.timeoutInterval = 15;

    // 响应返回类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager PUT:utlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // 成功回调方法
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        // 回传
        if(successBlock){
            successBlock(dataDic);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [ShowPromptMessageTool  showMessage:@"网络错误/请求超时，请检查网络！error - 1043"];
        // 请求失败回调方法
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

/**
 *  AF的delete请求
 *
 *  @param urlString    网络连接
 *  @param parameters   字典类型
 *  @param successBlock 成功回调
 *  @param failBolck    失败回调
 */
+ (void)deleteRequestWithURL:(NSString *)utlString andParameter:(id)parameters whenSuccess:(SuccessBlock)successBlock orFailure:(FailBlock)failureBlock{
    // manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 请求数据
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 请求超时
    manager.requestSerializer.timeoutInterval = 15;

    // 响应返回类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager DELETE:utlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // 成功回调方法
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        // 回传
        if(successBlock){
            successBlock(dataDic);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [ShowPromptMessageTool  showMessage:@"网络错误/请求超时，请检查网络！error - 1044"];
        // 请求失败回调方法
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

@end
