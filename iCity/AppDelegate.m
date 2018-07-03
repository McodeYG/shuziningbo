//
//  AppDelegate.m
//  iCity
//
//  Created by 王磊 on 2018/4/20.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "AppDelegate.h"
#import "CrashExceptioinCatcher.h"
#import "JstyleNewsNavigationController.h"
#import "JstyleNewsTabBarController.h"
#import "JstyleNewsLoginViewController.h"

#import "JstyleNewsHomeBaseViewController.h"
#import "JstyleNewsVideoBaseViewController.h"

#import "JstyleNewsGuidePagesViewController.h"
#import "JstyleNewsAdvertisementViewController.h"

// 跳转所需控制器
//文章 图集
#import "JstyleNewsArticleDetailViewController.h"
#import "JstylePictureTextViewController.h"


//视频 直播
#import "JstyleNewsVideoDetailViewController.h"
//活动
#import "JstyleNewsActivityWebViewController.h"
//消息 通知


// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic) int type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic) NSInteger ALint;

@property (nonatomic, assign) NSInteger labelSelected;

@end

@implementation AppDelegate

+ (UIWindow *)keyWindow {
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置主题
    [self configTheme];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = kWhiteColor;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"默认主题" forKey:kCurrentTheme];
    
    JstyleNewsTabBarController *tabbarC = [[JstyleNewsTabBarController alloc] initWithViewControllers:nil tabBarItemsAttributes:nil imageInsets:UIEdgeInsetsZero titlePositionAdjustment:UIOffsetZero];
    _window.rootViewController = tabbarC;
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"cca9ab5368ccdd8e8e737bf9"
                          channel:@"Publish channel"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    //让屏幕上的小标为0
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    
    //移除某些判断标记
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JstyleLandscapeRight"];
    //监听登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginInAction) name:@"JstyleLogin" object:nil];
    
//    //获取当前的版本号
//    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationFirstLuanchTag"] isEqualToString:@"1"]) {
//        //第一次启动
//
//        //引导页
//        JstyleNewsGuidePagesViewController *guidePagesVC = [JstyleNewsGuidePagesViewController new];
//        _window.rootViewController = guidePagesVC;
//    } else {
        //第N次启动:可显示广告
        JstyleNewsAdvertisementViewController *adVC = [JstyleNewsAdvertisementViewController new];
        _window.rootViewController = adVC;
//    }

    // 友盟统计方法
    [self umengTrack];
    // 友盟分享
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5aedb973b27b0a244300020d"];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    // 开始捕获程序异常信息, 崩溃时显示错误
    [CrashExceptioinCatcher startCrashExceptionCatch];
    
    [_window makeKeyAndVisible];
    return YES;
}

#pragma mark - 设置主题
- (void)configTheme{
    
    NSString *redJsonPath = [[NSBundle mainBundle] pathForResource:@"tag_red_json" ofType:@"json"];
    NSString *redJson = [NSString stringWithContentsOfFile:redJsonPath encoding:NSUTF8StringEncoding error:nil];
    NSString *blackJsonPath = [[NSBundle mainBundle] pathForResource:@"tag_black_json" ofType:@"json"];
    NSString *blackJson = [NSString stringWithContentsOfFile:blackJsonPath encoding:NSUTF8StringEncoding error:nil];
    NSString *purpleJsonPath = [[NSBundle mainBundle] pathForResource:@"tag_purple_json" ofType:@"json"];
    NSString *purpleJson = [NSString stringWithContentsOfFile:purpleJsonPath encoding:NSUTF8StringEncoding error:nil];
    NSString *blueJsonPath = [[NSBundle mainBundle] pathForResource:@"tag_blue_json" ofType:@"json"];
    NSString *blueJson = [NSString stringWithContentsOfFile:blueJsonPath encoding:NSUTF8StringEncoding error:nil];
    NSString *goldJsonPath = [[NSBundle mainBundle] pathForResource:@"tag_gold_json" ofType:@"json"];
    NSString *goldJson = [NSString stringWithContentsOfFile:goldJsonPath encoding:NSUTF8StringEncoding error:nil];
    NSString *whiteJsonPath = [[NSBundle mainBundle] pathForResource:@"tag_white_json" ofType:@"json"];
    NSString *whiteJson = [NSString stringWithContentsOfFile:whiteJsonPath encoding:NSUTF8StringEncoding error:nil];
    
   
    
    [LEETheme defaultTheme:ThemeName_Black];//设置默认主题
    
    [LEETheme addThemeConfigWithJson:redJson Tag:ThemeName_Red ResourcesPath:nil];
    [LEETheme addThemeConfigWithJson:blackJson Tag:ThemeName_Black ResourcesPath:nil];
    [LEETheme addThemeConfigWithJson:purpleJson Tag:ThemeName_Purple ResourcesPath:nil];
    [LEETheme addThemeConfigWithJson:blueJson Tag:ThemeName_Blue ResourcesPath:nil];
    [LEETheme addThemeConfigWithJson:goldJson Tag:ThemeName_Brown ResourcesPath:nil];
    [LEETheme addThemeConfigWithJson:whiteJson Tag:ThemeName_White ResourcesPath:nil];

    
}

