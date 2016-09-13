//
//  MainViewController.m
//  LORA
//
//  Created by SlightlySweetPro on 16/8/26.
//  Copyright © 2016年 SlightlySweet. All rights reserved.
//

#import "MainViewController.h"
#import "MMWebViewProgress.h"
#import "MMWebViewProgressView.h"

#define isRequest  1



// -> js oc
#import <JavaScriptCore/JavaScriptCore.h>

@protocol ContextJSExport_List <JSExport>

- (void)callBackPushTest:(id)data;

//JSExportAs(CallBackPush, );


//
//- (void)htmlInit; // webView初始化
//
//- (void)send_getVal: (NSString *)cmd;
//
//- (void)send_funCall:(NSString *)jsonData;
//
//- (void)debug:       (NSString *)debugStr; // 调试输出
//
//- (void)alert:       (NSString *)alertStr; // 弹框提示
//
//- (void)load:       (NSString *)loadStr;   // 活动指示



@end
// <- js oc

@interface MainViewController()<UIWebViewDelegate,MMWebViewProgressDelegate>
{
    NSString *_defaultDBPath; // 清除缓存路径
    MMWebViewProgress     *_progressProxy;
    MMWebViewProgressView *_progressView;
    NSString *_requestUrlStr;   // 请求路径
}

@property (nonatomic, strong) NSTimer *loadingTimeOutTimer;




@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;  // 主页
// js oc
//@property (weak,nonatomic)    UIWebView *webView;
//@property (strong,nonatomic)  JSContext *contextJS;
//  <-- js oc

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUIView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

#pragma mark ---- 注册通知
- (void)registerNotification {
   
}


#pragma mark  -----  Create  UIView ------
- (void)createUIView {

    
    
    // 加载进度
    _progressProxy = [[MMWebViewProgress alloc] init];
    
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate     = self;
    self.mainWebView.delegate           = _progressProxy;
    
    CGFloat progressBarHeight = 2.f;
    CGFloat navViewH = self.navigationController.navigationBar.bounds.size.height;
    CGFloat navViewW = self.navigationController.navigationBar.bounds.size.width;
    
    CGRect progressFrame = CGRectMake(0, navViewH + progressBarHeight, navViewW, progressBarHeight);
    _progressView        = [[MMWebViewProgressView alloc] initWithFrame:progressFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
  
    
    if (isRequest) {
        NSString *urlStr = LORA_LoginUrlStr;
        
        [self loadWebViewWithStr:urlStr];
    }
 
    
 
 
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick:)];
    [rightBtnItem setTitle:@"配置"];
   
//    self.navigationItem.rightBarButtonItem  = rightBtnItem;
    
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWebView:)];
    
    self.navigationItem.rightBarButtonItems = @[rightBtnItem,leftBtnItem];  // l ---  r
}


// 加载网页
- (void)loadWebViewWithStr:(NSString *)urlStr {
//    _urlStr  = urlStr;
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"urlStr:%@",urlStr);
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf.mainWebView loadRequest:request];
    });
}



#pragma mark  ---************* delegate  *********** ---
#pragma  mark -- ==============  webView delegate ================ ----

#pragma mark  -------------- 拦截 webView 所有请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url  = request.URL.absoluteString;
    _requestUrlStr = url;
    
    NSRange testUrlR = [url rangeOfString:@"test://"];
    
    if (testUrlR.location != NSNotFound) {
    NSString *testFunStr = [url substringFromIndex:testUrlR.location + testUrlR.length];

    SEL testSel          = NSSelectorFromString(testFunStr);
        if ([self respondsToSelector:testSel]) {
            [self performSelector:testSel withObject:nil];
        }
    }

    return YES;
}


#pragma mark  ------------- webView 开始加载的时候调用
- (void )webViewDidStartLoad:(UIWebView  *)webView{
    [self loadingNow];
    self.mainWebView.hidden = YES;
}


#pragma mark --------------- webView完成加载
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mainWebView.hidden = NO;
        [self loadingEnd];
    });
    
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    if ([currentURL isEqualToString:@"http://lora.smartkit.io/index/login"]) {
        [self loginView:webView];
    }
    else{
        [self loginSuccess:webView];
    }
    
