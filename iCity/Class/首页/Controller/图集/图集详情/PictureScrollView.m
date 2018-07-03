//
//  PictureScrollView.m
//  图片浏览
//
//  Created by 赵涛 on 2017/4/25.
//  Copyright © 2017年 赵涛. All rights reserved.
//

#import "PictureScrollView.h"
#import "UIImage+CompareRectCategory.h"

@interface PictureScrollView()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation PictureScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        //设置最大放大倍数
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        
        //隐藏滚动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.scrollIndicatorInsets = self.contentInset;
        }
        
        //单击手势
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap1];
        
        //双击放大缩小手势
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        //双击
        tap2.numberOfTapsRequired = 2;
        //手指的数量
        tap2.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap2];
        
        //tap1、tap2两个手势同时响应时，则取消tap1手势
        [tap1 requireGestureRecognizerToFail:tap2];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.zoomScale == 1) {
        if (_imageView.image) {
            CGRect rect = [_imageView.image imageSizeCompareWithSize:CGSizeMake(kScreenWidth, kScreenHeight)];
            _imageView.frame = rect;
        }else{
            _imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }
    }
}

- (void)setImageUrl:(NSString *)imageUrl
{
    [self.activityIndicator removeFromSuperview];
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    self.activityIndicator.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self addSubview:self.activityIndicator];
    __weak typeof(self)weakSelf = self;
    [_imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [weakSelf.activityIndicator startAnimating];
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        [weakSelf.activityIndicator stopAnimating];
        //[weakSelf layoutSubviews];
    }];
}

- (void)setSingleTap:(void (^)())singleTap
{
    _singleTap = [singleTap copy];
}

#pragma mark - UIScrollView delegate
//返回需要缩放的子视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    _imageView.center = actualCenter;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (tap.numberOfTapsRequired == 1)
    {
        if (self.singleTap) {
            self.singleTap();
        }else {
            //写点什么
        }
    }else if(tap.numberOfTapsRequired == 2){
        if (self.zoomScale > 1){
            [self setZoomScale:1 animated:YES];
        } else{
            [self setZoomScale:3 animated:YES];
        }
    }
}

- (CGRect)gq_imageSizeCompareWithSize:(CGSize)size {
    CGSize originSize = size;
    CGSize imageSize = self.frame.size;
    
    CGFloat HScale = imageSize.height / originSize.height;
    CGFloat WScale = imageSize.width / originSize.width;
    CGFloat scale = (HScale > WScale) ? HScale : WScale;
    
    CGFloat height = imageSize.height / scale;
    CGFloat width = imageSize.width / scale;
    
    CGRect confirmRect = CGRectMake((size.width - width) / 2, (size.height - height) / 2, width, height);
    return confirmRect;
}

- (void)dealloc
{
    _imageView = nil;
    [self.activityIndicator stopAnimating];
}

@end
