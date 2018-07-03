//
//  HotBooksCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "HotBooksCell.h"
#import "JstyleNewsActivityWebViewController.h"

@interface HotBooksCell ()


/**文章标题*/
@property (nonatomic, strong) UILabel * titleLab;

/**left*/
@property (nonatomic, strong) UIImageView * leftImg;
/**中间的*/
@property (nonatomic, strong) UIImageView * midImg;
/**right*/
@property (nonatomic, strong) UIImageView * rightImg;


@end
@implementation HotBooksCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    
    static NSString * cell_id = @"HotBooksCell_id";
    HotBooksCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[HotBooksCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cell_id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.titleLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.textColor = kNightModeTextColor;
    self.titleLab.numberOfLines = 2;
    self.titleLab.font = [UIFont systemFontOfSize:18];
    
    //______________________________________________
    self.leftImg = [[UIImageView alloc]init];
    
    UITapGestureRecognizer * leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftImgTap)];
    self.leftImg.userInteractionEnabled = YES;
    [self.leftImg addGestureRecognizer:leftTap];
    
    [self.contentView addSubview:self.leftImg];
    
    //______________________________________________
    self.midImg = [[UIImageView alloc]init];
    UITapGestureRecognizer * midTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(midImgTap)];
    self.midImg.userInteractionEnabled = YES;
    [self.midImg addGestureRecognizer:midTap];
    
    [self.contentView addSubview:self.midImg];
    
    
    
    //______________________________________________
    self.rightImg = [[UIImageView alloc]init];
    
    UITapGestureRecognizer * rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightImgTap)];
    self.rightImg.userInteractionEnabled = YES;
    [self.rightImg addGestureRecognizer:rightTap];
    
    [self.contentView addSubview:self.rightImg];
    
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.offset(15);
    }];
    CGFloat img_W = (SCREEN_W-20-20)/3;
    CGFloat img_H = img_W/112*149;
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.width.mas_equalTo(img_W);
        make.height.mas_equalTo(img_H);
    }];
    [self.midImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImg.mas_right).offset(10);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.width.mas_equalTo(img_W);
        make.height.mas_equalTo(img_H);
    }];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.midImg.mas_right).offset(10);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
        make.width.mas_equalTo(img_W);
        make.height.mas_equalTo(img_H);
    }];
    
    [self layoutIfNeeded];
}

-(void)setModel:(JstyleNewsHomePageModel *)model {
    _model = model;
    
    self.titleLab.attributedText = [[NSString stringWithFormat:@"%@",model.title] attributedStringWithlineSpace:3 font:JSTitleFont];
    
    if (model.otherBanner) {
        if (model.otherBanner.count>2) {
            
            OtherBannerModel * imgModel = model.otherBanner.firstObject;
            [self.leftImg sd_setImageWithURL:[NSURL URLWithString:imgModel.poster] placeholderImage:SZ_Place_F_T];
            
             OtherBannerModel * imgModel2 = model.otherBanner[1];
            [self.midImg sd_setImageWithURL:[NSURL URLWithString:imgModel2.poster] placeholderImage:SZ_Place_F_T];
            
             OtherBannerModel * imgModel3 = model.otherBanner.lastObject;
            [self.rightImg sd_setImageWithURL:[NSURL URLWithString:imgModel3.poster] placeholderImage:SZ_Place_F_T];
        }
    }
}


- (void)leftImgTap {
    if (_model.otherBanner) {
        if (_model.otherBanner.count>0) {
            
            OtherBannerModel * imgModel = _model.otherBanner.firstObject;
            JstyleNewsActivityWebViewController *jstyleNewsActivityWVC = [JstyleNewsActivityWebViewController new];
            jstyleNewsActivityWVC.urlString = imgModel.h5url;
            jstyleNewsActivityWVC.isShare = imgModel.isShare.integerValue;
            jstyleNewsActivityWVC.navigationTitle = imgModel.title;
            [self.viewController.navigationController pushViewController:jstyleNewsActivityWVC animated:YES];
            NSLog(@"===%@",imgModel.h5url);
        }
    }
    
}
- (void)midImgTap {
    if (_model.otherBanner) {
        if (_model.otherBanner.count>1) {
            
            OtherBannerModel * imgModel = _model.otherBanner[1];
            JstyleNewsActivityWebViewController *jstyleNewsActivityWVC = [JstyleNewsActivityWebViewController new];
            jstyleNewsActivityWVC.urlString = imgModel.h5url;
            jstyleNewsActivityWVC.isShare = imgModel.isShare.integerValue;
            jstyleNewsActivityWVC.navigationTitle = imgModel.title;
            [self.viewController.navigationController pushViewController:jstyleNewsActivityWVC animated:YES];

        }
    }
    
}
- (void)rightImgTap {
    
    if (_model.otherBanner) {
        if (_model.otherBanner.count>2) {
            
            OtherBannerModel * imgModel = _model.otherBanner.lastObject;
            JstyleNewsActivityWebViewController *jstyleNewsActivityWVC = [JstyleNewsActivityWebViewController new];
            jstyleNewsActivityWVC.urlString = imgModel.h5url;
            jstyleNewsActivityWVC.isShare = imgModel.isShare.integerValue;
            jstyleNewsActivityWVC.navigationTitle = imgModel.title;
            [self.viewController.navigationController pushViewController:jstyleNewsActivityWVC animated:YES];
        }
    }
    
}

@end