//    NSRange usernmaeR   = [currentURL rangeOfString:@"username"];
//    NSRange uidR        = [currentURL rangeOfString:@"uid"];
//    NSRange tokenR      = [currentURL rangeOfString:@"token"];
//    BOOL isLoginSuccess = (usernmaeR.location != NSNotFound) && (uidR.location != NSNotFound) && (tokenR.location != NSNotFound);
//    
//    if(isLoginSuccess){
//        MMLog(@"isLoginSuccess~~!");
//        [self loginSuccess:webView];
//    }
    NSLog(@"webView 完成加载");

    
//    getElementById()
//    getElementsByName()
//    getElementsByTagName()
    
}

#pragma mark  -------------- webView 加载错误的时候调用
- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error{
//    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
//    MMLog(@"加载错误：%@",_requestUrlStr);
    NSRange testR = [_requestUrlStr rangeOfString:@"test://"];
    if (testR.location != NSNotFound) {
        return;
    }
    
//    [self stopLoadingTimeoutTimer];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"加载错误！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}



#pragma mark ----==========----  NJKWebViewProgressDelegate ---======-----
-(void)webViewProgress:(MMWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}




#pragma mark   ----- 登录界面 显示  ---
- (void)loginView:(UIWebView *)webView{
    // 修改
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('input-block-level')[0].value = '15818630976';"];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('input-block-level')[1].value = '000000';"];
    return;

    // 插入 调用方法
//    [webView stringByEvaluatingJavaScriptFromString:@"var script =\
//     document.createElement('script');\
//     script.type = 'text/javascript';\
//     script.text = \"function myFunction() { \
//     alert('133331');\
//     }\";  \
//     document.getElementsByClassName('clearfix')[0].appendChild(script);"
//     ];
}


#pragma mark  ------ 主页界面 显示  ---
- (void)loginSuccess:(UIWebView *)webView{
    
    [webView stringByEvaluatingJavaScriptFromString:@"var divider = document.getElementsByClassName('dropdown-menu dropdown-navbar')[0].getElementsByClassName('divider')[0];"
     "var ul  = document.getElementsByClassName('dropdown-menu dropdown-navbar')[0];"
     
     "var li0 =  document.getElementsByClassName('dropdown-menu dropdown-navbar')[0].getElementsByTagName('li')[0];"
     "var li2 =  document.getElementsByClassName('dropdown-menu dropdown-navbar')[0].getElementsByTagName('li')[2];"

     // li
     "var addLi  = document.createElement('li');"
     "addLi.type = 'a';"
     "ul.insertBefore(addLi,li2);"

     // li -- a
     "var addA  = document.createElement('a');"
     "addA.type = 'a';"
     "addA.href = 'test://setNet';"
     "addA.innerHTML = '<i class=\"icon-question\"></i>配置';"
     "addLi.appendChild(addA);"
   
//     "var addDivider = new divider;"
     
     
     "var btn = document.createElement('button');"
     "btn.innerText = 'testBtn';"
     "btn.type = 'button';"
     
     //     "btn.href = 'test://webViewBtnClick';"
     "btn.addEventListener('click', function(){"
     "window.location.href = 'test://webViewBtnClick';"
     "myFunction();"
     "});"
     
//     "ul.insertBefore(btn,li2);"
//     "ul.appendChild(btn);"
     ];
    
    // 分隔线
    [webView stringByEvaluatingJavaScriptFromString:@"var li3 =  document.getElementsByClassName('dropdown-menu dropdown-navbar')[0].getElementsByTagName('li')[3];"
     "var addD  = document.createElement('li');"
     "addD.className = 'divider';"
     "ul.insertBefore(addD,li3);"
     ];
}

#pragma mark   =============  web Test 响应   =======
- (void)webViewBtnClick{

}


- (void)setNet{
    
    [self loginSuccess:self.mainWebView];
    
    return;
    
    
    MMLog(@"setNet  kwg kwg ");
    NSString *wifiName = [NetInfo fetchSsid];
    
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];

//    if ([[UIApplication sharedApplication] canOpenURL:url])
//    {
        [[UIApplication sharedApplication] openURL:url];
        
