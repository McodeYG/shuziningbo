//
//  JstyleNewsVideoFullScreenShareView.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/31.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoFullScreenShareView.h"
#import "JstyleNewsVideoShareViewCell.h"

#define kImageArray   @[@"全屏微信", @"全屏朋友圈", @"全屏QQ", @"全屏微博", @"全屏复制链接"]
#define kTitleArray   @[@"微信", @"朋友圈", @"QQ", @"微博", @"复制链接"]

@interface JstyleNewsVideoFullScreenShareView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isShareHoldViewHidden;
@property (nonatomic, strong) UILabel *shareLabel;

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareDesc;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareImgUrl;
@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation JstyleNewsVideoFullScreenShareView

- (instancetype)initWithFrame:(CGRect)frame shareTitle:(NSString *)shareTitle shareDesc:(NSString *)shareDesc shareUrl:(NSString *)shareUrl shareImgUrl:(NSString *)shareImgUrl viewController:(UIViewController *)viewController
{
    if (self == [super initWithFrame:frame]) {
        self.shareTitle = [NSString stringWithFormat:@"%@",shareTitle];
        self.shareUrl = [NSString stringWithFormat:@"%@",shareUrl];
        self.shareImgUrl = [NSString stringWithFormat:@"%@",shareImgUrl];
        self.shareDesc = [NSString stringWithFormat:@"%@",shareDesc];
        self.viewController = viewController;
        
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.bounds;
    effectView.alpha = 0.99;
    
    [self addSubview:effectView];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"全屏分享关闭"] forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:closeBtn];
    closeBtn.sd_layout
    .leftSpaceToView(self, 20)
    .topSpaceToView(self, 30)
    .widthIs(30)
    .heightIs(30);
    
    UILabel *shareLabel = [[UILabel alloc]init];
    shareLabel.text = @"分享";
    shareLabel.textColor = kWhiteColor;
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = JSFontWithWeight(18, UIFontWeightHeavy);
    [self addSubview:shareLabel];
    shareLabel.sd_layout
    .leftSpaceToView(self, 30)
    .rightSpaceToView(self, 30)
    .topSpaceToView(self, 90 * kScale)
    .heightIs(18);
    
    UILabel *shareTitleLabel = [[UILabel alloc]init];
    shareTitleLabel.text = [NSString stringWithFormat:@"「 %@ 」",self.shareTitle];
    shareTitleLabel.textColor = kWhiteColor;
    shareTitleLabel.textAlignment = NSTextAlignmentCenter;
    shareTitleLabel.font = JSFontWithWeight(16, UIFontWeightHeavy);
    [self addSubview:shareTitleLabel];
    shareTitleLabel.sd_layout
    .leftSpaceToView(self, 100)
    .rightSpaceToView(self, 100)
    .topSpaceToView(shareLabel, 30)
    .heightIs(16);
    
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.3];
    [self addSubview:lineView1];
    lineView1.sd_layout
    .leftSpaceToView(self, 100)
    .rightSpaceToView(self, 100)
    .topSpaceToView(shareTitleLabel, 40)
    .heightIs(0.5);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"JstyleNewsVideoShareViewCell" bundle:nil] forCellWithReuseIdentifier:@"JstyleNewsVideoShareViewCell"];
    [self addSubview:self.collectionView];
    _collectionView.sd_layout
    .leftSpaceToView(self, 100)
    .rightSpaceToView(self, 100)
    .topSpaceToView(lineView1, 15)
    .heightIs(55);
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(100 * kScreenWidth / 667.0, 90 * kScreenHeight / 375.0 + 185, kScreenWidth - 200 * kScreenWidth / 667.0, 0.3)];
    lineView2.backgroundColor = [kWhiteColor colorWithAlphaComponent:0.3];
    [self addSubview:lineView2];
    lineView2.sd_layout
    .leftSpaceToView(self, 100)
    .rightSpaceToView(self, 100)
    .topSpaceToView(_collectionView, 15)
    .heightIs(0.5);
}

- (void)closeBtnClicked:(UIButton *)sender
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark -- collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kTitleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"JstyleNewsVideoShareViewCell";
    JstyleNewsVideoShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.shareImageView.image = [UIImage imageNamed:kImageArray[indexPath.row]];
    cell.shareTitleLabel.text = kTitleArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[JstyleToolManager sharedManager] getCurrentNetStatus] == NotReachable) {
        ZTShowAlertMessage(@"当前无网络,请检查网络");
        return;
    }
        
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImgUrl]]]];
    //设置视频网页播放地址
    shareObject.videoUrl = self.shareUrl;
    //shareObject.videoStreamUrl = shareVideoUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    switch (indexPath.row) {
        case 0:{
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self.viewController completion:nil];
        }
            break;
        case 1:{
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_WechatSession)]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self.viewController completion:nil];
        }
            break;
        case 2:{
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_QQ)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/qq/id444934666?mt=8"]];
                return;
            }
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self.viewController completion:nil];
        }
            break;
        case 3:{
            if (![[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType_Sina)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/sina/id350962117?mt=8"]];
                return;
            }
            messageObject.text = [NSString stringWithFormat:@"%@来自@数字文化城市（想看更多？下载数字宁波APPhttps://www.jianshu.com/p/fd01efdb12fa）%@",self.shareTitle, self.shareUrl];
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:self.shareImgUrl];
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:self.viewController completion:nil];
        }
            break;
        case 4:{
            UIPasteboard *pastboad = [UIPasteboard generalPasteboard];
            pastboad.string = self.shareUrl;
            ZTShowAlertMsgInView(@"复制链接成功", 2, self);
        }
            break;
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenHeight - 200)/kImageArray.count, 55);
}


@end
