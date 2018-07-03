//
//  JstyleNewsVideoDetailIntroNoJmsViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoDetailIntroNoJmsViewCell.h"
#import "JstyleNewsTagsVideoViewController.h"

@implementation JstyleNewsVideoDetailIntroNoJmsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _tagsView = [[ZTTagListView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth - 5, 0)];
    _tagsView.canTouch = YES;
    _tagsView.signalTagColor = [UIColor whiteColor];
    _tagsView.tagBackgroundColor = JSColor(@"#F1F1F1");
    _tagsView.tagFont = 11;
    _tagsView.cornerRadius = 11;
    _tagsView.verticalPadding = 9;
    _tagsView.titleColor = kDarkSixColor;
    [self.contentView addSubview:_tagsView];
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    self.nameLabel.isAttributedContent = YES;
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.nameLabel, 20)
    .leftSpaceToView(self.contentView, 15)
    .heightIs(11);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.playImageView.sd_layout
    .centerYEqualToView(self.timeLabel)
    .leftSpaceToView(self.timeLabel, 6)
    .widthIs(11)
    .heightIs(11);
    
    self.playNumLabel.sd_layout
    .centerYEqualToView(self.playImageView)
    .leftSpaceToView(self.playImageView, 6)
    .heightIs(12);
    [self.playNumLabel setSingleLineAutoResizeWithMaxWidth:100];
}

- (void)setModel:(JstyleNewsVideoDetailIntroModel *)model
{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@", model.title];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", model.ctime];
    self.playNumLabel.text = [model.play_num dealNumberStr];
    
    NSArray *keywords = [model.keywords componentsSeparatedByString:@","];
    NSMutableArray *keywordsArr = [NSMutableArray array];
    for (NSString *key in keywords) {
        [keywordsArr addObject:[NSString stringWithFormat:@"#%@", key]];
    }
    
    [self.tagsView setTagWithTagArray:keywordsArr];
    self.tagsView.sd_layout
    .topSpaceToView(self.nameLabel, 15)
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(self.tagsView.height);
    __weak typeof(self)weakSelf = self;
    [_tagsView setDidselectItemBlock:^(NSInteger indexPath) {
        JstyleNewsTagsVideoViewController *tagsViewVC = [JstyleNewsTagsVideoViewController new];
        tagsViewVC.keyword = keywords[indexPath];
        [[weakSelf viewController].navigationController pushViewController:tagsViewVC animated:YES];
    }];
    
    [self setupAutoHeightWithBottomView:self.tagsView bottomMargin:10];
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
    
    // Configure the view for the selected state
}

@end

