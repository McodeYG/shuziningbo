//
//  ICityCultureDetailViewController.h
//  iCity
//
//  Created by 王磊 on 2018/5/3.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsArticleDetailModel.h"

@interface ICityCultureDetailViewController : JstyleNewsBaseViewController

//文章id
@property (nonatomic, copy) NSString *rid;

//封面图
@property (nonatomic, strong) UIImage *poster;
//titleModel
@property (nonatomic, strong) JstyleNewsArticleDetailModel *titleModel;

@end
