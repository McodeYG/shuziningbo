//
//  JMAboutJingMeiViewController.m
//  Exquisite
//
//  Created by 数字宁波 on 16/5/5.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMAboutJingMeiViewController.h"

@interface JMAboutJingMeiViewController ()

@end

@implementation JMAboutJingMeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNightModeBackColor] forBarMetrics:(UIBarMetricsDefault)];
}


- (void)setupUI {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
  

    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:ISNightMode?JSImage(@"about_us_black.png"):JSImage(@"about_us_white.png")];
    CGRect frame = backImageView.frame;
    
    backImageView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_W/frame.size.width*frame.size.height);
    
    scrollView.contentSize = CGSizeMake(SCREEN_W, backImageView.frame.size.height);
    [scrollView addSubview:backImageView];
    

   
    
//    UILabel *titleLabel = [UILabel labelWithColor:kDarkThreeColor fontSize:20 text:@"关于数字跃动"];
//    titleLabel.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
//    titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
//    [titleLabel sizeToFit];
//    [scrollView addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(33);
//        make.top.offset(33);
//        make.width.offset(titleLabel.width);
//    }];
    
//    UIView *blackLine = [[UIView alloc] init];
//    blackLine.backgroundColor = kDarkThreeColor;
//    [scrollView addSubview:blackLine];
//    [blackLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(titleLabel).offset(-4);
//        make.top.equalTo(titleLabel.mas_bottom).offset(19);
//        make.width.offset(33);
//        make.height.offset(13);
//    }];
    
   
    /*
    UILabel *summaryLabel = [[UILabel alloc] init];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [paragraphStyle setParagraphSpacing:12];

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"北京数字跃动科技有限公司是中国领先的数字文化城市运营商。官网地址为: www.ABA.com.cn。\
                                            \
                                            公司集合阅读服务、文化服务和生活服务于 一体，并基于大数据的综合整合，获得政府认可，赋能城市文化升级，形成一流的线上和线下综合文化服务。依托庞大的版 权知识库及相应软硬件场景服务经验、媒介和品牌活动资源，为中国广大城市机构提供优秀的阅读+场景体验和管理创新赋 能。提供三终端四平台的产品生态体系服务。我们的使命是构 建突出文化个性的数字城市，以全民阅读为入口，让阅读连接 城市的一切。\
                                            数字文化城市由政府，产业，资本联合创立，拥有三大产品序列，赋能城市合伙人数字化管理，使用和传播:\
                                            \
                                            其一是核心产品“iCity 大数据服务平台”，底层核心技术包括 AI 内容推荐、BI 大数据分析、区块链技术等先进科技的 iCity 大数据平台和城市文化建设管理平台。\
                                            \
                                            其二是为各个城市打造的城市智能手机客户端。为城市主流媒体、文化服务、知识服务、政府服务、生活服务提供综合个性化的服务。\
                                            \
                                            第三是以“数字书刊亭”为代表的智能大屏产品系列，包括面向职 工、学校、科普、普法、文明、图书馆、农家书屋、营业厅、 户外等九大场景应用。\
                                            \
                                            公司已经连续三年发布中国城市阅读排行，2017 年在博鳌成功举办中国全民阅读论坛。目前已经落地国家电网、联通营业 厅、各大高校、宁波等优质城市和机构合作伙伴。\n\n"
                                                                           attributes:@{
                                                                                        NSKernAttributeName:@(1),
                                                                                        NSForegroundColorAttributeName:kDarkThreeColor,
                                                                                        NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:18],
                                                                                        NSParagraphStyleAttributeName:paragraphStyle
                                                                                        }];
    summaryLabel.attributedText = attributedString;
    summaryLabel.textColor = ISNightMode?kDarkNineColor:kDarkThreeColor;
    summaryLabel.numberOfLines = 0;
    [summaryLabel sizeToFit];
    [scrollView addSubview:summaryLabel];
    [summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
//        make.right.offset(-33);
        make.top.equalTo(titleLabel.mas_bottom).offset(25);
        make.width.offset(kScreenWidth-66);
//        make.height.offset(summaryLabel.height);
        make.bottom.offset(0);
    }];
     
     */
    
//    UILabel *copyrightLabel = [UILabel labelWithColor:JSColor(@"#919191") fontSize:10 text:@"Copyright @2017-2018\n精美（北京）科技有限公司" alignment:NSTextAlignmentCenter];
//    copyrightLabel.numberOfLines = 0;
//    [copyrightLabel sizeToFit];
//    [self.view addSubview:copyrightLabel];
//    [copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.offset(0);
//        make.bottom.offset(-20);
//    }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

@end
