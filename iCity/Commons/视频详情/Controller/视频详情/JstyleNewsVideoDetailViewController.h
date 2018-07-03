//
//  JstyleNewsVideoDetailViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/4.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsVideoDetailViewController : JstyleNewsBaseViewController
//视频连接
@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *videoTitle;
//视频详情id
@property (nonatomic, copy) NSString *vid;
/**是否是vr; 1.是；2.否*/
@property (nonatomic, copy) NSString *videoType;


/**电视显示电视名字*/
@property (nonatomic, copy) NSString *videoname;

@end
