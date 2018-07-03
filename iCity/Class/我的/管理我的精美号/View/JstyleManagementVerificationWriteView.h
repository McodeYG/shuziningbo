//
//  JstyleManagementVerificationWriteView.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/16.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleManagementVerificationWriteView : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, assign) BOOL isShortTextField;

@end
