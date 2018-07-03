//
//  ICityLifeViewController.m
//  iCity
//
//  Created by 王磊 on 2018/4/22.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityLifeViewController.h"
#import "ICityLifeTableHeaderView.h"
#import "ICityLifeBannerModel.h"
#import "JstyleNewsActivityWebViewController.h"
#import "JstylePictureTextViewController.h"
#import "JstyleNewsArticleDetailViewController.h"
#import "JstyleNewsVideoDetailViewController.h"
#import "ICityLifeTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "WCQRCodeScanningVC.h"


static NSString *const ICityLifeTableViewCellID = @"ICityLifeTableViewCellID";

@interface ICityLifeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ICityLifeTableHeaderView *headerView;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) NSArray *collectionCatagroyArray;

@end

@implementation ICityLifeViewController

#pragma mark - Property

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - TabbarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kNightModeBackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [JstyleRefreshGiftHeader headerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
        
        [_tableView registerClass:[ICityLifeTableViewCell class] forCellReuseIdentifier:ICityLifeTableViewCellID];
    }
    return _tableView;
}

#pragma mark - ViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = kNightModeBackColor;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"生活服务";
    
    [self loadData];
    
    [self setupUI];
}

- (void)setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}



#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICityLifeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ICityLifeTableViewCellID forIndexPath:indexPath];
    cell.collcetionCatagroyArray = self.collectionCatagroyArray;
    __weak typeof(self) weakSelf = self;
    cell.lifeCollectionMenuBlock = ^(NSString *title, NSString *html) {
        JstyleNewsActivityWebViewController *webVC = [JstyleNewsActivityWebViewController new];
        webVC.urlString = html;
        webVC.navigationTitle = title;
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (147+108)*kScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 255;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ICityLifeTableHeaderView *headerView = [ICityLifeTableHeaderView new];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 147+108);
    headerView.bannerArray = [self.bannerArray mutableCopy];
    headerView.menuArray = self.menuArray;
    
    __weak typeof(self) weakSelf = self;
    headerView.bannerClickBlock = ^(NSInteger index) {
        ICityLifeBannerModel *model = weakSelf.bannerArray[index];
        switch ([model.banner_type integerValue]) {
            case 1:{
                if ([model.isImageArticle integerValue] == 1) {
                    //图集
                    JstylePictureTextViewController *jstyleNewsPictureTVC = [JstylePictureTextViewController new];
                    jstyleNewsPictureTVC.rid = model.rid;
                    [weakSelf.navigationController pushViewController:jstyleNewsPictureTVC animated:YES];
                }else{
                    //文章
                    JstyleNewsArticleDetailViewController *jstyleNewsArticleDVC = [JstyleNewsArticleDetailViewController new];
                    jstyleNewsArticleDVC.rid = model.rid;
                    
//                    jstyleNewsArticleDVC.titleModel = (JstyleNewsArticleDetailModel *)model;
                    JstyleNewsArticleDetailModel * titleModel = [JstyleNewsArticleDetailModel new];
                    titleModel.title = model.title;
                    titleModel.content = model.content;
                    titleModel.author_img = model.author_img;
                    titleModel.author_did = model.author_did;
                    titleModel.author_name = model.author_name;
                    //这个字段
                    titleModel.poster = model.article_poster;
                    
                    titleModel.ctime = model.ctime;
                    titleModel.cname = model.cname;
                    titleModel.isShowAuthor = model.isShowAuthor;
                    titleModel.TOrFOriginal = model.TOrFOriginal;
                    jstyleNewsArticleDVC.titleModel = titleModel;

                    [weakSelf.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
                    [weakSelf.navigationController pushViewController:jstyleNewsArticleDVC animated:YES];
                }
            }
                break;
            case 2:{
                //视频直播
                JstyleNewsVideoDetailViewController *jstyleNewsVideoDVC = [JstyleNewsVideoDetailViewController new];
                jstyleNewsVideoDVC.videoUrl = model.url_sd;
                jstyleNewsVideoDVC.videoTitle = model.title;
                jstyleNewsVideoDVC.vid = model.rid;
                jstyleNewsVideoDVC.videoType = model.videoType;
                [weakSelf.navigationController pushViewController:jstyleNewsVideoDVC animated:YES];
            }
                break;
            case 3:{
                //广告活动
                JstyleNewsActivityWebViewController *jstyleNewsActivityWVC = [JstyleNewsActivityWebViewController new];
                jstyleNewsActivityWVC.urlString = model.h5url;
                jstyleNewsActivityWVC.isShare = model.isShare.integerValue;
                [weakSelf.navigationController pushViewController:jstyleNewsActivityWVC animated:YES];
            }
                break;
            default:
                break;
        }
        
    };
    
    headerView.menuButtonClickBlock = ^(NSString *title, NSString *html) {
        
        if ([title containsString:@"扫码"]) {
            WCQRCodeScanningVC *scanningVC = [WCQRCodeScanningVC new];
            [weakSelf QRCodeScanVC:scanningVC];
        } else {
            JstyleNewsActivityWebViewController *webView = [JstyleNewsActivityWebViewController new];
            webView.navigationTitle = title;
            webView.urlString = html;
            [weakSelf.navigationController pushViewController:webView animated:YES];
        }
    };
    
    return headerView;
}

#pragma mark - LoadData

- (void)loadData {
    
    [self loadBannerData];
    [self loadBannerMenuData];
    [self loadCollectionCatagroyData];
}

- (void)loadBannerData {
    
    NSDictionary *parameters = @{@"bcolumn":@"11"};
    [[JstyleNewsNetworkManager shareManager] GETURL:BANNER_LIST_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.bannerArray = [[NSArray modelArrayWithClass:[ICityLifeBannerModel class] json:responseObject[@"data"]] mutableCopy];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadBannerMenuData {
    
    NSDictionary *parameters = @{
                                 @"tag":@"1"
                                 };
    
    [[JstyleNewsNetworkManager shareManager] GETURL:Life_CateList_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.menuArray = [NSArray modelArrayWithClass:[ICityLifeMenuModel class] json:responseObject[@"data"]];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)loadCollectionCatagroyData {
    NSDictionary *parameters = @{
                                 @"tag":@"2"
                                 };
    
    [[JstyleNewsNetworkManager shareManager] GETURL:Life_CateList_URL parameters:parameters success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.collectionCatagroyArray = [NSArray modelArrayWithClass:[ICityLifeMenuModel class] json:responseObject[@"data"]];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [ThemeTool isWhiteModel]?UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
}

#pragma mark - QRCode

- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.navigationController pushViewController:scanVC animated:YES];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self.navigationController pushViewController:scanVC animated:YES];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
