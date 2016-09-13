//
//  DownLoadWebZip.m
//  SmartKit
//
//  Created by SlightlySweetPro on 16/3/8.
//  Copyright © 2016年 Winext Corporation. All rights reserved.
//

#import "DownLoadWebZip.h"


#import "EquipmentModel.h"
#import "CVersionModel.h"

#import "SSZipArchive.h"

#define http @"http://192.168.1.43"

@interface DownLoadWebZip()<NSURLConnectionDataDelegate>
{
    
    // 缓存离线包
    CGFloat  _fileSize;
    long long  _totalDownLoadSize;
    NSString *_fileName;
    
    // 创建一个队列（非主队列）
    NSOperationQueue *_downLoadQueue;
    
    // 配置超时与否
    BOOL _isTimeOut;
    
    // 当前正在下载的离线包序号
    NSInteger _currentDownLoadWebNum;
}

@property (nonatomic,strong) NSMutableData *webData;

@property (nonatomic, strong) NSMutableArray * needDownLoadModelArr;  // 需要下载的离线 设备列表数据 模型


@property (nonatomic, strong)NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *operationDic; // 操作dic


@end

@implementation DownLoadWebZip
HMSingletonM(DownLoadWebZip)

- (instancetype)init{
    self = [super init];
    if (self) {
        self.webData = [[NSMutableData alloc] init];
        
        _currentDownLoadWebNum = 0;
        
        _downLoadQueue = [[NSOperationQueue alloc] init];
        _downLoadQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

#pragma mark -- 懒加载
- (NSMutableArray *)needDownLoadModelArr{
    
    if (!_needDownLoadModelArr) {
        _needDownLoadModelArr = [[NSMutableArray alloc] init];
    }
    return _needDownLoadModelArr;
}


// 懒加载
- (NSOperationQueue *)queue
{
    if (!_queue) {
        self.queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSMutableDictionary *)operations
{
    if (!_operationDic) {
        self.operationDic = [[NSMutableDictionary alloc] init];
    }
    return _operationDic;
}



/**
 *  下载离线包
 *
 *  @param tableView 刷新Tableview
 *  @param indexPath Tableview下标
 *  @param model     设备模型
 */
- (void)downLoadModelWith:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath andModel:(EquipmentModel *)model{
    
    NSString *zipHttp = [CVersionModel objectWithKeyValues:model.cVersion].url;
    
    NSString *requUrl = [NSString stringWithFormat:DOWNLOADWEBVIEW_URL,zipHttp,[model category_id]];
    NSLog(@"下载地址：%@",requUrl);
    NSBlockOperation *operation = self.operationDic[requUrl];
    if (operation) {
        return;
    }
    else {
        
//        __weak typeof(self) weakSelf = self;
        operation = [NSBlockOperation blockOperationWithBlock:^{
            NSURL *url        = [NSURL URLWithString:requUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            NSLog(@"data.length:%ld",data.length);
            
            NSString *fileName = [NSString stringWithFormat:@"%@.zip",model.category_id];
           
            // 下载的文件 保存的目标路径
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//  NSUserDomainMask user's home directory
            //    NSLog(@"---%@",paths[0]);
            
                        NSString *tagetPath = [paths[0] stringByAppendingPathComponent:fileName];
            
            
            // testPath
//            NSString *tagetPath = [@"/Users/mac/Desktop/zip" stringByAppendingPathComponent:fileName];
            
            
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            BOOL success = [fileManager createFileAtPath:tagetPath contents:nil attributes:nil];
            if (success) {
                NSLog(@"create success");
                NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:tagetPath];  // 写入到目标文件
                [outFile writeData:data];
                
                // Unzipping  解压
                // 解压后的文件路径
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//  NSUserDomainMask user's home directory
                //    NSLog(@"---%@",paths[0]); // 沙盒
                NSString *unzipFilePath = paths[0];
                
                // 4 test
//                NSString *unzipFilePath = @"/Users/mac/Desktop/unzip";
                //    NSLog(@"解压完成后地址：%@",unzipFilePath);
                
                // 解压
                BOOL isFinishUnzip = [SSZipArchive unzipFileAtPath: tagetPath toDestination:unzipFilePath];
                if (isFinishUnzip) {
                    
                    NSLog(@"完成解压：%@",tagetPath);
                    
                    model.isHaveNewVersion = NO; // 重置更新标识
                    
                    // model -- > dic --> key muDic
                    NSMutableDictionary *loadedModelMuDic = [[NSMutableDictionary alloc] initWithDictionary:[UserCache getMutableDictionaryWithKey:KLoadedModelMutableDicKey]];
                    
                    [loadedModelMuDic setObject:model.keyValues forKey:requUrl];
                    
                    // 字典 保存
                    [UserCache saveMutableDictionary:loadedModelMuDic withKey:KLoadedModelMutableDicKey];  // 更新缓存离线包记录
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                        /*
                         UITableViewRowAnimationFade,
                         UITableViewRowAnimationRight,           // slide in from right (or out to right)
                         UITableViewRowAnimationLeft,
                         UITableViewRowAnimationTop,
                         UITableViewRowAnimationBottom,
                         UITableViewRowAnimationNone,            // available in iOS 3.0
                         UITableViewRowAnimationMiddle,
                         */
                    });
                    
                }
                else{
                    [ShowPromptMessageTool showMessage:@"解压出错！"];
                }
            }
            else{
                NSLog(@"create Falsh");
            }
            NSLog(@"写入文件 文件大小：%ld",data.length);
        }];
    }
    
    // 添加操作到队列中
    [self.queue addOperation:operation];
    
    // 添加到字典中 (这句代码为了解决重复下载)
    self.operationDic[requUrl] = operation;
}


#pragma mark  ---   列表请求
/**
 *  // 刷新数据
 */
- (void)loadNewData{
    
    if ([AFNetworkActivityIndicatorManager sharedManager].isNetworkActivityIndicatorVisible) {
        //        [ShowPromptMessageTool showMessage:@"正在连接。。。"];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:GETEQUIPMENTLIST_URL,httpAPI,[[UserCache account] access_token]];
    
    __weak __typeof(self) weakSelf = self;
    [AFToolsManager getRequestWithURL:url andParameter:nil whenSuccess:^(id responseObject) {
        
        NSInteger code = [responseObject[@"code"] integerValue];
        
        if (200 == code) {
            
            NSArray *dataArr = responseObject[@"info"];
            @synchronized(weakSelf) {
                [weakSelf compareWithOldModelArr:[EquipmentModel objectArrayWithKeyValuesArray:[UserCache getMutableArrayWithKey:KLoadedModelMutableArrKey]] withNewModelArr:[EquipmentModel objectArrayWithKeyValuesArray:dataArr]];
            }
            NSLog(@"完成下载%@",dataArr);
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:@"网络繁忙，请求设备列表失败，请稍候再试" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
            [WFCodeRead readWithResponseDic:responseObject];// 解读返回code
        }
    } orFailure:^(id error) {
        // 停止刷新
        //        [weakSelf loadingEnd];
    }];
}

#pragma mark   比较---》是否有需要下载离线包   比较完毕后 建立下载任务；
/**
 *  @param oModelArr 缓存的数据包
 *  @param nModelArr 当前数据包
 *
 *  @return 需要下载的数据包
 */
- (void)compareWithOldModelArr:(NSMutableArray *)oModelArr withNewModelArr:(NSMutableArray *)nModelArr{
    
    // 清空 上一次下载模型数据
    if (self.needDownLoadModelArr.count) {
        [self.needDownLoadModelArr removeAllObjects];
    }
    // 如果appWeb框架不存在  先下载本框架
    // 2，沙盒
    /*
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//  NSUserDomainMask user's home directory
     NSString *unzipFilePath = [paths[0] stringByAppendingPathComponent:@"app"];
     NSFileManager *mgr = [NSFileManager defaultManager];
     
     BOOL dir = NO; // 是文件夹
     BOOL exist = [mgr fileExistsAtPath:unzipFilePath isDirectory:&dir]; //路径存在
     
     if(!exist){
     EquipmentModel *appModel = [[EquipmentModel alloc] init];
     appModel.category_id = @"app";
     appModel.coreid      = @"appWebViewRack";
     [self.needDownLoadModelArr addObject:appModel];
     NSLog(@"没有app文件夹路径");
     }
     
     */
    
    if(!nModelArr.count){
        [ShowPromptMessageTool showMessage:@"当前设备列表无设备，请先添加设备！"];
        return ;
    }
        else if(!oModelArr.count){
            [self.needDownLoadModelArr addObjectsFromArray:[nModelArr mutableCopy]];
            [self createWebZipDownLoadQueue];
            return;
        }
    
    for ( int i = 0;i < nModelArr.count; i++) {
        EquipmentModel *n_EquipmentModel = nModelArr[i];
        BOOL isHaveEqualCategoryId = NO;
        
        for (EquipmentModel *o_EquipmentModel in oModelArr) {
            // categoryId
            BOOL isEqualCategoryId = [IFISNIL(o_EquipmentModel.category_id)  isEqualToString:IFISNIL(n_EquipmentModel.category_id)];
            if (isEqualCategoryId) {
                isHaveEqualCategoryId = YES;
                break;
            }
        }
        // 去除重复Model 添加到数组中
        BOOL isNeedAddToArr = NO;
        for (EquipmentModel *needDownLoadModel in self.needDownLoadModelArr) {
            // categoryId
            BOOL isEqualCategoryId = [IFISNIL(needDownLoadModel.category_id)  isEqualToString:IFISNIL(n_EquipmentModel.category_id)];
            if (!isEqualCategoryId) {
                isNeedAddToArr = YES;
            }
        }
        if (!isHaveEqualCategoryId && isNeedAddToArr) {
            [self.needDownLoadModelArr addObject:n_EquipmentModel];
        }
        
    }
    
    
    
    // 操作队列
        [self performSelectorOnMainThread:@selector(createWebZipDownLoadQueue) withObject:nil waitUntilDone:NO];
}


#pragma mark ------- 创建请求队列 --------
- (void)createWebZipDownLoadQueue{

    
    void(^operationArrBlock)(NSMutableArray *operationArr) = ^(NSMutableArray *operationArr){
        
        // 设置依赖
        if(operationArr.count > 1){
            for (int i = 1; i < operationArr.count; i++) {
                [operationArr[i] addDependency:operationArr[i-1]];
            }
        }
        
        // 添加到队列中
        for (int i = 0; i < operationArr.count; i++) {
            [_downLoadQueue addOperation:operationArr[i]];
        }
    };
    
    
//    __weak __typeof(self)weakSelf = [DownLoadWebZip sharedDownLoadWebZip];
    __weak __typeof(self)weakSelf = self;
    
    NSMutableArray *operationArr = [[NSMutableArray alloc] init];
    
    NSLog(@"needdownloadCount:%ld",self.needDownLoadModelArr.count);
    
    for (int i = 0; i < self.needDownLoadModelArr.count; i++) {
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
              
                NSString *requUrl = [NSString stringWithFormat:DOWNLOADWEBVIEW_URL,http,[weakSelf.needDownLoadModelArr[i] category_id]];
                
                NSLog(@"下载地址：%@",requUrl);
                
                NSURL *url        = [NSURL URLWithString:requUrl];
                NSURLRequest *request       = [NSURLRequest requestWithURL:url];
                NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:weakSelf];
//                [connection start];

            });
            [NSThread sleepForTimeInterval:3];
        }];
        
        [operationArr addObject:operation];
        
        // 完成添加到数组中后  再添加到队列中
        if ((operationArr.count == self.needDownLoadModelArr.count) && operationArr.count) {
            
            if (operationArrBlock) {
                operationArrBlock(operationArr);
            }
        }
    }
}



