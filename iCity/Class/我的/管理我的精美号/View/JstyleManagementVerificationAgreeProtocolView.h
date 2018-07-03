//
//  JstyleManagementVerificationAgreeProtocolView.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/18.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleManagementVerificationAgreeProtocolView : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (nonatomic, copy) void(^agreeProtocolBlock)();

@end
