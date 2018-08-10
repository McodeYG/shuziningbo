//
//  JstyleToolManager.h
//  Exquisite
//
//  Created by 数字宁波 on 16/5/11.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface JstyleToolManager : NSObject

+ (instancetype)sharedManager;

//首页和视频栏目缓存
@property (nonatomic, strong) NSMutableDictionary *homeCateCacheDict;
@property (nonatomic, strong) NSMutableDictionary *videoCacheDict;

/**判断当前用户是否是VIP*/
- (BOOL)isVIP;
/**判断当前用户是否是VIP(游客不弹出登录)*/
- (BOOL)isVIPWithoutLogin;

/**判断手机号*/
- (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *密码 字母 数字 下划线 6-20 位  客户要求：密码：6-20位，数字，字母，下划线，至少要数字，字母两种以上不同组合，不能含有空格
 */
- (BOOL)isValidatePassword:(NSString *)passWord;

/**判断邮箱*/
- (BOOL)isEmailNumber:(NSString *)emailNum;
/**判断身份证格式*/
- (BOOL)isIdentityCard:(NSString *)IDCardNumber;
/**非wifi是否播放*/
- (BOOL)isVideoPlayOnlyWifi;

/**获取当前网络状态:1、wifi, 2、移动网络，3、无网络*/
- (NetworkStatus)getCurrentNetStatus;

/**判断登录状态*/
- (BOOL)isTourist;

/**跳转登录页面*/
- (void)loginInViewController;

/**保存登录信息*/
- (void)saveLoginUserInfoWithDictionary:(NSDictionary *)dictionary;

/**获取userId*/
- (NSString *)getUserId;

/**获取userName*/
- (NSString *)getUserName;

/**获取userAvator*/
- (NSString *)getUserAvator;

/**获取uniqueid*/
- (NSString *)getUniqueId;

/**获取userDict*/
- (NSDictionary *)getUserDict;

/**获取用户本地头像Image*/
- (UIImage *)getUserPosterImage;

/**判断用户是否设置过密码*/
- (BOOL)isAllreadySettedPWD;

/**第三方登录*/
- (BOOL)isThirdPartLogin;

/**获取注册的唯一标识符:手机号,第三方id*/
- (NSString *)getUserIdentifier;

/**获取上次登录的userId*/
- (NSString *)getLastLoginUid;

/**退出登录*/
- (void)loginOut;

/**获取纬度*/
- (NSString *)getLatitude;

/**获取经度*/
- (NSString *)getLongitude;

/**获取设备唯一标示*/
- (NSString *)getUDID;

/**引导广告页push*/
- (BOOL)isJiGuangPush;

- (void)removeJiguangPush;

- (BOOL)isCrash;

/**
 分享
 @param shareTitle     分享标题
 @param shareDesc      分享描述
 @param shareImgUrl    分享图片
 @param shareLinkUrl   分享链接
 @param viewController 分享的当前控制器
 */
- (void)shareActionWithShareTitle:(NSString *)shareTitle shareDesc:(NSString *)shareDesc shareImgUrl:(NSString *)shareImgUrl shareLinkUrl:(NSString *)shareLinkUrl viewController:(UIViewController *)viewController;

/**
 分享视频
 @param shareTitle     视频标题
 @param shareDesc      视频描述
 @param shareUrl       视频连接
 @param shareImgUrl    图片连接
 @param viewController 分享的当前控制器
 */
- (void)shareVideoWithShareTitle:(NSString *)shareTitle shareDesc:(NSString *)shareDesc shareUrl:(NSString *)shareUrl shareImgUrl:(NSString *)shareImgUrl viewController:(UIViewController *)viewController;

/**
 分享图片(链接)
 @param shareTitle     图片标题
 @param shareDesc      图片描述
 @param shareUrl       url连接---传图片链接就行
 @param shareImgUrl    图片连接
 @param viewController 分享的当前控制器
 */
- (void)sharePictureWithShareTitle:(NSString *)shareTitle shareDesc:(NSString *)shareDesc shareUrl:(NSString *)shareUrl shareImgUrl:(NSString *)shareImgUrl viewController:(UIViewController *)viewController;

/**
 分享本地图片(UIImage或NSData)

 @param shareTitle  图片标题
 @param shareDesc   图片描述
 @param shareUrl    url地址
 @param shareImg    分享图片Image(UIImage或NSData)
 @param viewController 分享的当前控制器
 */
- (void)sharePictureWithShareTitle:(NSString *)shareTitle shareDesc:(NSString *)shareDesc shareUrl:(NSString *)shareUrl shareImg:(id)shareImg viewController:(UIViewController *)viewController;

/**
 @return 本地返回更改后的标题字体大小
 */
- (UIFont *)getListFontSize;
/**标题字体的大小(配合getListFontSize)*/
@property (nonatomic, strong) UIFont *titleFontSize;

/**
 *  截取URL中的参数
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getDictionaryWithUrlString:(NSString *)urlStr;

//获取字体大小
- (CGFloat )getFontNumber;



@end

