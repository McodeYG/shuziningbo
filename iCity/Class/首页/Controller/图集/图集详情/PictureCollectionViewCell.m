//
//  PictureCollectionViewCell.m
//  图片浏览
//
//  Created by 数字宁波 on 2017/4/25.
//  Copyright © 2017年 赵涛. All rights reserved.
//

#import "PictureCollectionViewCell.h"
#import "PictureScrollView.h"

@implementation PictureCollectionViewCell

- (void)dealloc
{
    [SVProgressHUD dismiss];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    PictureScrollView *photoSV = [[PictureScrollView alloc] initWithFrame:self.bounds];
    photoSV.tag = 100;
    [self.contentView addSubview:photoSV];
}

- (void)setModel:(PictureModel *)model
{
    [self.backImageView setImageWithURL:[NSURL URLWithString:model.image] placeholder:nil options:(YYWebImageOptionSetImageWithFadeAnimation) completion:nil];
    PictureScrollView *photoSV = (PictureScrollView *)[self.contentView viewWithTag:100];
    __weak typeof(self)weakSelf = self;
    if (self.sigleTap) {
        photoSV.singleTap = ^void(){
            weakSelf.sigleTap();
        };
    }
    photoSV.placeholderImage = [UIImage imageNamed:@"placeholder"];
    photoSV.imageUrl = model.image;
    photoSV.frame = self.bounds;
}

@end