//    }
    return;
    if (([wifiName rangeOfString:@"GW1000_"].location == NSNotFound) || (wifiName.length != 13)) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"当前连接热点非网关热点，配置网关需先连接网关热点（GW1000_******），是否前往设置网络？" preferredStyle:UIAlertControllerStyleAlert];
        
        // 取消设置网络
        [alertVC addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // donothing
        }]];
        
        //设置网络
        [alertVC addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self performSelector:@selector(openSystemUrlWithStr:) withObject:@"prefs:root=WIFI" afterDelay:0.2f];

        }]];
        
        [self presentViewController:alertVC animated:YES completion:^{}];
       
        return;
    }
}

//
- (void)callBackPushTest:(id)data{
//    MMLog(@"callBackPushTest:%@",data);
}


#pragma mark  -----------  刷新网页 ---------
- (void)reloadWebView:(UIBarButtonItem *)sender{
    [self.mainWebView reload];
}
#pragma mark  -----------  配置网关 ---------
- (void)rightBarItemClick:(UIBarButtonItem *)sender{
    NSString *wifiName = [NetInfo fetchSsid];
//
//    BOOL isHadGWStr = ([wifiName rangeOfString:@"GW1000_"].location != NSNotFound) && ([wifiName rangeOfString:@"GW1000_"].location == 0 );
//    if (!isHadGWStr || (wifiName.length != 13)) {
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"当前连接热点非网关热点，配置网关需先连接网关热点（GW1000_******），是否前往设置网络？" preferredStyle:UIAlertControllerStyleAlert];
//        
//        // 取消设置网络
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            // donothing
//        }]];
//
//        
//        
//        //设置网络
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            [self performSelector:@selector(openSystemUrlWithStr:) withObject:@"prefs:root=WIFI" afterDelay:0.5f];
//            
//            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            //                NSMutableArray  *viewControllersM = [self.navigationController.viewControllers  mutableCopy];
//            //                [viewControllersM removeObject:[viewControllersM lastObject]];
//            //                self.navigationController.viewControllers = viewControllersM;
//            //            });
//            
//        }]];
//        [self presentViewController:alertVC animated:YES completion:^{}];
//    }
//   else {
    
       NSString *messageStr = [NSString stringWithFormat:@"当前连接热点为：%@，是需要更换热点？",wifiName];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
        
        // 取消设置网络
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // donothing
        }]];
        
        //设置网络
        [alertVC addAction:[UIAlertAction actionWithTitle:@"是。" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self performSelector:@selector(openSystemUrlWithStr:) withObject:@"prefs:root=WIFI" afterDelay:0.5f];
        }]];
    
       //设置网络
       [alertVC addAction:[UIAlertAction actionWithTitle:@"否。下一步" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           MMLog(@"下一步");
           
           NSString *storyboardName  = @"Main";
           UIStoryboard *storyboard  = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
           UIViewController * pushVC = [storyboard instantiateViewControllerWithIdentifier:@"BindingControllerStoryboardID"];
           [self.navigationController pushViewController:pushVC animated:YES];

           //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           //                NSMutableArray  *viewControllersM = [self.navigationController.viewControllers  mutableCopy];
           //                [viewControllersM removeObject:[viewControllersM lastObject]];
           //                self.navigationController.viewControllers = viewControllersM;
           //            });
           
       }]];
       
        [self presentViewController:alertVC animated:YES completion:^{}];
        
        return;
//    }

    
}

#pragma mark ------ 定时器 开关  ----------
// 加载超时关闭
- (void)stopLoadingTimeoutTimer{
    if (self.loadingTimeOutTimer) {
        [self.loadingTimeOutTimer invalidate];
        self.loadingTimeOutTimer = nil;
    }
    
    NSLog(@"stopLoadingTimeoutTimer");
    
    [self loadingEnd];
//    refreshNumSuper = 0;
//    getValNumSuper  = 0;
}

// 加载 超时计时
- (void)startLoadingTimeoutTimer:(NSTimeInterval)ti{
    if (self.loadingTimeOutTimer) {
        [self stopLoadingTimeoutTimer];
    }
    self.loadingTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(loadingTimeOut) userInfo:nil repeats:NO];
}

#pragma mark  -----  请求超时 -------
- (void)loadingTimeOut{

//        if (!_isCanEndLoad_finish || !_isFirstTimeLoadWebView) {
            [self stopLoadingTimeoutTimer];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请求超时，请重试" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = 2017;
            [alert show];
//    }
}

- (void)dealloc{
    [NotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
