//
//  SearchAboutSearchCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "SearchAboutSearchCell.h"

@interface SearchAboutSearchCell ()


/**文章标题*/
@property (nonatomic, strong) UILabel * titleLab;

/**left*/
@property (nonatomic, strong) UIImageView * leftImg;
/**中间的*/
@property (nonatomic, strong) UIImageView * midImg;
/**right*/
@property (nonatomic, strong) UIImageView * rightImg;

/**时间*/
@property (nonatomic, strong) UILabel * timeLab;

@end


@implementation SearchAboutSearchCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"SearchAboutSearchCell_id";
    SearchAboutSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[SearchAboutSearchCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
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
    
    UIView * topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 6)];
    topLine.backgroundColor = kNightModeLineColor;
    [self.contentView addSubview:topLine];
    
    UIView * bottomLine = [[UIView alloc]init];
    
    self.collectionView = [[AboutSearchCollectionView alloc] initWithFrame:CGRectMake(0, 6, SCREEN_W, 41*4) collectionViewItemSize:CGSizeMake(SCREEN_W/2-0.3, 41)];
    
    [self.contentView addSubview:self.collectionView];
    
    
    bottomLine.backgroundColor = kNightModeLineColor;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.mas_equalTo(6);
    }];
    
}

-(void)setModel:(SearchModel *)model {
    _model = model;
    
    NSInteger count = model.searchRsResult.count;
    int num = (int)count/2;
    self.contentView.mj_h = 41*num;
}



@end
