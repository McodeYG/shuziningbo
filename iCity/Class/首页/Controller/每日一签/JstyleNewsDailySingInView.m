//
//  JstyleNewsDailySingInView.m
//  JstyleNews
//
//  Created by 王磊 on 2018/2/2.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsDailySingInView.h"
#import "UIImageView+Layer.h"

#define Margin_Top (52 + (IS_iPhoneX?60:0))
#define Margin_TopBetweenBottom 22.5
#define Margin_LeftAndRight 41
#define Margin_PictureHeight ([UIScreen mainScreen].bounds.size.width == 375 ? 464.0 : 525.0)

@interface JstyleNewsDailySingInBorderImageView : UIImageView

@end

@implementation JstyleNewsDailySingInBorderImageView

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super initWithImage:image]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(borderAnimatedStart) name:@"DailySingInBorderAnimaterNotification" object:nil];
    }
    return self;
}

- (void)borderAnimatedStart {
    
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 animations:^{
            self.alpha = 0;
        }];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@interface JstyleNewsDailySingInView ()

@property (nonatomic, strong) UIImage *shareImage;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JstyleNewsDailySingInView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    UIButton *closeBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"每日一签-关闭"] selectedImage:[UIImage imageNamed:@"每日一签-关闭"] target:self action:@selector(closeBtnClick)];
    [closeBtn sizeToFit];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(Margin_Top);
        make.right.offset(-Margin_LeftAndRight);
        make.width.offset(closeBtn.width);
        make.height.offset(closeBtn.height);
    }];
    
    UIImageView *pictureImageView = [[UIImageView alloc] init];
    self.pictureImageView = pictureImageView;
    pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:pictureImageView];
    [pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(closeBtn.mas_bottom).offset(Margin_TopBetweenBottom);
        make.left.offset(Margin_LeftAndRight);
        make.right.offset(-Margin_LeftAndRight);
        make.height.offset(Margin_PictureHeight);
    }];
    
    UIImageView *posterBorderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"每日一签-头像"]];
    self.posterBorderImageView = posterBorderImageView;
    [self addSubview:posterBorderImageView];
    [posterBorderImageView sizeToFit];
    [posterBorderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pictureImageView).offset(23 / 2.0);
        make.bottom.equalTo(pictureImageView).offset(8);
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.8 block:^(NSTimer * _Nonnull timer) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DailySingInBorderAnimaterNotification" object:nil];
    } repeats:YES];

    [self.timer fire];
    
    for (NSInteger i = 0; i < 4; i++) {
        JstyleNewsDailySingInBorderImageView *border = [[JstyleNewsDailySingInBorderImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"每日一签-头像%zd",i+1]]];
        [self addSubview:border];
        [border sizeToFit];
        [border mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(posterBorderImageView).offset(0);
        }];
    }
    
    UIImageView *posterImageView = [[UIImageView alloc] init];
    posterImageView.userInteractionEnabled = YES;
    self.posterImageView = posterImageView;
    posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    posterImageView.layer.cornerRadius = (40 / 2.0);
    posterImageView.layer.masksToBounds = YES;
    [self addSubview:posterImageView];
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.posterBorderImageView).offset(-0.15);
        make.centerY.equalTo(self.posterBorderImageView).offset(-0.15);
        make.height.width.offset(40);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPosterGesture)];
    [posterImageView addGestureRecognizer:tap];
    
    WLLabel *nameLabel = [[WLLabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textColor = kDarkNineColor;
    nameLabel.font = [UIFont fontWithName:@"PingFang SC" size:11];
    nameLabel.edgeInsets = UIEdgeInsetsMake(0, 41 + 10, 0, 10);
    [self insertSubview:nameLabel belowSubview:self.posterBorderImageView];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(posterImageView);
        make.left.equalTo(posterImageView);
        make.height.offset(23 * kScale);
    }];
    
    UIButton *shareBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:(IS_iPhoneX?@"每日一签-立即分享-X":@"每日一签-立即分享")] selectedImage:[UIImage imageNamed:(IS_iPhoneX?@"每日一签-立即分享-X":@"每日一签-立即分享")] target:self action:@selector(shareBtnClick)];
    [shareBtn sizeToFit];
    [self addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pictureImageView.mas_bottom).offset(Margin_TopBetweenBottom);
        make.centerX.offset(0);
    }];
    
    self.alpha = 0;
}

- (void)tapPosterGesture {
    if (self.chatBlock && self.model) {
        [self closeBtnClick];
        self.chatBlock(self.model);
    }
}

- (void)shareBtnClick {
    if (self.shareImageBlock) {
        
        if (self.posterImageView.image == nil || self.pictureImageView.image == nil) {
            return;
        }

        self.shareImageBlock([self renderShareImage]);
    }
}

#pragma mark - 渲染合成分享图
- (UIImage *)renderShareImage {
    
    UIImageView *posterImageView = self.posterImageView;
    
    UIGraphicsBeginImageContextWithOptions(posterImageView.bounds.size, NO, 0.0);
    
    [[UIBezierPath bezierPathWithRoundedRect:posterImageView.bounds cornerRadius:posterImageView.width] addClip];
    
    [posterImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    posterImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.pictureImageView.size.width, self.pictureImageView.size.height + 8), YES, 0.0);
    [self.pictureImageView.image drawInRect:CGRectMake(0, 0, self.pictureImageView.width, self.pictureImageView.height)];
    
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 10, (435 + 44) - posterImageView.height + (kScale == 1?0:50.5));
    
    [self.nameLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, 0);
    
    [self.posterBorderImageView.image drawInRect:CGRectMake(0, -23.5 + posterImageView.height - 30, self.posterBorderImageView.width / (IS_iPhoneX?414.0/375.0:1), self.posterBorderImageView.height / (IS_iPhoneX?414.0/375.0:1))];
    [posterImageView.image drawInRect:CGRectMake(1.8, -21.7 + posterImageView.height - 30, posterImageView.width / (IS_iPhoneX?414.0/375.0:1), posterImageView.height / (IS_iPhoneX?414.0/375.0:1))];
    
    UIImage *shareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shareImage;
}

- (void)setModel:(JstyleNewsDailySingInModel *)model {
    _model = model;
    
    NSString *nameText = [model.job stringByAppendingString:[NSString stringWithFormat:@"：%@",model.nickname]];
    self.nameLabel.attributedText = [[NSAttributedString alloc] initWithString:nameText attributes:@{NSKernAttributeName:@0.5f,
                                                                                                NSForegroundColorAttributeName:kDarkNineColor,
                                                                                                NSFontAttributeName:[UIFont fontWithName:@"PingFang SC" size:11]
                                                                                                
                                                                                                }];
    [self.nameLabel sizeToFit];
    [self.posterImageView setImageURL:[NSURL URLWithString:model.avator]];
    
    self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    __weak typeof(self)weakSelf = self;
    [self.pictureImageView setImageWithURL:[NSURL URLWithString:model.image] placeholder:nil options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.alpha = 1;
        }];
    }];
}

- (void)closeBtnClick {
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.timer invalidate];
        self.timer = nil;
    }];
}

@end
