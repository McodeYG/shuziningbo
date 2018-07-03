//
//  ICityTVMenuViewController.m
//  iCity
//
//  Created by mayonggang on 2018/6/21.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityTVMenuViewController.h"
#import "ZJScrollPageView.h"
#import "TVListTableViewController.h"
#import "ICityTVModel.h"

@interface ICityTVMenuViewController ()<ZJScrollPageViewDelegate>

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

/**数据源---存储模型*/
@property (nonatomic, strong) NSMutableArray * tvMenusArray;
/**titles---存储title*/
@property (nonatomic, strong) NSMutableArray * titlesArray;

@end

@implementation ICityTVMenuViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSDictionary *navbarTitleTextAttributes = @{
                                                NSForegroundColorAttributeName:kNightModeTitleColor,
                                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                };
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    //导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self setupUI];
}

- (void)setupUI {
    
    self.title = @"电视台";
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //显示遮盖
    style.showCover = NO;
    style.showLine = YES;
    style.scrollLineColor = ISNightMode?kDarkFiveColor:kDarkTwoColor;
    style.adjustCoverOrLineWidth = YES;
    style.segmentViewBounces = NO;
    style.normalTitleColor = kDarkSixColor;
    style.selectedTitleColor = kDarkTwoColor;
    style.titleFont = JSFontWithWeight(17, UIFontWeightRegular);
    style.selectedTitleFont = JSFontWithWeight(17, UIFontWeightMedium);
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.segmentHeight = 37;
    style.autoAdjustTitlesWidth = YES;
    
    // 初始化
    CGRect scrollPageViewFrame = CGRectMake(0, 0, kScreenWidth, SCREEN_H-YG_StatusAndNavightion_H-YG_SafeBottom_H);
    
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:scrollPageViewFrame segmentStyle:style titles:@[@""] parentViewController:self delegate:self];
    self.scrollPageView = scrollPageView;
    scrollPageView.backgroundColor = kWhiteColor;
    [self.view addSubview:scrollPageView];
    
    
    self.view.backgroundColor = kNightModeBackColor;
//    self.scrollPageView.backgroundColor = kNightModeBackColor;
    
}

- (NSInteger)numberOfChildViewControllers {
    return self.tvMenusArray.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    
    TVListTableViewController *listVC = [[TVListTableViewController alloc] init];
    ICityTVModel * model = self.tvMenusArray[index];
    listVC.sendId = model.sendId;
    
    [self addChildViewController:listVC];
   
    return listVC;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


-(NSMutableArray *)tvMenusArray {
    if (!_tvMenusArray) {
        _tvMenusArray = [NSMutableArray array];
    }
    return _tvMenusArray;
}
-(NSMutableArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}

- (void)loadData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GETURL:Culture_TV_Menu_URL parameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [self.tvMenusArray removeAllObjects];
            [self.titlesArray removeAllObjects];
            //模型
            NSArray * data = [NSArray modelArrayWithClass:[ICityTVModel class] json:responseObject[@"data"]];
            [self.tvMenusArray addObjectsFromArray:data];
            //标题
            for (ICityTVModel * model in self.tvMenusArray) {
                [self.titlesArray addObject:model.name];
            }
        }
        
        if (self.titlesArray.count) {
            [self.scrollPageView reloadWithNewTitles:self.titlesArray];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}


@end
