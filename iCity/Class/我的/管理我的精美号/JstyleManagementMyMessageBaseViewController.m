//
//  JstyleManagementMyMessageBaseViewController.m
//  Exquisite
//
//  Created by 赵涛 on 2017/10/12.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementMyMessageBaseViewController.h"
#import "JstyleManagementMyMessageViewController.h"
#import "NinaPagerView.h"
#import "TopTabView.h"

@interface JstyleManagementMyMessageBaseViewController ()<NinaPagerViewDelegate>

@property(strong, nonatomic) NinaPagerView *ninaPageView;

@end

@implementation JstyleManagementMyMessageBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    [self setUpViews];
}

- (void)setUpViews
{
    CGRect pagerRect = CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H);
    _ninaPageView = [[NinaPagerView alloc] initWithFrame:pagerRect WithTitles:@[@"审核消息",@"系统消息"] WithObjects:@[@"JstyleManagementMyMessageViewController",@"JstyleManagementMyMessageViewController"]];
    _ninaPageView.ninaPagerStyles = NinaPagerStyleBottomLine;
    _ninaPageView.titleFont = 13;
    _ninaPageView.titleScale = 1;
    _ninaPageView.underlineColor = [kWhiteColor colorWithAlphaComponent:0];
    _ninaPageView.ninaDefaultPage = 0;
    _ninaPageView.selectTitleColor = ISNightMode?kDarkFiveColor:kDarkTwoColor;
    _ninaPageView.unSelectTitleColor = ISNightMode?kDarkNineColor:kDarkFiveColor;
    _ninaPageView.topTabBackGroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    _ninaPageView.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
//    _ninaPageView.topTabViews = [self topTabViewArray];
//    _ninaPageView.selectedTopTabViews = [self changeTopArray];
    _ninaPageView.delegate = self;
    [self.view addSubview:_ninaPageView];
    
    UIView *singleLine = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 10 + YG_StatusAndNavightion_H, 0.5, 20)];
    singleLine.backgroundColor = [kLightLineColor colorWithAlphaComponent:0.5];
    [self.view addSubview:singleLine];
}

- (NSArray *)topTabViewArray {
    return @[
             [[TopTabView alloc] initWithLeftImageName:@"审核消息" WithRightTitle:@"审核消息" WithTitleColor:kDarkNineColor],
             [[TopTabView alloc] initWithLeftImageName:@"系统消息" WithRightTitle:@"系统消息" WithTitleColor:kDarkNineColor]
             ];
}

- (NSArray *)changeTopArray {
    return @[
             [[TopTabView alloc] initWithLeftImageName:@"审核消息1" WithRightTitle:@"审核消息" WithTitleColor:kDarkThreeColor],
             [[TopTabView alloc] initWithLeftImageName:@"系统消息2" WithRightTitle:@"系统消息" WithTitleColor:kDarkThreeColor]
             ];
}

- (void)ninaCurrentPageIndex:(NSInteger)currentPage currentObject:(id)currentObject lastObject:(id)lastObject
{
    JstyleManagementMyMessageViewController *jstyleManagerMyMessageVC = (JstyleManagementMyMessageViewController *)currentObject;
    jstyleManagerMyMessageVC.type = [NSString stringWithFormat:@"%ld",currentPage + 1];
}


@end
