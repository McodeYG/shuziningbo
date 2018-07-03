//
//  ICityReadingChoicenessCollectionView.m
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityReadingChoicenessTableViewCell.h"
#import "ICityReadingChoicenessCellectionView.h"
#import "ICityLifeBannerModel.h"

@interface ICityReadingChoicenessTableViewCell()

@property (nonatomic, strong) ICityReadingChoicenessCellectionView *readCV;

@end

@implementation ICityReadingChoicenessTableViewCell

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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ICityReadingChoicenessCellectionView *readCV = [[ICityReadingChoicenessCellectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth - 40)*190.0/335.0+20)];
    self.readCV = readCV;
    __weak typeof(self) weakSelf = self;
    readCV.readingBlock = ^(ICityLifeBannerModel *model) {
        if (weakSelf.readingBlock) {
            weakSelf.readingBlock(model);
        }
    };
    
    [self.contentView addSubview:readCV];
    
}

- (void)setReadingChoicenessDataArray:(NSArray *)readingChoicenessDataArray {
    _readingChoicenessDataArray = readingChoicenessDataArray;
    
    self.readCV.readingChoicenessDataArray = readingChoicenessDataArray;
}



@end
