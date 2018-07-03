//
//  JstyleNewsMineTableViewCell.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsMineTableViewCell : JstyleNewsBaseTableViewCell

@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet JstyleNewsBaseLineView *lineView;

@end
