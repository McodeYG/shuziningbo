//
//  SearchAllCityUserCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "SearchAllCityUserCell.h"
#import "JstyleNewsJMAttentionMoreViewController.h"

@interface SearchAllCityUserCell ()


/**文章标题*/
@property (nonatomic, strong) UILabel * titleLab;

/**left*/
@property (nonatomic, strong) UIImageView * leftImg;

/**时间*/
@property (nonatomic, strong) UILabel * timeLab;

@end

@implementation SearchAllCityUserCell


+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"SearchAllCityUserCell_id";
    SearchAllCityUserCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[SearchAllCityUserCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.backgroundColor = kNightModeBackColor;
    
    _tuiJianCollectionView = [[JstyleNewsJMAttentionTuiJianCollectionView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 205) collectionViewItemSize:CGSizeMake((kScreenWidth - 20)/2.3, 205)];
    [self.contentView addSubview:_tuiJianCollectionView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = JSFontWithWeight(15, UIFontWeightMedium);
    nameLabel.text = @"推荐关注iCity";
    nameLabel.textColor = ISNightMode?kDarkNineColor:kDarkZeroColor;
    [self.contentView addSubview:nameLabel];

    
    UIButton *checkMoreBtn = [[UIButton alloc] init];
    checkMoreBtn.titleLabel.font = JSFont(13);
    [checkMoreBtn setTitle:@"查看更多iCity号 >" forState:(UIControlStateNormal)];
    [checkMoreBtn setTitleColor:kDarkNineColor forState:(UIControlStateNormal)];
    [checkMoreBtn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [checkMoreBtn addTarget:self action:@selector(checkMoreBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [checkMoreBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.contentView addSubview:checkMoreBtn];
    
    
    nameLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(150)
    .heightIs(18);
    
    
    checkMoreBtn.sd_layout
    .bottomSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .widthIs(180)
    .heightIs(18);
        
}

#pragma mark - 查看更多iCity号
- (void)checkMoreBtnClicked:(UIButton *)sender
{
    JstyleNewsJMAttentionMoreViewController *jstyleNewsJMAttentionMVC = [JstyleNewsJMAttentionMoreViewController new];
    [self.viewController.navigationController pushViewController:jstyleNewsJMAttentionMVC animated:YES];
}



@end
