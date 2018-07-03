//
//  JstyleToolManager.m
//  Exquisite
//
//  Created by 赵涛 on 16/5/11.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JstyleToolManager.h"
#import "ActionSheetView.h"
#import "DeviceUUID.h"

@implementation JstyleToolManager

static id _instance = nil;
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JstyleToolManager alloc] init];
    });
    return _instance;
}

- (BOOL)isVIP {
    if ([self isTourist]) {
        [self loginInViewController];
        return NO;
    } else {
        NSString *vip = [[NSUserDefaults standardUserDefaults] objectForKey:@"isbetauser"];
        if (vip.integerValue == 2) {
            [self pushVIPAppPayViewController];
            return NO;
        }else{
            return YES;
        }
    }
}

- (BOOL)isVIPWithoutLogin {
    if ([self isTourist]) {
        return NO;
    } else {
        NSString *vip = [[NSUserDefaults standardUserDefaults] objectForKey:@"isbetauser"];
        if (vip.integerValue == 2) {
            return NO;
        }else{
            return YES;
        }
    }
}

- (void)pushVIPAppPayViewController{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VIPPAY" object:nil];
}

- (NSMutableDictionary *)homeCateCacheDict
{
    if (!_homeCateCacheDict) {
        _homeCateCacheDict = [NSMutableDictionary dictionary];
    }
    return _homeCateCacheDict;
}

- (NSMutableDictionary *)videoCacheDict
{
    if (!_videoCacheDict) {
        _videoCacheDict = [NSMutableDictionary dictionary];
    }
    return _videoCacheDict;
}

- (BOOL)isMobileNumber:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if ([regextestmobile evaluateWithObject:mobileNum] == YES){
        return YES;
    }else{
        return NO;
    }
}

//判断身份证格式
- (BOOL)isIdentityCard:(NSString *)IDCardNumber {
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

- (BOOL)isEmailNumber:(NSString *)emailNum{
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:emailNum];
}

