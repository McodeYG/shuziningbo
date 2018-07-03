//
//  JstyleNewsActivityWebViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/26.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsActivityWebViewController : JstyleNewsBaseViewController

@property (nonatomic, copy) NSString *urlString;
///是否需要仅仅分享图片
@property (nonatomic, assign) BOOL isNeedShareImage;
///是否显示右侧分享按钮(0不显示 1显示)
@property (nonatomic, assign) NSInteger isShare;
///是否需要pop到活动首页
@property (nonatomic, assign) BOOL isNeedPopToFirstVC;

@property (nonatomic, copy) NSString *navigationTitle;

@end
