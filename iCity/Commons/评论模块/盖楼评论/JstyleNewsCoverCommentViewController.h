//
//  JstyleNewsCoverCommentViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/5.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsCommentViewCell.h"
#import "JstyleNewsCoverCommentViewCell.h"



@interface JstyleNewsCoverCommentViewController : UIViewController

@property (nonatomic, strong) JstyleNewsCommentModel *model;

@property (nonatomic, copy) NSString *vid;

@property (nonatomic, copy) NSString *type;

@end
