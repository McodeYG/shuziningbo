//
//  JstyleNewsRankingListLeftTableView.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/24.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsRankingListLeftTableView.h"
#import "JstyleNewsRankingListLeftViewCell.h"

@interface JstyleNewsRankingListLeftTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation JstyleNewsRankingListLeftTableView

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[JstyleNewsRankingListLeftViewCell class] forCellReuseIdentifier:@"JstyleNewsRankingListLeftViewCell"];
    }
    return self;
}

- (void)reloadDataWithDataArray:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"JstyleNewsRankingListLeftViewCell";
    JstyleNewsRankingListLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstyleNewsRankingListLeftViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView scrollToNearestSelectedRowAtScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    if (indexPath.row < self.dataArray.count) {
        JstyleNewsJMAttentionLeftCateModel *model = self.dataArray[indexPath.row];
        if (self.selectedIndex) {
            self.selectedIndex(model.id);
        }
    }
}

@end
