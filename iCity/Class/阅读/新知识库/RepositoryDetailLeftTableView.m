//
//  RepositoryDetailLeftTableView.m
//  iCity
//
//  Created by mayonggang on 2018/6/22.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "RepositoryDetailLeftTableView.h"
#import "JstyleNewsJMAttentionLeftViewCell.h"
#import "JstyleNewsJMAttentionLeftCateModel.h"


@interface RepositoryDetailLeftTableView ()<UITableViewDelegate,UITableViewDataSource>

@end



@implementation RepositoryDetailLeftTableView


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
        [self registerClass:[JstyleNewsJMAttentionLeftViewCell class] forCellReuseIdentifier:@"JstyleNewsJMAttentionLeftViewCell"];
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
    static NSString *ID = @"JstyleNewsJMAttentionLeftViewCell";
    JstyleNewsJMAttentionLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstyleNewsJMAttentionLeftViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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

- (void)setSelectID:(NSString *)selectID {
    _selectID = selectID;
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JstyleNewsJMAttentionLeftCateModel *model = obj;
        if ([model.id isEqualToString:selectID]) {
            if (self.selectedIndex) {
                self.selectedIndex(model.id);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [self selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
                    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                        [self.delegate tableView:self didSelectRowAtIndexPath:indexpath];
                    }
                    [self scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                });
            }
        }
    }];
}



@end
