//
//  ICityHotProgramTableViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityHotProgramTableViewCell.h"
#import "ICityHotProgramCollectionView.h"

static CGFloat middleMargin = 5;
static CGFloat sideMargin = 8;

@interface ICityHotProgramTableViewCell()

@property (nonatomic, strong) ICityHotProgramCollectionView *hotProgramCV;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;


@end

@implementation ICityHotProgramTableViewCell

- (void)awakeFromNib {
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
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [UILabel labelWithColor:kDarkTwoColor fontSize:18 text:@"热门节目" alignment:NSTextAlignmentLeft];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(8, 0, self.titleLabel.width, self.titleLabel.height);
    [self.contentView addSubview:self.titleLabel];
    
    
    CGFloat cellWidth = (kScreenWidth - sideMargin*2 - middleMargin)/ 2.0;
    CGFloat cellHeight = cellWidth * 111.0/177.0;
    CGRect collectionViewFrame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, kScreenWidth, cellHeight * 2 + middleMargin + 10);
    ICityHotProgramCollectionView *hotProgramCV = [[ICityHotProgramCollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.hotProgramCV = hotProgramCV;
    
    __weak typeof(self) weakSelf = self;
    hotProgramCV.hotProgramClickBlock = ^(NSString *vid, NSString *url) {
        if (weakSelf.hotProgramClickBlock) {
            weakSelf.hotProgramClickBlock(vid, url);
        }
    };
    [self.contentView addSubview:hotProgramCV];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = kNightModeLineColor;
    [self addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(0);
        make.height.offset(0.5);
    }];
    
    [self applyTheme];
}

- (void)setHotProgramArray:(NSArray *)hotProgramArray {
    _hotProgramArray = hotProgramArray;
    
    self.hotProgramCV.hotProgramArray = hotProgramArray;
}


- (void)applyTheme {
    [super applyTheme];
    self.titleLabel.textColor = kNightModeTextColor;
    self.line.backgroundColor = kNightModeLineColor;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
