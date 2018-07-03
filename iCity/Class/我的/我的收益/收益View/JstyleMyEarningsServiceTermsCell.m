//
//  JstyleMyEarningsServiceTermsCell.m
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import "JstyleMyEarningsServiceTermsCell.h"
#import "JstyleDifferentAgreementViewController.h"
@implementation JstyleMyEarningsServiceTermsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString *text = @"我已阅读并同意服务条款";
    self.nameLabel.attributedText = [text attributedStringWithTextColor:JSColor(@"#7293BF") range:NSMakeRange(7, 4) fontSize:JSFont(13)];
    
    UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTapAction)];
    [self.selectedImageView addGestureRecognizer:selectTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.nameLabel addGestureRecognizer:tap];
}

- (void)selectTapAction
{
    self.cellSelected = !self.cellSelected;
    
    if (self.selectBlock) {
        self.selectBlock(self.cellSelected);
    }
    
    if (self.cellSelected) {
        self.selectedImageView.image = JSImage(@"协议选中");
    }else{
        self.selectedImageView.image = JSImage(@"提现未选中");
    }
}

- (void)tapAction
{
    JstyleDifferentAgreementViewController *webView = [[JstyleDifferentAgreementViewController alloc] init];
    webView.urlStr = @"http://app.jstyle.cn/newwap/index.php/home/Active/zhifubao_agreement";
    [[self viewController].navigationController pushViewController:webView animated:YES];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
