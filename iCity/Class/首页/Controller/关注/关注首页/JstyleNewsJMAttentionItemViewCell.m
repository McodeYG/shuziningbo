//
//  JstyleNewsJMAttentionItemViewCell.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/28.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionItemViewCell.h"

@implementation JstyleNewsJMAttentionItemViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.attentionMoreBtn addTarget:self action:@selector(attentionMoreBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.rankingListBtn addTarget:self action:@selector(rankingListBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.myAttentionBtn addTarget:self action:@selector(myAttentionBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self applyTheme];
}

- (void)attentionMoreBtnClicked:(UIButton *)sender
{
    if (self.attentionMoreBlock) {
        self.attentionMoreBlock();
    }
}

- (void)rankingListBtnClicked:(UIButton *)sender
{
    if (self.rankingListBlock) {
        self.rankingListBlock();
    }
}

- (void)myAttentionBtnClicked:(UIButton *)sender
{
    if (self.myAttentionBlock) {
        self.myAttentionBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)applyTheme {
    [super applyTheme];
    self.lineView.backgroundColor = kNightModeLineColor;
}

@end
