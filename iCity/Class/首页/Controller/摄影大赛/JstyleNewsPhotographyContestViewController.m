//
//  JstyleNewsPhotographyContestViewController.m
//  JstyleNews
//
//  Created by 王磊 on 2018/3/21.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsPhotographyContestViewController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"
#import "LxGridViewFlowLayout.h"
#import "JstyleNewsPhotographyContestModel.h"
#import "JstyleNewsPhotographyContestCell.h"
#import "JstyleNewsPhotographyContestTextCell.h"
#import "JstyleNewsPhotographyContestProtocalTableViewCell.h"
#import "JstyleNewsProtocalViewController.h"
#import "JstyleNewsActivityWebViewController.h"
#import "JstyleNewsPhotographyContestCollectionViewCell.h"

#define kCollectionViewFrame CGRectMake(0, 0, kScreenWidth, (_selectedPhotos.count / 3 + (_selectedPhotos.count > 8 ? 0 : 1))* _itemWH + 4*(_selectedPhotos.count/3+2))

#define PhotographyURL @"http://app.jstyle.cn/jstyle_activity/"
#define UploadImagesURL     PhotographyURL @"admin/shoot/two/saveCompetition.htm"
#define GetThemeDataURL     PhotographyURL @"admin/shoot/two/findThemes.htm"
#define ActivityDetailURL   PhotographyURL @"admin/shoot/two/findOneCompetitions.htm"

@interface JstyleNewsPhotographyContestViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) NSArray<UIImage *> *uploadImagesArray;

@property (nonatomic, assign) CGRect activedTextFieldRect;

@property (nonatomic, assign) BOOL isAgreePhotographyProtocal;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *backToHomePageBtn;
@property (nonatomic, strong) NSArray *themeArray;

//作品名称
@property (nonatomic, copy) NSString *name;
//拍摄者姓名
@property (nonatomic, copy) NSString *contestant;
//已经选过主题的id
@property (nonatomic, assign) NSString *themeid;

@property (nonatomic, assign) BOOL isLastOneItem;
@property (nonatomic, assign) BOOL currentIsLastOneItem;

@end

static NSString *JstyleNewsPhotographyContestCellID = @"JstyleNewsPhotographyContestCellID";
static NSString *JstyleNewsPhotographyContestTextCellID = @"JstyleNewsPhotographyContestTextCellID";
static NSString *JstyleNewsPhotographyContestProtocalTableViewCellID = @"JstyleNewsPhotographyContestProtocalTableViewCellID";
static NSString *JstyleNewsPhotographyContestCollectionViewCellID = @"JstyleNewsPhotographyContestCollectionViewCellID";

@implementation JstyleNewsPhotographyContestViewController

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
        _layout = [[LxGridViewFlowLayout alloc] init];
        CGFloat itemH = kScreenWidth / 3.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(itemH, (178 - itemH)/2.0, itemH, 178) collectionViewLayout:_layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = kWhiteColor;
        _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[JstyleNewsPhotographyContestCollectionViewCell class] forCellWithReuseIdentifier:JstyleNewsPhotographyContestCollectionViewCellID];
    }
    return _collectionView;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, YG_StatusAndNavightion_H, kScreenWidth, kScreenHeight - YG_StatusAndNavightion_H - TabbarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = kWhiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.alwaysBounceVertical = YES;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        } else {
            _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - TabbarHeight);
        }
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[JstyleNewsPhotographyContestCell class] forCellReuseIdentifier:JstyleNewsPhotographyContestCellID];
        [_tableView registerClass:[JstyleNewsPhotographyContestTextCell class] forCellReuseIdentifier:JstyleNewsPhotographyContestTextCellID];
        [_tableView registerClass:[JstyleNewsPhotographyContestProtocalTableViewCell class] forCellReuseIdentifier:JstyleNewsPhotographyContestProtocalTableViewCellID];
    }
    return _tableView;
}