#pragma mark NSURLConnectionDataDelegate
//下载失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"下载error:%@",error);
    self.webData.length = 0;
    
    _totalDownLoadSize  = 0;
    
    _currentDownLoadWebNum  = 0;
}

// --> 准备接受数据
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    self.webData.length = 0;
    
    _totalDownLoadSize  = 0;
    
    _currentDownLoadWebNum++;
    
    //文件的大小
    _fileSize = [response expectedContentLength];
    
    _fileName = [response suggestedFilename];
    
    
    NSLog(@"fileSize:%f,fileName:%@",_fileSize,_fileName);
}

//接收数据  ----> 调用该方法
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    _totalDownLoadSize += data.length; // 需要类型相同
    [self.webData appendData:data];
    
    //    self.pro.progress = _totalDownLoadSize / _fileSize;
    //    self.proLabel.text = [NSString stringWithFormat:@"%.2f%%",self.pro.progress * 100];
    
    // *1.0  以取得小数位
    CGFloat psof = _totalDownLoadSize / _fileSize * (_currentDownLoadWebNum/(self.needDownLoadModelArr.count * 1.0)) * 100;
    
//    NSLog(@"num:%ld,--- data:%ld,loadSize:%@   %lld",_currentDownLoadWebNum,data.length,[NSString stringWithFormat:@"%.2f%%",psof],_totalDownLoadSize);
}

