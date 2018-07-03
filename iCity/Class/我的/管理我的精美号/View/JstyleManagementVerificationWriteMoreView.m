//
//  JstyleManagementVerificationWriteMoreView.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/16.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementVerificationWriteMoreView.h"

@interface JstyleManagementVerificationWriteMoreView () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *starIconLabel;

@end

@implementation JstyleManagementVerificationWriteMoreView

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
    
    self.placeholderLabel.textColor = ISNightMode?kDarkNineColor:kPlaceholderColor;
    [self.placeholderLabel sizeToFit];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView).offset(7);
        make.top.equalTo(self.textView).offset(8);
    }];
    
    self.textView.layer.borderColor = (ISNightMode?kDarkThreeColor:JSColor(@"#DEDEDE")).CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
    self.textView.backgroundColor = kNightModeBackColor;

    self.textView.textContainerInset = UIEdgeInsetsMake(8, 2, 8, 8);
    
    self.starIconLabel.textColor = [UIColor colorFromHex:0xEE6767];
    self.textView.delegate = self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    self.placeholderLabel.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""] || textView.text == nil) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""] || textView.text == nil) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