- (UIButton *)confirmBtn {
    if (_confirmBtn == nil) {
        _confirmBtn = [self confirmButtonWithTitle:@"确认"];
        [_confirmBtn setTitleColor:kDarkTwoColor forState:UIControlStateDisabled];
        [_confirmBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forState:UIControlStateDisabled];
        [_confirmBtn setBackgroundImage:[UIImage imageWithColor:JSColor(@"#40DAD6")] forState:UIControlStateNormal];
        _confirmBtn.enabled = NO;
    }
    return _confirmBtn;
}

- (UIButton *)backToHomePageBtn {
    if (_backToHomePageBtn == nil) {
        _backToHomePageBtn = [self confirmButtonWithTitle:@"回到首页"];
        [_backToHomePageBtn setTitleColor:kDarkTwoColor forState:UIControlStateNormal];
        [_backToHomePageBtn setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forState:UIControlStateNormal];
        _backToHomePageBtn.layer.borderColor = [UIColor colorWithRGB:0x999999 alpha:0.5].CGColor;
    }
    return _backToHomePageBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    [self getThemeOptionData];
    
    self.navigationItem.title = @"上传作品";
    self.view.backgroundColor = kWhiteColor;
    
    
    self.isAgreePhotographyProtocal = YES;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self canUploadImages];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _margin = 4;
    _itemWH = (self.view.width - 2 * _margin - 4) / 3 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    [self.collectionView setCollectionViewLayout:_layout];
    CGFloat itemH = kScreenWidth / 3.0;
    self.collectionView.frame = CGRectMake(itemH, (178 - itemH)/2.0, itemH, 178);
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = kWhiteColor;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(51 + (IS_iPhoneX?34:0));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = JSColor(@"#EEEEEE");
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(0.5);
    }];
    
    [bottomView addSubview:self.backToHomePageBtn];
    [self.backToHomePageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0 - (IS_iPhoneX?17:0));
        make.width.offset((kScreenWidth - 15*3)/2.0);
        make.height.offset(36);
    }];
    
    [bottomView addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0 - (IS_iPhoneX?17:0));
        make.width.height.equalTo(self.backToHomePageBtn);
    }];
}


- (UIButton *)confirmButtonWithTitle:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
    button.layer.cornerRadius = 18.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 0.5;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)buttonClick:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"回到首页"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([self canUploadImages]) {
            [self startUpload];
        }
    }
}

