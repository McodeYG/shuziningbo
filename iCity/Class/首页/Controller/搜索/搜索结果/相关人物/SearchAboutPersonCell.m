//
//  SearchAboutPersonCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "SearchAboutPersonCell.h"


@interface SearchAboutPersonCell ()

/**key--相关人物*/
@property (nonatomic, strong) UILabel * titleLab;

@end


@implementation SearchAboutPersonCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"SearchAboutPersonCell_id";
    SearchAboutPersonCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[SearchAboutPersonCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
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
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, SCREEN_W-20, 20)];
    self.titleLab.font = JSFont(18);
    self.titleLab.textColor = kNightModeTextColor;
    
    [self.contentView addSubview:self.titleLab];
    
    self.collectionView = [[SearchAboutPersonCollectionView alloc] initWithFrame:CGRectMake(0, 15+25+10, kScreenWidth, (212+16+30+30)/2) collectionViewItemSize:CGSizeMake(212/2, (212+16+30+30)/2)];
    
    [self.contentView addSubview:self.collectionView];

}

- (void)setModel:(SearchModel *)model {
    _model = model;
    
    self.collectionView.key = model.key;
    NSString * oldString = [NSString stringWithFormat:@"%@——相关人物",model.key];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc]initWithString:oldString];
    NSRange titleRang = [oldString rangeOfString:model.key];
    NSDictionary *colorAttrDic = @{NSForegroundColorAttributeName:kRedSearchTextColor};
    [titleString setAttributes:colorAttrDic range:titleRang];

    self.titleLab.attributedText = titleString;
}


@end
