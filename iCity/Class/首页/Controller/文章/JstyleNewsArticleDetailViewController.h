//
//  JstyleNewsArticleDetailViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/28.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsArticleDetailModel.h"

@interface JstyleNewsArticleDetailViewController : JstyleNewsBaseViewController

//文章id
@property (nonatomic, copy) NSString *rid;

//titleModel
@property (nonatomic, strong) JstyleNewsArticleDetailModel *titleModel;

@end
