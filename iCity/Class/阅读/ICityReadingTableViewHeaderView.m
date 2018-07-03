//
//  ICityReadingTableViewHeaderView.m
//  iCity
//
//  Created by 王磊 on 2018/4/27.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityReadingTableViewHeaderView.h"

@interface ICityReadingTableViewHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ICityReadingTableViewHeaderView

- (instancetype)initWithTitleName:(NSString *)titleName showMoreBtn:(BOOL)showMoreBtn{
    if (self = [super init]) {
        [self setupUIWithTitleName:titleName showMoreBtn:showMoreBtn];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    }
    return self;
}

- (void)setupUIWithTitleName:(NSString *)titleName showMoreBtn:(BOOL)showMoreBtn{
    
    
    self.line = [[UIView alloc] init];
    [self addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.offset(0);
        make.height.offset(0.5);
    }];
    
    UILabel *titleLabel = [UILabel labelWithColor:kNightModeTextColor fontSize:18 text:titleName alignment:NSTextAlignmentLeft];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(10);
    }];
    
    if (showMoreBtn) {
        UIButton *moreBtn = [UIButton buttonWithTitle:@"更多" normalTextColor:JSColor(@"#9F7B30") selectedTextColor:JSColor(@"#9F7B30") titleFontSize:15 target:self action:@selector(moreBtnClick)];
        [moreBtn sizeToFit];
        [self addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.right.offset(-10);
        }];
    }
    
    [self applyTheme];
}

#pragma mark - Actions

- (void)moreBtnClick {
    if (self.moreBtnBlock) {
        self.moreBtnBlock();
    }
}

- (void)applyTheme {
    self.titleLabel.textColor = kNightModeTextColor;
    self.backgroundColor = kNightModeBackColor;
    self.line.backgroundColor = kNightModeLineColor;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
