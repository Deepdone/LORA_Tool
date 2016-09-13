//
//  BindingController.m
//  LORA
//
//  Created by SlightlySweetPro on 16/9/2.
//  Copyright © 2016年 SlightlySweet. All rights reserved.
//

#import "BindingController.h"

#import "MMWebViewProgress.h"
#import "MMWebViewProgressView.h"


@interface BindingController ()<UIWebViewDelegate,MMWebViewProgressDelegate>

{
    NSString *_defaultDBPath; // 清除缓存路径
    MMWebViewProgress     *_progressProxy;
    MMWebViewProgressView *_progressView;
    NSString *_requestUrlStr;   // 请求路径
}
@property (weak, nonatomic) IBOutlet UIWebView *bindWebView;

@property (nonatomic, strong) NSTimer *loadingTimeOutTimer;

@end

@implementation BindingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUIView];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self loadingEnd];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

#pragma mark ---- 注册通知
- (void)registerNotification {
    // 设置当前标题
    //    [NotificationCenter addObserver:self selector:@selector(setCurrentTitle) name:NChangeCurrentName object:nil];
    
    //
    //    // 后台切换到前台
    //    [NotificationCenter addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    //
    //    // 后台切换到前台 变更网络
    //    [NotificationCenter addObserver:self selector:@selector(becomeActiveOrNetStatusChangeWith:) name:NBecomeActiveOrNetStatusChange object:nil];
    //
    //    // 修改名称成功
    //    [NotificationCenter addObserver:self selector:@selector(changeTitleSuccess:) name:NChangeTitleSuccess object:nil];
    //
    //
    //    // webView 推送 backData
    //    [NotificationCenter addObserver:self selector:@selector(webViewBackData:) name:NWebViewPushBackData object:nil];
}


#pragma mark  -----  Create  UIView ------
- (void)createUIView {
    // 加载指示  正在加载时不法点击
    
    //    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //    self.HUD.delegate = self;
    //    [self.view addSubview:self.HUD];
    
    // 加载进度
    _progressProxy = [[MMWebViewProgress alloc] init];
    
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate     = self;
    self.bindWebView.delegate           = _progressProxy;
    
    CGFloat progressBarHeight = 2.f;
    CGFloat navViewH = self.navigationController.navigationBar.bounds.size.height;
    CGFloat navViewW = self.navigationController.navigationBar.bounds.size.width;
    
    CGRect progressFrame = CGRectMake(0, navViewH + progressBarHeight, navViewW, progressBarHeight);
    _progressView        = [[MMWebViewProgressView alloc] initWithFrame:progressFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    // js oc ->
    //    self.webView.scrollView.bounces = NO;
    
        NSString *urlStr = LORA_SetNetUrlStr;
        [self loadWebViewWithStr:urlStr];
    

  
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClick:)];
    [rightBtnItem setTitle:@"配置"];
    
    //    self.navigationItem.rightBarButtonItem  = rightBtnItem;
    
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadWebView:)];
    
        self.navigationItem.rightBarButtonItem  = leftBtnItem;
    
//    self.navigationItem.rightBarButtonItems = @[rightBtnItem,leftBtnItem];  // l ---  r
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 加载网页
- (void)loadWebViewWithStr:(NSString *)urlStr {
    //    _urlStr = urlStr;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"urlStr:%@",urlStr);
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf.bindWebView loadRequest:request];
    });
}



#pragma mark  --- ************* delegate  *********** ---
#pragma mark  -- ==============  webView delegate ================ ----
/**
 *  webView  每当发送一个请求之前，都会先调用这个方法（能拦截所有请求）
 */
