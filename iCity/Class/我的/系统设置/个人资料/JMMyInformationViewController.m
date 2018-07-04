//
//  JMMyInformationViewController.m
//  Exquisite
//
//  Created by 赵涛 on 16/5/5.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "JMMyInformationViewController.h"
#import "JMMyInformationViewCell.h"
#import "JMChangeNickNameViewController.h"
#import "JstyleNewsImagePickerViewController.h"

@interface JMMyInformationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,NTESActionSheetDelegate>

/**遮罩层*/
@property (nonatomic, strong) UIView *genderMaskView;
@property (nonatomic, strong) UIView *birsdayMaskView;
/***/
@property (nonatomic, strong) JstyleNewsBaseTableView *tableView;
/**头像*/
@property (nonatomic, strong) UIImageView *headerImageView;
/**列表选项名称数组*/
@property (nonatomic, strong) NSArray *titleArray;
/**性别数组*/
@property (nonatomic, strong) NSArray *genderArray;
/**获取的出生日期*/
@property (nonatomic, strong) NSDate *birsdayDate;
/**获取到的性别信息*/
@property (nonatomic, copy) NSString *genderStr;
/**获取到的生日信息*/
@property (nonatomic, copy) NSString *birthdayStr;
/**个人信息的字典*/
@property (nonatomic, strong) NSDictionary *inforDict;
/**上传头像的base64字符串*/
@property (nonatomic, copy) NSString *iconBase64Str;

@end

