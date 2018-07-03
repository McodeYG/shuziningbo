//
//  JstyleNewsHomeTagChooseViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/1.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsHomeTagChooseViewController.h"
#import "ChannelView.h"

@interface JstyleNewsHomeTagChooseViewController ()

@property (nonatomic, strong) ChannelView *channelView;

@property (nonatomic, strong) NSMutableArray *myTitlesArray;

@property (nonatomic, strong) NSMutableArray *tjTitlesArray;

@property (nonatomic, strong) FMDatabase *database;

@property (nonatomic, strong) NSArray *cacheArray;

@end

@implementation JstyleNewsHomeTagChooseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = kWhiteColor;
    [self getCacheDictionary];
    [self setUpViews];
}

- (void)setUpViews
{
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"标签关闭"] forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:closeBtn];
    closeBtn.sd_layout
    .topSpaceToView(self.view, 36)
    .rightSpaceToView(self.view, 13)
    .widthIs(30)
    .heightIs(30);
    
    self.channelView = [[ChannelView alloc]initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H + 8, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - 8)];
    self.channelView.backgroundColor = [UIColor whiteColor];
    //
    self.channelView.upBtnDataArr = self.myTitlesArray;
    self.channelView.belowBtnDataArr = self.tjTitlesArray;
    //允许第一个按钮参与编辑
    self.channelView.IS_compileFirstBtn = NO;
    //设置按钮字体Font
    self.channelView.btnTextFont = 13.0f;
    //获取数据Block
    __weak typeof(self)weakSelf = self;
    self.channelView.dataBlock = ^(NSMutableArray *dataArr) {
        weakSelf.myChannelBlock(dataArr);
    };
    self.channelView.clickIndexBlock = ^(NSString *channelName) {
        weakSelf.myChannelClicked(channelName);
        [closeBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
    };
    [self.view addSubview:self.channelView];
}

- (void)closeBtnClicked:(UIButton *)sender
{
    if (self.channelView.compileBtn.selected) {
        ZTShowAlertMessage(@"请保存修改");
        return;
    }
    CATransition *animation = [CATransition animation];
    animation.duration = 0.6;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

/**取出缓存数据*/
- (void)getCacheDictionary
{
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"HomeChannels.sqlite"];
    self.database = [FMDatabase databaseWithPath:dbPath];
    [self.database open];
    FMResultSet * resultSet = [self.database executeQuery:@"select * from HomeChannels"];
    while ([resultSet next] == YES){
        NSData *data = [resultSet dataForColumn:@"homeChannelsData"];
        self.cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    [self.database close];
    
    if (!self.cacheArray.count) return;
    //获取总字典
    NSDictionary *dictionary = self.cacheArray[0];
    //
    NSDictionary *myChannelDict = [dictionary objectForKey:@"mychannel"];
    if ([myChannelDict[@"code"] integerValue] == 1) {
        [self.myTitlesArray addObject:@"关注"];
        for (NSDictionary *dict in [myChannelDict objectForKey:@"data"]) {
            [self.myTitlesArray addObject:[dict objectForKey:@"head_name"]];
        }
    }
    //
    NSDictionary *tjChannelDict = [dictionary objectForKey:@"tjchannel"];
    if ([tjChannelDict[@"code"] integerValue] == 1) {
        for (NSDictionary *dict in [tjChannelDict objectForKey:@"data"]) {
            [self.tjTitlesArray addObject:dict[@"head_name"]];
        }
    }
}

- (NSMutableArray *)myTitlesArray
{
    if (!_myTitlesArray) {
        _myTitlesArray = [NSMutableArray array];
    }
    return _myTitlesArray;
}

- (NSMutableArray *)tjTitlesArray
{
    if (!_tjTitlesArray) {
        _tjTitlesArray = [NSMutableArray array];
    }
    return _tjTitlesArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
