//
//  ICityKnowledgeBaseTableViewCell.m
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityKnowledgeBaseTableViewCell.h"
#import "ICityKnowledgeBaseCollectionView.h"

@interface ICityKnowledgeBaseTableViewCell()

@property (nonatomic, strong) ICityKnowledgeBaseCollectionView *knowledgeBaseCV;

@end

@implementation ICityKnowledgeBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ICityKnowledgeBaseCollectionView *knowledgeBaseCV = [[ICityKnowledgeBaseCollectionView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 278 * kScale + (IS_iPhoneX?20:0))];
    self.knowledgeBaseCV = knowledgeBaseCV;
    
    __weak typeof(self) weakSelf = self;
    knowledgeBaseCV.knowledgeSelectBlock = ^(NSString *selectID) {
        if (weakSelf.knowledgeSelectBlock) {
            weakSelf.knowledgeSelectBlock(selectID);
        }
    };
    [self.contentView addSubview:knowledgeBaseCV];
    [self applyTheme];
}

- (void)setKnowledgeDataArray:(NSArray *)knowledgeDataArray {
    _knowledgeDataArray = knowledgeDataArray;
    
    self.knowledgeBaseCV.knowledgeDataArray = knowledgeDataArray;
}


- (void)applyTheme {
    self.contentView.backgroundColor = kNightModeBackColor;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
