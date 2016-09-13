//
//  OneKeyallocation.m
//  WinFamily
//
//  Created by winext on 15/11/11.
//  Copyright © 2015年 Momon. All rights reserved.
//

#import "OneKeyAllocation.h"

#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import "ESPTouchDelegate.h"

#import <SystemConfiguration/CaptiveNetwork.h>


@interface EspTouchDelegateImpl : NSObject<ESPTouchDelegate>

@end

@implementation EspTouchDelegateImpl

-(void) dismissAlert:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
}

-(void) showAlertWithResult: (ESPTouchResult *) result
{
    NSString *title = nil;
    NSString *message = [NSString stringWithFormat:@"%@ is connected to the wifi" , result.bssid];
    NSTimeInterval dismissSeconds = 3.5;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:dismissSeconds];
}

-(void) onEsptouchResultAddedWithResult: (ESPTouchResult *) result
{
    NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertWithResult:result];
    });
}

@end

@interface OneKeyAllocation()
// to cancel ESPTouchTask when
@property (atomic, strong) ESPTouchTask *_esptouchTask;
@property (nonatomic, strong) NSCondition *_condition;

@property (nonatomic, strong) EspTouchDelegateImpl *_esptouchDelegate;
@end
@implementation OneKeyAllocation
MMSingletonM(OneKeyAllocation)
//NSString *apSsid  = @"";
//NSString *apPwd   = @"";
//NSString *apBssid = @"";
//BOOL isSsidHidden = NO;
//int taskCount     = 1;
//- (void)tapConfirmForResults

- (void)allocationWithIsAlloction :(BOOL)isAllocation andSsid:(NSString *)apSsid andBssid:(NSString *)apBssid andPassWord:(NSString *)passWord andTaskCount:(int)taskCount esptouchResultBlock:(void(^)(NSArray *resultArr))ResultBlock
{
    // do confirm
    if (isAllocation)
    {// 开始
        NSLog(@"ESPViewController do confirm action...");
        __weak __typeof(self)weakSelf = self;
        dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"ESPViewController do the execute work...");
             [weakSelf._condition lock];
            // execute the task
            BOOL isSsidHidden = NO;
            // 触发任务类
            weakSelf._esptouchTask = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:passWord andIsSsidHiden:isSsidHidden];
            
            // set delegate
            [weakSelf._esptouchTask setEsptouchDelegate:self._esptouchDelegate];
            [weakSelf._condition unlock];
                        
            NSArray * esptouchResults = [weakSelf._esptouchTask executeForResults:taskCount];
            NSMutableArray *muResultArr = [[NSMutableArray alloc] init];
            for (ESPTouchResult *oneResult in esptouchResults) {
                NSDictionary *oneResultDic = oneResult.keyValues;
                [muResultArr addObject:oneResultDic];
            }
            if (ResultBlock) {
                ResultBlock([muResultArr copy]);
            }
            NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
        });
    }
    // do cancel
    else
    {
//        [self._spinner stopAnimating];
//        [self enableConfirmBtn];
//        NSLog(@"ESPViewController do cancel action...");
        [self cancel];
    }
}

#pragma mark - the example of how to cancel the executing task

- (void)cancel
{
    [self._condition lock];
    if (self._esptouchTask != nil)
    {
        [self._esptouchTask interrupt];
    }
    [self._condition unlock];
}

#pragma mark - the example of how to use executeForResults
- (NSArray *) executeForResults
{
    [self._condition lock];
//    NSString *apSsid = self.ssidLabel.text;
//    NSString *apPwd = self._pwdTextView.text;
//    NSString *apBssid = self.bssid;
//    BOOL isSsidHidden = [self._isSsidHiddenSwitch isOn];
//    int taskCount = [self._taskResultCountTextView.text intValue];
    
    NSString *apSsid  = @"";
    NSString *apPwd   = @"";
    NSString *apBssid = @"";
    BOOL isSsidHidden = NO;
    int taskCount     = 1;
    
    // 触发任务类
    self._esptouchTask = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:isSsidHidden];
    
    // set delegate
    [self._esptouchTask setEsptouchDelegate:self._esptouchDelegate];
    
    [self._condition unlock];
    
    NSArray * esptouchResults = [self._esptouchTask executeForResults:taskCount];
    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
    return esptouchResults;
}




@end
