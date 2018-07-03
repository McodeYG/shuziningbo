//
//  JstylePartyRegistrationViewCell.h
//  Exquisite
//
//  Created by 赵涛 on 2017/7/6.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputTextFieldBlock)(NSString *inputText);

@interface JstylePartyRegistrationViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;

@property (nonatomic, copy) InputTextFieldBlock inputTextBlock;

@end