///判断当前设备是否选择过喜好标签
-(void)getLabelSelectedData {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUDID],@"uuid",@"1",@"phone_type", nil];
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager POST:ICity_LABEL_SELECTED parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        self.labelSelected = [dictionary[@"code"] integerValue];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAPPKey appSecret:WXAPPSecret redirectURL:nil];
    
    /*
     设置分享到QQ互联的appID,QQ平台仅需将appID作为U-Share的appKey参数传进即可
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAPPKey  appSecret:nil redirectURL:nil];
    
    /*
     设置新浪的appKey和appSecret
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAPPKey  appSecret:SinaAPPSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)umengTrack
{
    [MobClick setCrashReportEnabled:YES];
    [UMConfigure initWithAppkey:@"5a40c4ecb27b0a1ebe000023" channel:@"App Store"];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}



/**跳转登录控制器*/
- (void)loginInAction
{
    JstyleNewsLoginViewController *jstyleLoginVC = [JstyleNewsLoginViewController new];
    JstyleNewsNavigationController *jstyleNavigationVC = [[JstyleNewsNavigationController alloc] initWithRootViewController:jstyleLoginVC];
    [self.window.rootViewController presentViewController:jstyleNavigationVC animated:YES completion:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JstyleLandscapeRight"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushDidChangedNotification" object:nil];
}

///注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:@"deviceToken"];
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


///注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    //根据type跳转对应控制器: 3.系统消息 6.文章 7.视频 8.直播 9.活动 1.发现话题 2.发现投票 4.发现测试
    NSInteger type = [userInfo[@"type"] integerValue];
    [self jumpViewControllerWithType:type userInfo:userInfo];
    
    //这里设置app的图片的角标为0，红色但角标就会消失
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

// 极光推送
// 当程序从后台将要重新回到前台时候调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //让屏幕上的小标为0
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    [application cancelAllLocalNotifications];
}