#pragma mark  -------------- 拦截 webView 所有请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url  = request.URL.absoluteString;
    _requestUrlStr = url;
    
    NSLog(@" request拦截 url:%@",url);
    
    NSRange testUrlR = [url rangeOfString:@"test://"];
    
    if (testUrlR.location != NSNotFound) {
        NSString *testFunStr = [url substringFromIndex:testUrlR.location + testUrlR.length];
        
        SEL testSel          = NSSelectorFromString(testFunStr);
        if ([self respondsToSelector:testSel]) {
            [self performSelector:testSel withObject:nil];
        }
    }
    
    
    //    if ([url isEqualToString:@"http://lora.smartkit.io/index/login"]) {
    //        [self loginView:webView];
    //    }
    //
    //
    //    NSRange usernmaeR   = [url rangeOfString:@"username"];
    //    NSRange uidR        = [url rangeOfString:@"uid"];
    //    NSRange tokenR      = [url rangeOfString:@"token"];
    //    BOOL isLoginSuccess = (usernmaeR.location != NSNotFound) && (uidR.location != NSNotFound) && (tokenR.location != NSNotFound);
    //
    //    if(isLoginSuccess){
    //
    //    }
    
    return YES;
}


#pragma mark  ------------- webView 开始加载的时候调用
- (void )webViewDidStartLoad:(UIWebView  *)webView{
    [self loadingNow];
    self.bindWebView.hidden = YES;
//    NSLog(@"webView 开始加载");
}

#pragma mark ---------------          webView完成加载
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bindWebView.hidden = NO;
        [self loadingEnd];
    });
    
    
    return;
    
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    if ([currentURL isEqualToString:@"http://192.168.3.1/cgi-bin/luci"]) {
        [self loginView:webView];
    }
    
    NSRange usernmaeR   = [currentURL rangeOfString:@"username"];
    NSRange uidR        = [currentURL rangeOfString:@"uid"];
    NSRange tokenR      = [currentURL rangeOfString:@"token"];
    BOOL isLoginSuccess = (usernmaeR.location != NSNotFound) && (uidR.location != NSNotFound) && (tokenR.location != NSNotFound);
    
    if(isLoginSuccess){
        MMLog(@"isLoginSuccess~~!");
//        [self loginSuccess:webView];
    }
    
    
    NSLog(@"webView 完成加载");
    
    
    //    getElementById()
    //    getElementsByName()
    //    getElementsByTagName()
}

#pragma mark  -------------- webView 加载错误的时候调用
- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error{
    NSLog(@"加载错误：error%@",error);
    
    //    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    MMLog(@"加载错误：%@",_requestUrlStr);
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
    
    if(DEBUG){
        // 删除节点
//        NSString *str = @"document.getElementsByClassName('clearfix')[0].remove();";
        //    [webView stringByEvaluatingJavaScriptFromString:str];
        
        
        // 修改
//        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('input-block-level')[0].value = '15818630976';"];
//        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('input-block-level')[1].value = '123456';"];
//        return;
        
        // 插入 调用方法
//        [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
//         "script.type = 'text/javascript';"
//         "script.text = \"function myFunction() { "
//         
//         "alert('133331');"
//         "}\";"
//         "document.getElementsByClassName('clearfix')[0].appendChild(script);"];
        
        //    [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
        
        //    document.getElementsByTagName('head')[0].appendChild(script);
        
        
        
        // 插入 div
        //    [webView stringByEvaluatingJavaScriptFromString:@"var abc=document.createElement('div');"
        //     "abc.innerText = 'abc';"
        //     "document.getElementsByClassName('clearfix')[0].appendChild(abc);"
        //     ];
        
        [webView stringByEvaluatingJavaScriptFromString:@"var input = document.getElementsByName('luci_password')[0];"
         "input.value = 'password';"
         ];
    }
   
}



#pragma mark  ------ 主页界面 显示  ---
- (void)loginSuccess:(UIWebView *)webView{
    
    if (DEBUG) {
        
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
}



#pragma mark  -----------  刷新网页 ---------
- (void)reloadWebView:(UIBarButtonItem *)sender{
    [self.bindWebView reload];
}


#pragma mark  -----------  配置网关 ---------
- (void)rightBarItemClick:(UIBarButtonItem *)sender{
    NSString *wifiName = [NetInfo fetchSsid];
    
        NSString *messageStr = [NSString stringWithFormat:@"当前连接热点为：%@，是否需要更换热点？",wifiName];
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

        }]];
        
        [self presentViewController:alertVC animated:YES completion:^{}];
        
        return;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
