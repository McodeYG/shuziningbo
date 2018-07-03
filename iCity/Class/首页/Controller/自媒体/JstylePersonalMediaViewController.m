//
//  JstylePersonalMediaHomeViewController.m
//  Exquisite
//
//  Created by 赵涛 on 2017/8/4.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstylePersonalMediaViewController.h"
#import "JstyleMediaPersonalTableViewCell.h"
#import "JstyleMediaPersonalSquareHoldViewCell.h"
#import "JstyleNewsJMNumDetailsViewController.h"
#import "chinesePinYin.h"

@interface JstylePersonalMediaViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *collectionArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@property(nonatomic,strong)NSMutableArray *starsString;
@property(nonatomic,strong)NSMutableDictionary *starsDict;
// 顶部数组
@property (nonatomic, strong) UILabel *sectionTitleView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JstylePersonalMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"知识库";
    self.view.backgroundColor = kWhiteColor;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self addTableView];
    [self addReshAction];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addTableView
{
    self.sectionTitleView = ({
        UILabel *sectionTitleView = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 95, 300/375.0*kScreenWidth,44,44)];
        sectionTitleView.textAlignment = NSTextAlignmentCenter;
        sectionTitleView.font = [UIFont boldSystemFontOfSize:14];
        sectionTitleView.textColor = [UIColor whiteColor];
        sectionTitleView.backgroundColor = kDarkNineColor;
        sectionTitleView;
    });
    [self.navigationController.view addSubview:self.sectionTitleView];
    self.sectionTitleView.hidden = YES;
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - YG_SafeBottom_H) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerNib:[UINib nibWithNibName:@"JstyleMediaPersonalTableViewCell" bundle:nil] forCellReuseIdentifier:@"JstyleMediaPersonalTableViewCell"];
    _tableView.sectionIndexColor = kDarkNineColor;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (void)addReshAction
{
    self.tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        [self.collectionArray removeAllObjects];
        [self.starsString removeAllObjects];
        self.starsDict = nil;
        [self.letterResultArr removeAllObjects];
        [self getPersonalMediaListDataSource];
    }];
}

#pragma mark - UItableViewDelegate --- UItableViewDataSource
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else{
        NSString *key = [self.indexArray objectAtIndex:section];
        return key;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [[self.letterResultArr objectAtIndex:section] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.01;
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *ID = @"JstyleMediaPersonalSquareHoldViewCell";
        JstyleMediaPersonalSquareHoldViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[JstyleMediaPersonalSquareHoldViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        [cell.collectionView reloadDataWithDataArray:self.collectionArray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *ID = @"JstyleMediaPersonalTableViewCell";
        JstyleMediaPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[JstyleMediaPersonalTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        if (self.letterResultArr.count) {
            NSString *name = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            cell.model = self.starsDict[name];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
    [self showSectionTitle:title];
    return index;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else{
        JstyleNewsBaseTitleLabel *title = [JstyleNewsBaseTitleLabel new];
        title.backgroundColor = ISNightMode?kDarkThreeColor:JSColor(@"#f5f5f5");
        title.text = [NSString stringWithFormat:@"    %@", [self.indexArray objectAtIndex:section]];
        title.font = JSFontWithWeight(12, UIFontWeightHeavy);
        return title;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return 440;
    return 102 *kScreenWidth/375.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        NSString *name = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
        JstylePersonalMediaListModel *model = self.starsDict[name];
        JstyleNewsJMNumDetailsViewController *jstyleNewsJmNumsDVC = [JstyleNewsJMNumDetailsViewController new];
        jstyleNewsJmNumsDVC.did = model.did;
        [self.navigationController pushViewController:jstyleNewsJmNumsDVC animated:YES];
    }
}

#pragma mark - private
- (void)timerHandler:(NSTimer *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            self.sectionTitleView.alpha = 0;
        } completion:^(BOOL finished) {
            self.sectionTitleView.hidden = YES;
        }];
    });
}

-(void)showSectionTitle:(NSString*)title{
    [self.sectionTitleView setText:title];
    self.sectionTitleView.hidden = NO;
    self.sectionTitleView.alpha = 1;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**获取iCity号数据*/
- (void)getPersonalMediaListDataSource
{
    NSDictionary *parameters = @{@"platform_type":@"2"};
    [[JstyleNewsNetworkManager shareManager] GETURL:MANAGER_MORELIST_URL parameters:parameters progress:nil success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] != 1) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        //总数组
        for (NSDictionary *dict in responseObject[@"data"]) {
            JstylePersonalMediaListModel *model = [JstylePersonalMediaListModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        //顶部数组
        if (self.dataArray.count > 3 && !self.collectionArray.count) {
            for (int i = 0; i < 4; i ++) {
                JstylePersonalMediaListModel *model = self.dataArray[i];
                [self.collectionArray addObject:model];
            }
        }
        //剩余数组
        [self.dataArray removeObjectsInArray:self.collectionArray];
        for (JstylePersonalMediaListModel *model in self.dataArray) {
            [self.starsString addObject:model.pen_name];
            NSString *name = [model.pen_name stringByReplacingOccurrencesOfString:@" " withString:@""];
            [self.starsDict setObject:model forKey:name];
        }
        
        self.indexArray = [chinesePinYin IndexArray:_starsString];
        self.letterResultArr = [chinesePinYin LetterSortArray:_starsString];
        if (self.indexArray.count && self.letterResultArr.count) {
            NSString *string = self.indexArray[0];
            if ([string containsString:@"#"]) {
                [self.indexArray removeObject:string];
                [self.indexArray addObject:string];
                NSArray *array = self.letterResultArr[0];
                [self.letterResultArr removeObjectAtIndex:0];
                [self.letterResultArr addObject:array];
            }
        }
        
        [self.indexArray insertObject:@"热" atIndex:0];
        [self.letterResultArr insertObject:@[] atIndex:0];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSMutableArray *)collectionArray
{
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)indexArray
{
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (NSMutableArray *)letterResultArr
{
    if (!_letterResultArr) {
        _letterResultArr = [NSMutableArray array];
    }
    return _letterResultArr;
}

- (NSMutableArray *)starsString
{
    if (!_starsString) {
        _starsString = [NSMutableArray array];
    }
    return _starsString;
}

- (NSMutableDictionary *)starsDict
{
    if (!_starsDict) {
        _starsDict = [NSMutableDictionary dictionary];
    }
    return _starsDict;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

