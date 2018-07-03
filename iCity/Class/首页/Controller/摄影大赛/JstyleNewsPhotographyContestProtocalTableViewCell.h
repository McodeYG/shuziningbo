//
//  JstyleNewsPhotographyContestProtocalTableViewCell.h
//  JstyleNews
//
//  Created by 王磊 on 2018/3/23.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsPhotographyContestProtocalTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^agreeBtnBlock)(UIButton *button);
@property (nonatomic, copy) void(^tapProtocalBlock)();

@end
