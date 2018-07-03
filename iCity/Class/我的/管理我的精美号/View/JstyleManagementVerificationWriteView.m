//
//  JstyleManagementVerificationWriteView.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/16.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementVerificationWriteView.h"

@interface JstyleManagementVerificationWriteView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *starIconLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@end

@implementation JstyleManagementVerificationWriteView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.textField.delegate = self;
    self.starIconLabel.textColor = [UIColor colorFromHex:0xEE6767];
    self.textField.layer.borderColor = (ISNightMode?kDarkThreeColor:JSColor(@"#DEDEDE")).CGColor;
    self.textField.layer.borderWidth = 0.5;
    self.textField.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
    //设置textField文字左边距
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

- (void)setIsShortTextField:(BOOL)isShortTextField {
    _isShortTextField = isShortTextField;
    
    if (isShortTextField) {
        self.leftConstraint.constant = 131;
    } else {
        self.leftConstraint.constant = 103;
    }
    
}

@end
