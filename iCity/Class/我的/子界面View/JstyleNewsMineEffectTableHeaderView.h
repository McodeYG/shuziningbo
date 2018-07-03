//
//  JstyleNewsMineEffectTableHeaderView.h
//  JstyleNews
//
//  Created by 数字跃动 on 2018/1/16.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsMineLoginUserInfoModel.h"

@interface JstyleNewsMineEffectTableHeaderView : JstyleNewsBaseView

@property (nonatomic, strong) JstyleNewsMineLoginUserInfoModel *userInfoModel;

@property (nonatomic, copy) void(^loginBlock)();
@property (nonatomic, copy) void(^headerMenuCollectionBlock)();
@property (nonatomic, copy) void(^headerMenuCommentBlock)();
@property (nonatomic, copy) void(^headerMenuMessageBlock)();
@property (nonatomic, copy) void(^headerMenuNightBlock)(UIImageView *nightImageView,UILabel *nightTitleLabel,UIImageView *collectionImageView,UIImageView *commentImageView,UIImageView *messageImageView);
@end
