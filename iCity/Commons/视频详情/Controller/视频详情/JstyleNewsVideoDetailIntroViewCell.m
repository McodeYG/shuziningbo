//
//  JstyleNewsVideoDetailIntroViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/4.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoDetailIntroViewCell.h"
#import "JstyleNewsTagsVideoViewController.h"

@implementation JstyleNewsVideoDetailIntroViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headerImageView.layer.cornerRadius = 15;
    self.headerImageView.layer.masksToBounds = YES;
    
    __weak typeof(self)weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (weakSelf.jmNumDetailBlock) {
            weakSelf.jmNumDetailBlock(weakSelf.model.author_did);
        }
    }];
    [self.headerImageView addGestureRecognizer:tap];
    
    [self.heartBtn addTarget:self action:@selector(praiseAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.focusBtn addTarget:self action:@selector(praiseAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _tagsView = [[ZTTagListView alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth - 5, 0)];
    _tagsView.canTouch = YES;
    _tagsView.titleColor = ISNightMode?JSColor(@"888888"):kDarkSixColor;
    _tagsView.GBbackgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    _tagsView.tagBackgroundColor = ISNightMode? kDarkThreeColor:JSColor(@"#F1F1F1");
    _tagsView.tagFont = 11;
    _tagsView.cornerRadius = 11;
    _tagsView.verticalPadding = 9;
    [self.contentView addSubview:_tagsView];
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    self.nameLabel.isAttributedContent = YES;
    
    self.headerImageView.sd_layout
    .topSpaceToView(self.nameLabel, 15)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(30)
    .heightIs(30);
    
    self.nickNameLabel.sd_layout
    .topSpaceToView(self.nameLabel, 17)
    .leftSpaceToView(self.headerImageView, 10)
    .heightIs(11);
    [self.nickNameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.nickNameLabel, 5)
    .leftSpaceToView(self.headerImageView, 10)
    .heightIs(11);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.playImageView.sd_layout
    .centerYEqualToView(self.headerImageView)
    .leftSpaceToView(@[self.nickNameLabel,self.timeLabel], 25)
    .widthIs(11)
    .heightIs(11);
    
    self.playNumLabel.sd_layout
    .centerYEqualToView(self.playImageView)
    .leftSpaceToView(self.playImageView, 5)
    .heightIs(12);
    [self.playNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.focusBtn.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.headerImageView)
    .widthIs(70)
    .heightIs(30);
    
    self.heartBtn.sd_layout
    .rightSpaceToView(self.focusBtn, 5)
    .centerYEqualToView(self.focusBtn)
    .widthIs(15)
    .heightIs(14);
}

- (void)setModel:(JstyleNewsVideoDetailIntroModel *)model
{
    _model = model;
    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.author_img] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@", model.title];
    if ([model.videoname isNotBlank]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@", model.videoname];
    }
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@", model.author_name];
    
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@", model.ctime];
    
    self.playNumLabel.text = [NSString stringWithFormat:@"%@次播放", [model.play_num dealNumberStr]];
    
    switch ([model.isShowAuthor integerValue]) {
        case 1:{
//            [self.heartBtn setImage:[[UIImage imageNamed:@"视频已关注"] imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:(UIControlStateNormal)];
            self.focusBtn.selected = YES;
        }
            break;
        case 2:{
//            [self.heartBtn setImage:[[UIImage imageNamed:@"视频关注"] imageWithRenderingMode:UIImageRenderingModeAutomatic]forState:(UIControlStateNormal)];
            self.focusBtn.selected = NO;
        }
            break;
        default:
            break;
    }
    
    NSArray *keywords = [model.keywords componentsSeparatedByString:@","];
    NSMutableArray *keywordsArr = [NSMutableArray array];
    for (NSString *key in keywords) {
        [keywordsArr addObject:[NSString stringWithFormat:@"#%@", key]];
    }
    
    [self.tagsView setTagWithTagArray:keywordsArr];
    self.tagsView.sd_layout
    .topSpaceToView(self.headerImageView, 15)
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
#pragma mark - 关注
- (void)praiseAction:(UIButton *)sender
{
    if (self.focusBlock) {
        self.focusBlock();
    }
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.focusBtn.layer.cornerRadius = self.focusBtn.height / 2.0;
    self.focusBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14];
}

@end