///判定确认上传按钮是否可点击
- (BOOL)canUploadImages {
    
    
    /*至少选中一张图片,作品名称,拍摄者名称,选择主题(如果有主题),已勾选协议*/
    if (_selectedPhotos.count >= 1 && self.isAgreePhotographyProtocal && (![self.name isEqualToString:@""] && self.name != nil) && (![self.contestant isEqualToString:@""] && self.contestant != nil)) {
        if (self.themeArray == nil) {//主题未获取到
            ZTShowAlertMessage(@"主题信息未获取成功,请退出重试");
            return NO;
        } else { //主题获取成功
            if (self.themeArray.count <= 1) { //默认主题
                self.confirmBtn.layer.borderColor = JSColor(@"#40DAD6").CGColor;
                self.confirmBtn.enabled = YES;
                return YES;
            } else { //选择主题
                if (self.themeid != nil && ![self.themeid isEqualToString:@""]) {//选择了
                    self.confirmBtn.layer.borderColor = JSColor(@"#40DAD6").CGColor;
                    self.confirmBtn.enabled = YES;
                    return YES;
                } else { //未选择
                    self.confirmBtn.layer.borderColor = [UIColor colorWithRGB:0x999999 alpha:0.5].CGColor;
                    self.confirmBtn.enabled = NO;
                    return NO;
                }
            }
        }
    } else {
        self.confirmBtn.layer.borderColor = [UIColor colorWithRGB:0x999999 alpha:0.5].CGColor;
        self.confirmBtn.enabled = NO;
        return NO;
    }
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0 ? 1 : 4);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        JstyleNewsPhotographyContestCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsPhotographyContestCellID forIndexPath:indexPath];
        if (cell.contentView.subviews.count == 0) {
            [cell.contentView addSubview:self.collectionView];
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
            {
                JstyleNewsPhotographyContestTextCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsPhotographyContestTextCellID forIndexPath:indexPath];
                cell.titleName = @"作品名称";
                cell.textField.delegate = self;
                cell.textField.tag = JstyleNewsPhotographyContestTextfieldTypePhotoName;
                cell.textField.placeholder = @"请输入作品名称";
                return cell;
            }
                break;
            case 1:
            {
                JstyleNewsPhotographyContestTextCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsPhotographyContestTextCellID forIndexPath:indexPath];
                cell.titleName = @"拍摄者姓名";
                cell.textField.placeholder = @"请输入拍摄者姓名";
                cell.textField.delegate = self;
                cell.textField.tag = JstyleNewsPhotographyContestTextfieldTypeContestantName;
                return cell;
            }
                break;
            case 2:
            {
                if (self.themeArray.count < 2) {
                    return [UITableViewCell new];
                } else {
                    JstyleNewsPhotographyContestTextCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsPhotographyContestTextCellID forIndexPath:indexPath];
                    cell.titleName = @"选择主题";
                    cell.themeArray = self.themeArray;
                    
                    __weak typeof(self)weakSelf = self;
                    cell.themeBtnBlock = ^(JstyleNewsThemeButton *themeBtn) {
                        themeBtn.selected = !themeBtn.selected;
                        weakSelf.themeid = themeBtn.themeid;
                        [weakSelf canUploadImages];
                    };
                    return cell;
                }
            }
                break;
            case 3:
            {
                JstyleNewsPhotographyContestProtocalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsPhotographyContestProtocalTableViewCellID forIndexPath:indexPath];
                __weak typeof(self)weakSelf = self;
                cell.agreeBtnBlock = ^(UIButton *button) {
                    button.selected = !button.selected;
                    weakSelf.isAgreePhotographyProtocal = button.isSelected;
                    [weakSelf canUploadImages];
                };
                
                cell.tapProtocalBlock = ^{
                    JstyleNewsProtocalViewController *protocalVC = [JstyleNewsProtocalViewController new];
                    protocalVC.url = @"http://app.jstyle.cn/newwap/index.php/home/Active/photo_agreement";
                    protocalVC.isModal = YES;
                    [weakSelf presentViewController:protocalVC animated:YES completion:nil];
                };
                
                return cell;
            }
                break;
            default:
                break;
        }
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return self.collectionView.height - (_selectedPhotos.count > 8 ? 4 : 0);//选择器行高
    } else {
        //动态隐藏"选择主题"行
        if (indexPath.section == 1 && indexPath.row == 2) {
            return self.themeArray.count > 1 ? 60 : 0;
        } else {
            return 60;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 10 : 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        view.backgroundColor = JSColor(@"F5F5F5");
        return view;
    } else {
        return [UIView new];
    }
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JstyleNewsPhotographyContestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JstyleNewsPhotographyContestCollectionViewCellID forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        [self pushTZImagePickerController];
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = 9;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingMultipleVideo = NO;
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _isSelectOriginalPhoto = isSelectOriginalPhoto;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        weakSelf.uploadImagesArray = photos;
        weakSelf.collectionView.frame = kCollectionViewFrame;
        [weakSelf.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        // 允许裁剪,去裁剪
                        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                            [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                        }];
                        imagePicker.needCircleCrop = NO;
                        imagePicker.circleCropRadius = 100;
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}

#pragma mark - 开始上传
- (void)startUpload {
    
    [SVProgressHUD showWithStatus:@"正在上传"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self uploadImagesArrayWithImagesArray:self.uploadImagesArray];
}

