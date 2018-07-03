//
//  JstyleNewsJMAttentionRightTableView.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsJMAttentionRightTableView.h"
#import "JstyleNewsJMAttentionRightViewCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"

@interface JstyleNewsJMAttentionRightTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation JstyleNewsJMAttentionRightTableView

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kNightModeBackColor;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"JstyleNewsJMAttentionRightViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleNewsJMAttentionRightViewCell"];
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
    static NSString *ID = @"JstyleNewsJMAttentionRightViewCell";
    JstyleNewsJMAttentionRightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JstyleNewsJMAttentionRightViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    __weak typeof(self)weakSelf = self;
    [cell setFocusBlock:^(NSString *did) {
        [weakSelf addJstyleNewsJmNumsFocusOnWithDid:did indexPath:indexPath];
    }];
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchModel *model = self.dataArray[indexPath.row];
    JstyleNewsJMNumDetailsViewController *jstylePersonalMediaVC = [JstyleNewsJMNumDetailsViewController new];
    jstylePersonalMediaVC.did = model.did;
    [self.viewController.navigationController pushViewController:jstylePersonalMediaVC animated:YES];
}

///关注iCity号
- (void)addJstyleNewsJmNumsFocusOnWithDid:(NSString *)did indexPath:(NSIndexPath *)indexPath
{
    
    if ([[JstyleToolManager sharedManager] isTourist]) {
        [[JstyleToolManager sharedManager] loginInViewController];
        return;
    }
    
    NSDictionary *parameters = @{@"platform_type":@"2",
                                 @"did":did,
                                 @"uid":[[JstyleToolManager sharedManager] getUserId],
                                 };
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_SUBSCRIPTION_URL parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            NSString *followType = responseObject[@"data"][@"follow_type"];
            SearchModel *model = self.dataArray[indexPath.row];
            model.isFollow = followType;
            [self reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollDidScrollBlock) {
        self.scrollDidScrollBlock();
    }
}

@end
