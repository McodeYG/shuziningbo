//
//  AboutSearchCollectionViewCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "AboutSearchCollectionViewCell.h"


@interface AboutSearchCollectionViewCell ()

/**文字*/
@property (nonatomic, strong) UILabel * textLab;

@end


@implementation AboutSearchCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {  
    //
    self.textLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 11, SCREEN_W/2-20, 19)];
    self.textLab.textColor = kNightModeTextColor;
    self.textLab.textAlignment = NSTextAlignmentLeft;
    self.textLab.font = JSFont(15);
    [self.contentView addSubview:self.textLab];
    
    self.backgroundColor = kNightModeBackColor;
    
//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_W/2, 1)];
//    lineView.backgroundColor = kNightModeLineColor;
//    [self.contentView addSubview:lineView];
    
//    UIView * slineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_W/2, 1)];
//    slineView.backgroundColor = kNightModeLineColor;
//    [self.contentView addSubview:slineView];
}


-(void)setModel:(SearchAboutPersonModel *)model {
    
    self.textLab.text = model.name;
    
}


@end
