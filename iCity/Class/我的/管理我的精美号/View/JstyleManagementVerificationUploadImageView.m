//
//  JstyleManagementVerificationUploadImageView.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/16.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementVerificationUploadImageView.h"

@interface JstyleManagementVerificationUploadImageView()



@end

@implementation JstyleManagementVerificationUploadImageView

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
    self.summaryLabel.textColor = kPlaceholderColor;
    
}

@end
