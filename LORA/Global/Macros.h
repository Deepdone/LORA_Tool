//
//  Macros.h
//  iPad
//

#import "AppDelegate.h"

// 测试
#define DEBUG 1


// 标题长
#define TITLE_LEN 10

// 设置字体号
#define SYSTEM_FONT_OF_SIZE(F) [UIFont systemFontOfSize:(F)]

// 沙盒管理
#define USER_DEFAULTS      [NSUserDefaults       standardUserDefaults]

// 通知中心
#define NotificationCenter [NSNotificationCenter defaultCenter]

// self 类名
#define CurrentClassName NSStringFromClass([self class])

#define ClassName(className)  NSStringFromClass([className class])
// 根控制器
#define RooViewController  [UIApplication sharedApplication].keyWindow.rootViewController
// 应用程序托管
#define AppDelegateInstance	                        ((AppDelegate*)([UIApplication sharedApplication].delegate))

//// 其它的宏定义
//#ifdef DEBUG
//	#define                                         LOG(...) NSLog(__VA_ARGS__)
//	#define                                         LOG_METHOD NSLog(@"%s", __func__)
//    #define                                         LOGERROR(...) NSLog(@"%@传入数据有误",__VA_ARGS__)
//#else
//	#define                                         LOG(...)
//	#define                                         LOG_METHOD
//    #define                                         LOGERROR(...) NSLog(@"%@传入数据有误",__VA_ARGS__)
//#endif

//判断系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//判断是否大于 IOS7
#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#define IS_IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

//判断是否是iphone5
#define IS_WIDESCREEN                              ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - (double)568 ) < __DBL_EPSILON__ )

#define IS_IPHONE                                  ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] || [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone Simulator" ])
#define IS_IPOD                                    ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPAD                                    ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPad" ] )
#define IS_IPHONE_5                                ( IS_IPHONE && IS_WIDESCREEN )

//判断字符串是否为空
#define IFISNIL(v)                                 (v = (v != nil) ? v : @"")
//判断NSNumber是否为空
#define IFISNILFORNUMBER(v)                        (v = (v != nil) ? v : [NSNumber numberWithInt:0])
//判断是否是字符串
#define IFISSTR(v)                                 (v = ([v isKindOfClass:[NSString class]]) ? v : [NSString stringWithFormat:@"%@",v])


//全局唯一的window
#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]

//动态获取设备高度
#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
//动态获取设备宽度
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width

//设置颜色
//#define UIColorFromRGB(rgbValue) [UIColor \
//colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
//green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
//blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//设置颜色与透明度
#define HEXCOLORAL(rgbValue, al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

#define COMMENT_COLOR [UIColor colorWithRed:69/255.f green:161/255.f blue:193/255.f alpha:1.0f]



#pragma mark --- 调整行的间距
//UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 200)];
//[label setBackgroundColor:[UIColor blackColor]];
//[label setTextColor:[UIColor whiteColor]];
//[label setNumberOfLines:0];
//
//NSString *labelText = @"可以自己按照宽高，字体大小，来计算有多少行。。然后。。。每行画一个UILabel。。高度自己可以控制把这个写一个自定义的类。 ";
//
//NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
//NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//
//[paragraphStyle setLineSpacing:LINESPACE];//调整行间距
//
//[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
//label.attributedText = attributedString;
//[self.view addSubview:label];
//[label sizeToFit];

#pragma mark --- 颜色宏

#define ClearColor      [UIColor clearColor]
#define RedColor        [UIColor redColor]
#define WhiteColor      [UIColor whiteColor]
#define BlackColor      [UIColor blackColor]
#define GreenColor      [UIColor greenColor]
#define YellowColor     [UIColor yellowColor]
#define BlueColor       [UIColor blueColor]
#define GrayColor       [UIColor grayColor]
#define OrangeColor     [UIColor orangeColor]
#define LightGrayColor  [UIColor lightGrayColor]

#define RGB_A(x)        [UIColor colorWithRed:x/255.0 green:x/255.0 blue:x/255.0 alpha:1.0]     //后缀ABC排序
#define RGB_B(x,y,z)    [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]     //只为控制联想时
#define RGB_C(x,y,z,a)  [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a/1.0]   //出现顺序
#define RGB_D(x,a)      [UIColor colorWithRed:x/255.0 green:x/255.0 blue:x/255.0 alpha:a/1.0]\

#pragma mark ---- 微博
#define weiboAppKey @"3967353320"
#define weiboRedirectURL  @"https://api.weibo.com/oauth2/default.html"  // 

#pragma mark ---- QQ
#define QQAppID  @"1105086766"
#define QQAppKey @"sOQrx2cSx3vZSosH"





#define _IPHONE80_ 80000