//密码 字母 数字 下划线 6-20 位  客户要求：密码：6-20位，数字，字母，下划线，至少要数字，字母两种以上不同组合，不能含有空格
- (BOOL)isValidatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^([A-Z]|[a-z]|[0-9]|[`~!@#$%^&*()+=|{}':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“'。，、？]){6,20}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

- (BOOL)isVideoPlayOnlyWifi
{
    NSString * videoPlayOnlyWifi = [[NSUserDefaults standardUserDefaults]objectForKey:@"PlayVideoOnlyWiFi"];
    if (videoPlayOnlyWifi) {
        return YES;
    }else{
        return NO;
    }
}

- (NetworkStatus)getCurrentNetStatus
{
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    return internetStatus;
}
/**是否是游客*/
- (BOOL)isTourist
{
    NSString * userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    if (userId) {
        return NO;
    }else{
        return YES;
    }
}

- (void)loginInViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JstyleLogin" object:nil];
}

/**保存登录信息*/
- (void)saveLoginUserInfoWithDictionary:(NSDictionary *)dictionary
{
    [[NSUserDefaults standardUserDefaults]setObject:dictionary[@"avator"] forKey:@"headimgurl"];
    [[NSUserDefaults standardUserDefaults]setObject:dictionary[@"nick_name"] forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:dictionary[@"id"] forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults]setObject:dictionary[@"phone"] forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults]setObject:dictionary[@"uniqueid"] forKey:@"uniqueid"];
    [[NSUserDefaults standardUserDefaults]setObject:dictionary[@"password"] forKey:@"password"];
    //设置别名
    [JPUSHService setAlias:[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (seq == 10000) {
            NSLog(@"iAlias:%@",iAlias);
        }
    } seq:10000];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myCircleLoginAction" object:nil];
}

/**获取userDict*/
- (NSDictionary *)getUserDict
{
    NSString *avator = [[NSUserDefaults standardUserDefaults] objectForKey:@"headimgurl"];
    NSString *nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:avator,@"avator",nickname,@"nickname",uid,@"uid",phone,@"phone",password,@"password", nil];
    return dictionary;
}

- (NSString *)getUserId
{
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    if (userId == nil || [userId isKindOfClass:[NSNull class]] || userId.length == 0) return @"";
    return userId;
}

- (BOOL)isAllreadySettedPWD {
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if ([pwd isEqualToString:@""] || pwd == nil) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)getUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    if (userName == nil || [userName isKindOfClass:[NSNull class]] || userName.length == 0) return @"";
    return userName;
}

- (NSString *)getUserAvator
{
    NSString *userAvator = [[NSUserDefaults standardUserDefaults]objectForKey:@"headimgurl"];
    if (userAvator == nil || [userAvator isKindOfClass:[NSNull class]] || userAvator.length == 0) return @"";
    return userAvator;
}

- (UIImage *)getUserPosterImage {
    
    //先去本地存好的
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserPosterImage"] != nil) {
        
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPosterImage"];
        UIImage* image = [UIImage imageWithData:imageData];
        return image;
    
    } else if ([self getUserAvator] != nil || ![[self getUserAvator] isEqualToString:@""]) {
        //如果本地没有,再从网络获取
        __block UIImage *posterImage = [UIImage new];
        [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:[self getUserAvator]] options:YYWebImageOptionProgressive progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (stage == YYWebImageStageFinished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"UserPosterImage"];
                    posterImage = image;
                });
            }
        }];
        return posterImage;
        
    } else {
        //网络获取不到,给占位图
        return [UIImage imageNamed:@"登录头像"];
    }
}

- (NSString *)getUniqueId
{
    NSString *uniqueId = [[NSUserDefaults standardUserDefaults]objectForKey:@"uniqueid"];
    if (uniqueId == nil || [uniqueId isKindOfClass:[NSNull class]] || uniqueId.length == 0) return @"";
    return uniqueId;
}

- (NSString *)getUserIdentifier
{
    NSString *userIdentifier = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    if (userIdentifier == nil || [userIdentifier isKindOfClass:[NSNull class]] || userIdentifier.length == 0) return @"";
    return userIdentifier;
}

- (NSString *)getLastLoginUid
{
    NSString *lastLoginUid = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastLoginUid"];
    if (lastLoginUid == nil || [lastLoginUid isKindOfClass:[NSNull class]] || lastLoginUid.length == 0) return @"";
    return lastLoginUid;
}

- (BOOL)isThirdPartLogin
{
    NSString *wxLogin = [[NSUserDefaults standardUserDefaults]objectForKey:@"wxLogin"];
    NSString *qqLogin = [[NSUserDefaults standardUserDefaults]objectForKey:@"qqLogin"];
    NSString *wbLogin = [[NSUserDefaults standardUserDefaults]objectForKey:@"wbLogin"];
    if (wxLogin || qqLogin || wbLogin) {
        return YES;
    }else{
        return NO;
    }
}

/**退出登录清掉缓存信息*/
- (void)loginOut
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"wxLogin"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"qqLogin"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"wbLogin"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"usid"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"headimgurl"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"phone"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"uniqueid"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isbetauser"];
}

/**获取用户的纬度信息*/
- (NSString *)getLatitude
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
}

/**获取用户的经度信息*/
- (NSString *)getLongitude
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
}


/**获取设备唯一标示*/
- (NSString *)getUDID
{
    return [DeviceUUID getUUID];
}

/**引导广告页push*/
- (BOOL)isJiGuangPush
{
    NSString *welComePush = [[NSUserDefaults standardUserDefaults] objectForKey:@"JiGuangPush"];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.jstyle.app"];
    NSString *isWidget = [userDefaults objectForKey:@"isWidget"];
    NSString *threeTouch = [[NSUserDefaults standardUserDefaults] objectForKey:@"threeTouch"];
    NSString *isIMessageExtension = [[NSUserDefaults standardUserDefaults] objectForKey:@"iMessageExtension"];
    if (welComePush || isWidget || threeTouch || isIMessageExtension) {
        return YES;
    }else{
        return NO;
    }
}

- (void)removeJiguangPush
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"JiGuangPush"];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.jstyle.app"];
    [userDefaults removeObjectForKey:@"isWidget"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"threeTouch"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"iMessageExtension"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"crash"];
}

- (BOOL)isCrash
{
    NSString *crash = [[NSUserDefaults standardUserDefaults]  objectForKey:@"crash"];
    if ([crash integerValue] == 404) {
        return YES;
    }
    return NO;
}

- (void)shareActionWithShareTitle:(NSString *)shareTitle shareDesc:(NSString *)shareDesc shareImgUrl:(NSString *)shareImgUrl shareLinkUrl:(NSString *)shareLinkUrl viewController:(UIViewController *)viewController
{
    if ([self getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    shareTitle = [NSString stringWithFormat:@"%@", shareTitle];
    shareDesc = [NSString stringWithFormat:@"%@", shareDesc];
    shareLinkUrl = [NSString stringWithFormat:@"%@", shareLinkUrl];
    shareImgUrl = [NSString stringWithFormat:@"%@", shareImgUrl];
    
    if ([shareTitle isEmptyEstring] || [shareDesc isEmptyEstring] || [shareLinkUrl isEmptyEstring] || [shareImgUrl isEmptyEstring]) {
        ZTShowAlertMessage(@"分享数据正在获取, 请稍后再试");
        return;
    }
    
    NSArray *titlearr = @[@"",@"",@"",@"",@""];
    NSArray *imageArr = @[@"UMS_wechat_session_icon",@"UMS_wechat_timeline_icon",@"UMS_qq_icon",@"UMS_sina_icon",@"fuzhilainjie"];
    
    ActionSheetView *actionsheet = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"测试" and:ShowTypeIsShareStyle];
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareDesc thumImage:shareImgUrl];
        //设置网页地址
        shareObject.webpageUrl = shareLinkUrl;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        // 显示在前面的图片
        if (btnTag == 0) {
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:viewController completion:nil];
        }else if (btnTag == 1){
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:viewController completion:^(id result, NSError *error) {
                SVProgressHUD.minimumDismissTimeInterval = 1.0;
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                }
            }];
        }else if (btnTag == 2){
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_QQ)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/qq/id444934666?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:viewController completion:nil];
        }else if (btnTag == 3){
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_Sina)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/sina/id350962117?mt=8"]];
                return;
            }
            messageObject.text = [NSString stringWithFormat:@"%@数字文化城市（想看更多？下载数字宁波APPhttps://www.jianshu.com/p/fd01efdb12fa）%@",shareTitle, shareLinkUrl];
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:shareImgUrl];
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:viewController completion:nil];
            
        }else if (btnTag == 4){
            UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
            pastboad.string = shareLinkUrl;
            ZTShowAlertMessage(@"复制链接成功");
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
}

- (void)shareVideoWithShareTitle:(NSString *)shareTitle shareDesc:(NSString *)shareDesc shareUrl:(NSString *)shareUrl shareImgUrl:(NSString *)shareImgUrl viewController:(UIViewController *)viewController
{
    if ([self getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    shareTitle = [NSString stringWithFormat:@"%@", shareTitle];
    shareDesc = [NSString stringWithFormat:@"%@", shareDesc];
    shareUrl = [NSString stringWithFormat:@"%@", shareUrl];
    shareImgUrl = [NSString stringWithFormat:@"%@", shareImgUrl];
    if ([shareTitle isEmptyEstring] || [shareDesc isEmptyEstring] || [shareUrl isEmptyEstring] || [shareImgUrl isEmptyEstring]) {
        ZTShowAlertMessage(@"分享数据正在获取, 请稍后再试");
        return;
    }
    
    NSArray *titlearr = @[@"",@"",@"",@"",@""];
    NSArray *imageArr = @[@"UMS_wechat_session_icon",@"UMS_wechat_timeline_icon",@"UMS_qq_icon",@"UMS_sina_icon",@"fuzhilainjie"];
    
    ActionSheetView *actionsheet = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"测试" and:ShowTypeIsShareStyle];
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建视频内容对象
        UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:shareTitle descr:shareDesc thumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgUrl]]]];
        //设置视频网页播放地址
        shareObject.videoUrl = shareUrl;
        //shareObject.videoStreamUrl = shareVideoUrl;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        // 显示在前面的图片
        if (btnTag == 0) {
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:viewController completion:nil];
        }else if (btnTag == 1){
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:viewController completion:^(id result, NSError *error) {
                SVProgressHUD.minimumDismissTimeInterval = 1.0;
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                }
            }];
        }else if (btnTag == 2){
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_QQ)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/qq/id444934666?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:viewController completion:nil];
        }else if (btnTag == 3){
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_Sina)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/sina/id350962117?mt=8"]];
                return;
            }
            messageObject.text = [NSString stringWithFormat:@"%@数字文化城市（想看更多？下载数字宁波APPhttps://www.jianshu.com/p/fd01efdb12fa）%@",shareTitle, shareUrl];
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:shareImgUrl];
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:viewController completion:nil];
        }else if (btnTag ==4){
            UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
            pastboad.string = shareUrl;
            ZTShowAlertMessage(@"复制链接成功");
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
}

- (void)sharePictureWithShareTitle:(NSString *)shareTitle shareDesc:(NSString *)shareDesc shareUrl:(NSString *)shareUrl shareImgUrl:(NSString *)shareImgUrl viewController:(UIViewController *)viewController
{
    if ([self getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    shareUrl = [NSString stringWithFormat:@"%@", shareUrl];
    shareImgUrl = [NSString stringWithFormat:@"%@", shareImgUrl];
    if ([shareUrl isEmptyEstring] || [shareImgUrl isEmptyEstring]) {
        ZTShowAlertMessage(@"分享数据正在获取, 请稍后再试");
        return;
    }
    
    NSArray *titlearr = @[@"",@"",@"",@"",@""];
    NSArray *imageArr = @[@"UMS_wechat_session_icon",@"UMS_wechat_timeline_icon",@"UMS_qq_icon",@"UMS_sina_icon",@"fuzhilainjie"];
    
    ActionSheetView *actionsheet = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"测试" and:ShowTypeIsShareStyle];
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = [UIImage imageNamed:@"icon80"];
        [shareObject setShareImage:shareImgUrl];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        // 显示在前面的图片
        if (btnTag ==0) {
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                return;
            }
                
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:viewController completion:nil];
        }else if (btnTag ==1){
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:viewController completion:^(id result, NSError *error) {
                SVProgressHUD.minimumDismissTimeInterval = 1.0;
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                }
            }];
        }else if (btnTag ==2){
            if ( ![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_QQ)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/qq/id444934666?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:nil];
        }else if (btnTag ==3){
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_Sina)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/sina/id350962117?mt=8"]];
                return;
            }
            messageObject.text = [NSString stringWithFormat:@"%@数字文化城市（想看更多？下载数字宁波APPhttps://www.jianshu.com/p/fd01efdb12fa）%@",shareTitle, shareUrl];
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:viewController completion:nil];
        }else if (btnTag ==4){
            UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
            pastboad.string = shareUrl;
            ZTShowAlertMessage(@"复制链接成功");
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
}

- (void)sharePictureWithShareTitle:(NSString *)shareTitle shareDesc:(NSString *)shareDesc shareUrl:(NSString *)shareUrl shareImg:(id)shareImg viewController:(UIViewController *)viewController
{
    if ([self getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
    shareUrl = [NSString stringWithFormat:@"%@", shareUrl];
    if ([shareUrl isEmptyEstring]) {
        ZTShowAlertMessage(@"分享数据正在获取, 请稍后再试");
        return;
    }
    
    NSArray *titlearr = @[@"",@"",@"",@"",@""];
    NSArray *imageArr = @[@"UMS_wechat_session_icon",@"UMS_wechat_timeline_icon",@"UMS_qq_icon",@"UMS_sina_icon",@"fuzhilainjie"];
    
    ActionSheetView *actionsheet = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"测试" and:ShowTypeIsShareStyle];
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = [UIImage imageNamed:@"icon80"];
        [shareObject setShareImage:shareImg];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        // 显示在前面的图片
        if (btnTag ==0) {
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                return;
            }
            
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:viewController completion:nil];
        }else if (btnTag ==1){
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:viewController completion:^(id result, NSError *error) {
                SVProgressHUD.minimumDismissTimeInterval = 1.0;
                if (error) {
                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                }
            }];
        }else if (btnTag ==2){
            if ( ![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_QQ)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/qq/id444934666?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:nil];
        }else if (btnTag ==3){
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_Sina)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/sina/id350962117?mt=8"]];
                return;
            }
            messageObject.text = [NSString stringWithFormat:@"%@数字文化城市（想看更多？下载数字宁波APPhttps://www.jianshu.com/p/fd01efdb12fa）%@",shareTitle, shareUrl];
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:viewController completion:nil];
        }else if (btnTag ==4){
            UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
            pastboad.string = shareUrl;
            ZTShowAlertMessage(@"复制链接成功");
        }
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
}


- (UIFont *)getListFontSize
{
    NSString *fontSize = [[NSUserDefaults standardUserDefaults] valueForKey:@"JstyleNewsFontSize"];
    if (fontSize == nil || [fontSize isKindOfClass:[NSNull class]] || fontSize.length == 0) return JSFont(18.0);
    if ([fontSize isEqualToString:@"小"]) return JSFont(15.0);
    if ([fontSize isEqualToString:@"大"]) return JSFont(20.0);
    if ([fontSize isEqualToString:@"特大"]) return JSFont(22.0);
    return JSFont(17.0);
}

- (CGFloat )getFontNumber
{
    NSString *fontSize = [[NSUserDefaults standardUserDefaults] valueForKey:@"JstyleNewsFontSize"];
    if (fontSize == nil || [fontSize isKindOfClass:[NSNull class]] || fontSize.length == 0) return (18.0);
    if ([fontSize isEqualToString:@"小"]) return (15.0);
    if ([fontSize isEqualToString:@"大"]) return (20.0);
    if ([fontSize isEqualToString:@"特大"]) return (22.0);
    return (17.0);
}

- (UIFont *)titleFontSize
{
    if (!_titleFontSize) {
        _titleFontSize = [self getListFontSize];
    }
    return _titleFontSize;
}

- (NSMutableDictionary *)getDictionaryWithUrlString:(NSString *)urlStr {
    
    // 查找参数
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}



@end