#pragma mark - 根据type跳转对应控制器: 3.系统消息 6.文章 7.视频 8.直播 9.活动 1.发现话题 2.发现投票 4.发现测试
- (void)jumpViewControllerWithType:(NSInteger)type userInfo:(NSDictionary *)userInfo{
    
    JstyleNewsTabBarController *tabbar = [[JstyleNewsTabBarController alloc] initWithViewControllers:nil tabBarItemsAttributes:nil imageInsets:UIEdgeInsetsZero titlePositionAdjustment:UIOffsetZero];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = tabbar;
    switch (type) {
        case 1://1.发现话题
        {
            tabbar.selectedIndex = 2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
//                UINavigationController *navigationController = tabbar.childViewControllers[2];
//                JstyleNewsDiscoveryTopicViewController *topicVC = [JstyleNewsDiscoveryTopicViewController new];
//                topicVC.hid = [[userInfo[@"url"] componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"="].lastObject;
//                [navigationController pushViewController:topicVC animated:YES];
            });
        }
            break;
        case 2://2.发现投票
        {
            tabbar.selectedIndex = 2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
//                UINavigationController *navigationController = tabbar.childViewControllers[2];
//                JstyleNewsDiscoveryVoteViewController *voteVC = [JstyleNewsDiscoveryVoteViewController new];
//                voteVC.hid = [[userInfo[@"url"] componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"="].lastObject;
//                [navigationController pushViewController:voteVC animated:YES];
            });
        }
            break;
        case 3://3.系统消息
        {
//            tabbar.selectedIndex = 3;
//            UINavigationController *navigationController = tabbar.childViewControllers[3];
//            JstyleNewsMyMessageViewController *messageVC = [JstyleNewsMyMessageViewController new];
//            messageVC.isNeedToShowNotifications = YES;
//            [navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 4://4.发现测试
        {
            tabbar.selectedIndex = 2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
//                UINavigationController *navigationController = tabbar.childViewControllers[2];
//                JstyleNewsDiscoveryTestViewController *testVC = [JstyleNewsDiscoveryTestViewController new];
//                testVC.hid = [[userInfo[@"url"] componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"="].lastObject;
//                [navigationController pushViewController:testVC animated:YES];
            });
        }
            break;
        case 6://6.文章 or 图集
        {
            tabbar.selectedIndex = 0;
            UINavigationController *navigationController = tabbar.childViewControllers[0];
            if ([userInfo[@"isimage"] integerValue] == 1) {
                //文章
                JstyleNewsArticleDetailViewController *articleVC = [JstyleNewsArticleDetailViewController new];
                articleVC.rid = [[userInfo[@"url"] componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"="].lastObject;
                [navigationController pushViewController:articleVC animated:YES];
            } else {
                //图集
                JstylePictureTextViewController *pictureVC = [JstylePictureTextViewController new];
                pictureVC.rid = [[userInfo[@"url"] componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"="].lastObject;
                [navigationController pushViewController:pictureVC animated:YES];
            }
        }
            break;
        case 7://7.视频
        {
            tabbar.selectedIndex = 0;
            UINavigationController *navigationController = tabbar.childViewControllers[0];
            JstyleNewsVideoDetailViewController *videoVC = [JstyleNewsVideoDetailViewController new];
            NSString *urlString = userInfo[@"url"];
            NSArray *paramatersArray = [[urlString componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"&"];
            videoVC.vid = [paramatersArray.firstObject componentsSeparatedByString:@"="].lastObject;
            videoVC.videoTitle = [paramatersArray[1] componentsSeparatedByString:@"="].lastObject;
            videoVC.videoUrl = [paramatersArray.lastObject componentsSeparatedByString:@"="].lastObject;
            videoVC.videoType = userInfo[@"videoType"];//myg后台推动
            [navigationController pushViewController:videoVC animated:YES];
        }
            break;
        case 8://8.直播
        {
            tabbar.selectedIndex = 0;
            UINavigationController *navigationController = tabbar.childViewControllers[0];
            JstyleNewsVideoDetailViewController *videoVC = [JstyleNewsVideoDetailViewController new];
            NSString *urlString = userInfo[@"url"];
            NSArray *paramatersArray = [[urlString componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"&"];
            videoVC.vid = [paramatersArray.firstObject componentsSeparatedByString:@"="].lastObject;
            videoVC.videoTitle = [paramatersArray[1] componentsSeparatedByString:@"="].lastObject;
            videoVC.videoUrl = [paramatersArray.lastObject componentsSeparatedByString:@"="].lastObject;
            videoVC.videoType = userInfo[@"videoType"];//myg后台推动
            [navigationController pushViewController:videoVC animated:YES];
        }
            break;
        case 9://9.活动
        {
            tabbar.selectedIndex = 0;
            UINavigationController *navigationController = tabbar.childViewControllers[0];
            JstyleNewsActivityWebViewController *acticityVC = [JstyleNewsActivityWebViewController new];
            acticityVC.urlString = userInfo[@"url"];
            [navigationController pushViewController:acticityVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
