//
//  JstyleManagementVerificationSelectedView.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/16.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementVerificationSelectedView.h"

@interface JstyleManagementVerificationSelectedView ()

@property (weak, nonatomic) IBOutlet UILabel *starIconLabel;

@end

@implementation JstyleManagementVerificationSelectedView

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
    
    self.starIconLabel.textColor = [UIColor colorFromHex:0xEE6767];
    
    [self.rightBtn setTitleColor:ISNightMode?kDarkNineColor:kPlaceholderColor forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:ISNightMode?kDarkNineColor:kPlaceholderColor forState:UIControlStateSelected];
    self.rightBtn.layer.borderWidth = 0.5;
    self.rightBtn.layer.borderColor = (ISNightMode?kDarkThreeColor:JSColor(@"#DEDEDE")).CGColor;
    [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
}

@end