@implementation JMMyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[JstyleNewsBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStyleGrouped)];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerNib:[UINib nibWithNibName:@"JMMyInformationViewCell" bundle:nil] forCellReuseIdentifier:@"JMMyInformationViewCell"];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    
    self.titleArray = @[@"头像",@"昵称",@"性别",@"出生日期"];
    
    self.genderArray = @[@"男",@"女"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getJMMyInformationDataSource];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JSTYLENEWSGETUSERINFONOTIFICATION" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"JMMyInformationViewCell";
    JMMyInformationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JMMyInformationViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (indexPath.row < _titleArray.count) {
        cell.titleName.text = _titleArray[indexPath.row];
    }
    
    switch (indexPath.row) {
        case 0:{
            _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 75, 8, 38, 38)];
            _headerImageView.layer.cornerRadius = 19;
            _headerImageView.layer.masksToBounds = YES;
            if ([self.inforDict[@"avator"] isEqualToString:@""]) {
                _headerImageView.image = SZ_Place_Header;
            }
            [_headerImageView setImageWithURL:[NSURL URLWithString:self.inforDict[@"avator"]] placeholder:SZ_Place_Header options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
            _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
            [cell addSubview:_headerImageView];
        }
            break;
        case 1:{
            NSString * str = [NSString stringWithFormat:@"%@",self.inforDict[@"nick_name"]];
            cell.nameLabel.text = [self nameLabelString:str];
        }
            break;
        case 2:{
            NSString * str = [NSString stringWithFormat:@"%@",self.inforDict[@"sex"]];
            cell.nameLabel.text = [self nameLabelString:str];
        }
            break;
        case 3:{
            
            NSString * str = [NSString stringWithFormat:@"%@",self.inforDict[@"birth"]];
            cell.nameLabel.text = [self nameLabelString:str];
        }
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString *)nameLabelString:(NSString *)string {
    
    if ([string isNotBlank]) {
        if ([string isEqualToString:@"(null)"]) {
            return @"";
        }else {
            return string;
        }
    }else {
        return @" ";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[JstyleToolManager sharedManager] isTourist]) {
//        [[JstyleToolManager sharedManager] loginInViewController];
//        return;
//    }
    switch (indexPath.row) {
        case 0:{
            NTESActionSheet *actionSheet = [[NTESActionSheet alloc]initWithTitle:@"选择相册或者相机" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册选择"]];
            [actionSheet showInView:self.view];
        }
            break;
        case 1:{
            JMChangeNickNameViewController *jmChangeNickNameVC = [JMChangeNickNameViewController new];
//            jmChangeNickNameVC.nickBlock = ^(NSString *str){
//                JMMyInformationViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                cell.nameLabel.text = str;
//            };
            [self.navigationController pushViewController:jmChangeNickNameVC animated:YES];
        }
            break;
        case 2:{
            _genderMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            _genderMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
            pickerView.backgroundColor = [UIColor whiteColor];
            pickerView.delegate = self;
            pickerView.dataSource = self;
            
            UIView *completeView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
            UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 70, 40)];
            chooseLabel.backgroundColor = kBackGroundColor;
            chooseLabel.text = @"请选择性别";
            chooseLabel.textAlignment = NSTextAlignmentCenter;
            chooseLabel.font = [UIFont systemFontOfSize:14];
            
            UIButton *completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 0, 70, 40)];
            [completeBtn setTitle:@"完成" forState:(UIControlStateNormal)];
            [completeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            completeBtn.backgroundColor = kPinkColor;
            completeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            completeBtn.tag = indexPath.row + 10001;
            [completeBtn addTarget:self action:@selector(genderCompleteBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [completeView addSubview:chooseLabel];
            [completeView addSubview:completeBtn];
            
            [_genderMaskView addSubview:completeView];
            [_genderMaskView addSubview:pickerView];
            
            
            [UIView animateWithDuration:0.2 animations:^{
                completeView.frame = CGRectMake(0, kScreenHeight - 240, kScreenWidth, 40);
                pickerView.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200);
            } completion:nil];
            
            [self.view addSubview:_genderMaskView];
        }
            break;
        case 3:{
            _birsdayMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            _birsdayMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            UIDatePicker *datePickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
            datePickerView.backgroundColor = [UIColor whiteColor];
            [datePickerView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
            [datePickerView setTimeZone:[NSTimeZone localTimeZone]];
            // 设置当前显示时间
            [datePickerView setDate:[NSDate date] animated:YES];
            // 设置显示最大时间（此处为当前时间）
            [datePickerView setMaximumDate:[NSDate date]];
            // 设置UIDatePicker的显示模式
            [datePickerView setDatePickerMode:UIDatePickerModeDate];
            // 当值发生改变的时候调用的方法
            [datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            
            UIView *completeView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
            UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 70, 40)];
            chooseLabel.backgroundColor = kBackGroundColor;
            chooseLabel.text = @"请选择出生日期";
            chooseLabel.textAlignment = NSTextAlignmentCenter;
            chooseLabel.font = [UIFont systemFontOfSize:14];
            
            UIButton *completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 0, 70, 40)];
            [completeBtn setTitle:@"完成" forState:(UIControlStateNormal)];
            [completeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            completeBtn.backgroundColor = kPinkColor;
            completeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            completeBtn.tag = indexPath.row + 10000;
            [completeBtn addTarget:self action:@selector(birsdayCompleteBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [completeView addSubview:chooseLabel];
            [completeView addSubview:completeBtn];
            
            [_birsdayMaskView addSubview:completeView];
            [_birsdayMaskView addSubview:datePickerView];
            
            [UIView animateWithDuration:0.2 animations:^{
                completeView.frame = CGRectMake(0, kScreenHeight - 240, kScreenWidth, 40);
                datePickerView.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200);
            } completion:nil];
            
            [self.view addSubview:_birsdayMaskView];
        }
            break;
        case 4:{
            
        }
            break;
        default:
            break;
    }
}

#pragma mark -- pickerView的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.genderArray.count;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return [self.genderArray objectAtIndex:row];
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    _genderStr = [NSString stringWithFormat:@"%@",self.genderArray[row]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = kSingleLineColor;
        }
    }
    
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.text = self.genderArray[row];
    genderLabel.textColor = kDarkOneColor;
    
    return genderLabel;
}

#pragma mark -- 性别选择
- (void)genderCompleteBtnAction:(UIButton *)button
{
    if (![_genderStr isEqualToString:@"女"] && ![_genderStr isEqualToString:@"男"]) {
        _genderStr = @"男";
    }
    
    [self getJMGenderDataSource];
    [_genderMaskView removeFromSuperview];
    
//    NSInteger indexTag = button.tag - 10001;
//    NSIndexPath *index = [NSIndexPath indexPathForRow:indexTag inSection:0];
//    JMMyInformationViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
//    cell.nameLabel.text = _genderStr;
    _genderStr = nil;
}

