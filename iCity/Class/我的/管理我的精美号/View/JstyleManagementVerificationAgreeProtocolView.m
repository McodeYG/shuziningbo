//
//  JstyleManagementVerificationAgreeProtocolView.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/18.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementVerificationAgreeProtocolView.h"

@interface JstyleManagementVerificationAgreeProtocolView ()


@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;

@end

@implementation JstyleManagementVerificationAgreeProtocolView

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
    
    [self.agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolTapGesture:)];
    self.protocolLabel.userInteractionEnabled = YES;
    [self.protocolLabel addGestureRecognizer:tap];
    self.protocolLabel.lee_theme
    .LeeConfigTextColor(ThemeMainBtnTitleOrBorderColor);
}

// TODO: 同意协议
- (void)agreeBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    NSLog(@"同意协议");
}

// TODO: 点击协议
- (void)protocolTapGesture:(UITapGestureRecognizer *)tap {
    if (self.agreeProtocolBlock) {
        self.agreeProtocolBlock();
    }
}

@end