//完成下载数据  调用该方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 完成所有离线包下载后清除序号
    if (_currentDownLoadWebNum + 1 == self.needDownLoadModelArr.count) {
        _currentDownLoadWebNum = 0;
        
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // 下载的文件 保存的目标路径
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//  NSUserDomainMask user's home directory
    //    NSLog(@"---%@",paths[0]);
    
    // 沙盒 // 拼建路径出错
    //    NSString *tagetPath = [paths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"zip/%@",_fileName]];
   
    NSString *tagetPath = [paths[0] stringByAppendingPathComponent:_fileName];

    
     // testPath
//        NSString *tagetPath = [@"/Users/mac/Desktop/zip" stringByAppendingPathComponent:_fileName];
    

    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager createFileAtPath:tagetPath contents:nil attributes:nil];
    if (success) {
        NSLog(@"create success");
        NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:tagetPath];  // 写入到目标文件
        
        [outFile writeData:self.webData];
        
        // Unzipping  解压
        [self performSelector:@selector(unZippingWith:) withObject:tagetPath afterDelay:3];
   
//        [self unZippingWith:tagetPath];
    }
    else{
        NSLog(@"create Falsh");
    }
    
    
    NSLog(@"写入文件 文件大小：%ld",self.webData.length);
    
}

#pragma mark  ------ 解压  ------
- (void)unZippingWith:(NSString *)zipPath{
    static NSInteger unzipNum = 0;
    
    // 解压后的文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//  NSUserDomainMask user's home directory
    //    NSLog(@"---%@",paths[0]); // 沙盒
    
    NSString *unzipFilePath = @"";
    NSLog(@"unzipNum:%ld",unzipNum);
    
//    if ([[self.needDownLoadModelArr[unzipNum] coreid] isEqualToString:@"appWebViewRack"]) {
        unzipFilePath = paths[0];
//    }
//    else{
//        unzipFilePath = [paths[0] stringByAppendingPathComponent:@"app"];
//    }

     // 3
//         NSString *unzipFilePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"app"];
    
    // 4 test
//       unzipFilePath = @"/Users/mac/Desktop/unzip";
//    NSLog(@"解压完成后地址：%@",unzipFilePath);
    
    // 解压
    BOOL isFinishUnzip = [SSZipArchive unzipFileAtPath: zipPath toDestination:unzipFilePath];
    
    if (isFinishUnzip) {
        unzipNum++;
        
        NSMutableArray *loadedModelMuArr = [[NSMutableArray alloc] initWithCapacity:5];
        [loadedModelMuArr addObjectsFromArray:[[EquipmentModel objectArrayWithKeyValuesArray:[UserCache getMutableArrayWithKey:KLoadedModelMutableArrKey]] mutableCopy]];
        
#warning  ********** 待解 bug ********
        
        [loadedModelMuArr addObject:self.needDownLoadModelArr[unzipNum - 1]];
        
        // 转成字典数组 保存  暂时不保存
        [UserCache saveMutableArray:[EquipmentModel keyValuesArrayWithObjectArray:loadedModelMuArr] withKey:KLoadedModelMutableArrKey];  // 更新缓存离线包记录
        
        NSString *showStr = [NSString stringWithFormat:@"当前已解压包总数：%ld 当前下载解压任务进度:%ld/%ld",loadedModelMuArr.count,unzipNum,self.needDownLoadModelArr.count];
        
        NSLog(@"showStr : %@",showStr);
        [ShowPromptMessageTool showMessage:showStr];
        
        if (unzipNum == self.needDownLoadModelArr.count) {
            unzipNum = 0;
        }
    }
    else{
        [ShowPromptMessageTool showMessage:@"解压出错！"];
    }
}

@end
