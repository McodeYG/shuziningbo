//
//  JstyleNewsMyCollectionVedioTableViewCell.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/10/25.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsMyCollectionVedioTableViewCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@interface JstyleNewsMyCollectionVedioTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *playImage;

/**分割线*/
@property (nonatomic, strong) UIView * lineView;

@end

@implementation JstyleNewsMyCollectionVedioTableViewCell

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
    self.holdView.backgroundColor = ISNightMode?kDarkTwoColor:kWhiteColor;
//    self.avatorImageView.layer.cornerRadius = 24 / 2.0;
//    self.avatorImageView.layer.masksToBounds = YES;
//    self.avatorImageView.layer.borderWidth = 1;
//    self.avatorImageView.layer.borderColor = JSColor(@"#E7E4E4").CGColor;
    
    [self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(ArticleImg_W);
        make.height.mas_equalTo(ArticleImg_H);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30*kScale, 30*kScale));
        make.center.mas_equalTo(self.posterImageView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.posterImageView.mas_left).offset(-20);
        make.top.mas_equalTo(self.contentView).offset(13);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-13);
        make.right.mas_equalTo(self.posterImageView.mas_left).offset(-20);
    }];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = kNightModeLineColor;
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setModel:(JstyleNewsMyCollectionModel *)model {
    _model = model;
    [self.posterImageView setImageWithURL:[NSURL URLWithString:model.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.titleLabel.attributedText = [model.title attributedStringWithlineSpace:0 textColor:JSColor(@"#1A1A1A") font:[UIFont fontWithName:@"PingFang SC" size:18]];
    [self.avatorImageView setImageWithURL:[NSURL URLWithString:model.author_img] options:YYWebImageOptionProgressive];

    if ([model.action_time isNotBlank]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@    %@",model.author_name,model.action_time];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"%@   ",model.author_name];
    }
    
    UITapGestureRecognizer *authorTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        JstyleNewsJMNumDetailsViewController *jstyleNewsJmNumsDVC = [JstyleNewsJMNumDetailsViewController new];
        jstyleNewsJmNumsDVC.did = model.author_did;
        [[self viewController].navigationController pushViewController:jstyleNewsJmNumsDVC animated:YES];
    }];
    [self.avatorImageView addGestureRecognizer:authorTap];
}

- (void)setRecentModel:(JstyleNewsRecentReadModel *)recentModel {
    _recentModel = recentModel;
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:recentModel.poster] placeholder:SZ_Place_S_N options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    self.titleLabel.attributedText = [recentModel.title attributedStringWithlineSpace:0 textColor:JSColor(@"#1A1A1A") font:[UIFont fontWithName:@"PingFang SC" size:14]];
    [self.avatorImageView setImageWithURL:[NSURL URLWithString:recentModel.author_img] options:YYWebImageOptionProgressive];
    
    if ([recentModel.action_time isNotBlank]) {
         self.nameLabel.text = [NSString stringWithFormat:@"%@    %@",recentModel.author_name,recentModel.action_time];
    }else{
         self.nameLabel.text = [NSString stringWithFormat:@"%@   ",recentModel.author_name];
    }
   
}

@end
