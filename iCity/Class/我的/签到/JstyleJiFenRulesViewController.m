//
//  JstyleJiFenRulesViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/3/2.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleJiFenRulesViewController.h"

@interface JstyleJiFenRulesViewController ()

@property (strong, nonatomic) NSURL *imageURL;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation JstyleJiFenRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分规则";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageURL = [NSURL URLWithString:@"http://app.jstyle.cn/jm_interface_1_2/upimage/jfmx.png"];
    [self configureView];
}

- (void)configureView
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager diskImageExistsForURL:self.imageURL completion:^(BOOL existBool) {
        _imageView = [[UIImageView alloc]init];
        [_imageView sd_setImageWithURL:self.imageURL];
        UIImage * image; CGFloat scale = 0.0;
        if (existBool) {
            image = [[manager imageCache] imageFromDiskCacheForKey:self.imageURL.absoluteString];
        }else{
            NSData *data = [NSData dataWithContentsOfURL:self.imageURL];
            image = [UIImage imageWithData:data];
        }
        if (image.size.width == 0 || image.size.height == 0) {
            scale = 750.0/1426.0;
        }else{
            scale = image.size.width/image.size.height;
        }
        
        _imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth / scale);
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenWidth / scale + 40);
        scrollView.showsVerticalScrollIndicator = NO;
        
        [scrollView addSubview:_imageView];
        [self.view addSubview:scrollView];
    }];
    
    
}

/**
 * 获取网络图片的大小
 */
- (CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)  return CGSizeZero;  // url不正确返回CGSizeZero
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size)) // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
- (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    // Dispose of any resources that can be recreated.
}

@end
