//
//  JstyleNewsArticleDetailTitleContentCell.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/29.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsArticleDetailModel.h"
#import "JstyleNewsBaseAttentionButton.h"

@interface ICityCultureDetailTitleContentCell : JstyleNewsBaseTableViewCell

///订阅按钮
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;

@property (nonatomic, strong) JstyleNewsArticleDetailModel *model;

@property (nonatomic, copy) void(^subscribeBlock)(NSString *did);
@property (nonatomic, copy) void(^tapPersonBlock)(NSString *did);

@end
