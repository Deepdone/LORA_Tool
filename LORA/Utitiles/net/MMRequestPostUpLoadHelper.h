//
//  MMRequestPostUpLoadHelper.h
//  IceboxPartner
//
//  Created by SlightlySweetPro on 16/7/7.
//  Copyright © 2016年 SlightlySweet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMRequestPostUpLoadHelper : NSObject

/**
 *POST 提交 并可以上传图片目前只支持单张
 */
+ (NSDictionary *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN 提交参数据集合
                     picFilePath: (NSString *)picFilePath  // IN 上传图片路径
                         picFileName: (NSString *)picFileName andResult:(void(^)(NSDictionary *resultDic)) resultBlock;  // IN 上传图片名称


/**
 *  上传多张image
 *
 *  @param strUrl    url
 *  @param params    params
 *  @param dicImages imagsDic
 *
 *  @return resultStr
 */
+(NSString *)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params dicImages:(NSMutableDictionary *) dicImages;


/**
 * 修发图片大小
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;
/**
 * 保存图片
 */
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
/**
 * 生成GUID
 */
+ (NSString *)generateUuidString;

@end