#pragma mark -- 日期选择的变化监听
-(void)datePickerValueChanged:(id)sender{
    UIDatePicker *datePicker = (UIDatePicker*)sender;
    _birsdayDate = [NSDate dateWithTimeInterval:24 * 3600 sinceDate:datePicker.date];
}

- (void)birsdayCompleteBtnAction:(UIButton *)button
{
    NSString *dateStr = [NSString stringWithFormat:@"%@",_birsdayDate];
    if (dateStr.length < 11) {
        _birsdayDate = [[NSDate date] initWithTimeIntervalSinceNow:12 * 3600];
    }
    _birthdayStr = [[NSString stringWithFormat:@"%@",_birsdayDate] substringToIndex:11];
    [self getJMBirthdayDataSource];
    [_birsdayMaskView removeFromSuperview];
    
//    NSInteger indexTag = button.tag - 10000;
//    NSIndexPath *index = [NSIndexPath indexPathForRow:indexTag inSection:0];
//    JMMyInformationViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
//    cell.nameLabel.text = _birthdayStr;
    _birsdayDate = nil;
}

#pragma mark -- actionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[NightModeManager defaultManager]removeNighView];
        JstyleNewsImagePickerViewController *picker = [[JstyleNewsImagePickerViewController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else if (buttonIndex == 0){
        if (![JstyleNewsImagePickerViewController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"相机不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
        JstyleNewsImagePickerViewController *picker = [[JstyleNewsImagePickerViewController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else
        return;
}

#pragma mark -- 图片选择的代理方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [[NightModeManager defaultManager]showNightView];
    if (error) {
    }else{
  }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    _headerImageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSData *data;
    if ([type isEqualToString:@"public.image"]) {
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出
        UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 0.5);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        _iconBase64Str = [data base64EncodedStringWithOptions:0];
    }
    [self postJMHeaderImageDataSource];
    [[NightModeManager defaultManager]showNightView];
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


/**获取个人信息数据*/
- (void)getJMMyInformationDataSource
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid", nil];
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GET:MY_INFORMATION_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        
        self.inforDict = dictionary[@"data"];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //ZTShowAlertMessage(@"数据加载失败");
    }];
}

/**上传头像*/
- (void)postJMHeaderImageDataSource
{
//    NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)_iconBase64Str, NULL,CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8);
//    NSString *strUrl = [_iconBase64Str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid",_iconBase64Str,@"upload", nil];
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager POST:MY_POSTICON_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        
        [self getJMMyInformationDataSource];
        
        ZTShowAlertMessage(dictionary[@"data"]);
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        //ZTShowAlertMessage(@"数据加载失败");
    }];
}

#pragma mark - 关于IOS 11 下，图片编辑界面左下角的cancel 按钮很难点击的问题
//https://blog.csdn.net/gzgengzhen/article/details/80320518
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 11)
    {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")])
    {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
             if (obj.frame.size.width < 42)
             {
                 [viewController.view sendSubviewToBack:obj];
                 *stop = YES;
             }
         }];
    }
}


/**修改性别数据*/
- (void)getJMGenderDataSource
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid",self.genderStr,@"sex", nil];
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GET:MY_CHANGEGENDER_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        
        [self getJMMyInformationDataSource];
        
        ZTShowAlertMessage(dictionary[@"data"]);
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        //ZTShowAlertMessage(@"数据加载失败");
    }];
}

/**修改生日数据*/
- (void)getJMBirthdayDataSource
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[[JstyleToolManager sharedManager] getUserId],@"uid",self.birthdayStr,@"birth", nil];
    // 初始化Manager
    JstyleNewsNetworkManager *manager = [JstyleNewsNetworkManager shareManager];
    
    [manager GET:MY_CHANGEBIRTH_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        
        [self getJMMyInformationDataSource];
        
        ZTShowAlertMessage(dictionary[@"data"]);
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        //ZTShowAlertMessage(@"数据加载失败");
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return ISNightMode?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}



@end
