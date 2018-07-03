//
//  JstyleNewsCommentViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/5.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsCommentViewController : JstyleNewsBaseViewController

///1:文章 2:视频 3:发现
@property (nonatomic, copy) NSString * _Nonnull type;
@property (nonatomic, copy) NSString * _Nullable vid;

@end