#pragma mark - 上传多张图片
- (void)uploadImagesArrayWithImagesArray:(NSArray<UIImage *> *)images {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    manager.requestSerializer.timeoutInterval = 60;
    NSDictionary *paramater = @{
                                @"operUid":[[JstyleToolManager sharedManager] getUserId],
                                @"name":(self.name == nil ? @"" : self.name),//作品名
                                @"contestant":(self.contestant == nil ? @"" : self.contestant),//作者名
                                @"themeId":(self.themeid == nil ? ([self.themeArray.firstObject id] == nil ? @"" : [self.themeArray.firstObject id]) : self.themeid),//主题id
                                @"shootTwoId":(self.shootTwoId == nil ? @"" : self.shootTwoId),
                                @"origin":@"iOS"
                                };
    [manager UPLoadFormdataWithURL:UploadImagesURL parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //拼接表单数据
        for (NSInteger i = 0; i < images.count; i++) {
            UIImage *image = images[i];
            NSData *imageData = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"shootImgs"] fileName:[NSString stringWithFormat:@"image_%zd.png",i] mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%lld",uploadProgress.completedUnitCount);
        
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"正在上传"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //跳转详情页
                NSString *shootTwoCompetition = responseObject[@"data"][@"id"];
                JstyleNewsActivityWebViewController *activityDetailVC = [JstyleNewsActivityWebViewController new];
                NSString *uploadSuccessURL = [ActivityDetailURL stringByAppendingString:[NSString stringWithFormat:@"?id=%@",shootTwoCompetition]];
                NSString *operUidURL = [uploadSuccessURL stringByAppendingString:[NSString stringWithFormat:@"&operUid=%@",[[JstyleToolManager sharedManager] getUserId]]];
                activityDetailVC.urlString = operUidURL;
                activityDetailVC.isNeedPopToFirstVC = YES;
                [self.navigationController pushViewController:activityDetailVC animated:YES];
            });
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
        [SVProgressHUD dismissWithDelay:1.0];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络错误,请重试"];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
    
}

- (void)getThemeOptionData {
    
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    NSDictionary *paramaters = @{
                                 @"shootTwoId":(self.shootTwoId == nil ? @"" : self.shootTwoId)
                                 };
    
    [manager POSTURL:GetThemeDataURL parameters:paramaters success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"1"]) {
            self.themeArray = [NSArray modelArrayWithClass:[JstyleNewsPhotographyContestThemeModel class] json:responseObject[@"data"]];
            if (self.themeArray.count > 1) {
                [self.tableView reloadRow:2 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activedTextFieldRect = [textField convertRect:textField.frame toView:self.tableView];
    if (textField.tag == JstyleNewsPhotographyContestTextfieldTypePhotoName) {
        self.name = textField.text;
    } else {
        self.contestant = textField.text;
    }
    [self canUploadImages];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == JstyleNewsPhotographyContestTextfieldTypePhotoName) {
        self.name = textField.text;
    } else {
        self.contestant = textField.text;
    }
    [self canUploadImages];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == JstyleNewsPhotographyContestTextfieldTypePhotoName) {
        self.name = textField.text;
    } else {
        self.contestant = textField.text;
    }
    [self canUploadImages];
    [self.tableView endEditing:YES];
    return YES;
}

- (void)keyBoardWillShowWithNotification:(NSNotification *)notification {
    
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if ((self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height) >  ([UIScreen mainScreen].bounds.size.height - rect.size.height)) {
        [UIView animateWithDuration:duration animations:^{
            self.tableView.contentOffset = CGPointMake(0, 64 + self.activedTextFieldRect.origin.y + self.activedTextFieldRect.size.height - ([UIScreen mainScreen].bounds.size.height - rect.size.height));
        }];
    }
}

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
    
    self.collectionView.frame = kCollectionViewFrame;
    [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        // NSLog(@"图片名字:%@",fileName);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@,delloc",self);
}

@end
