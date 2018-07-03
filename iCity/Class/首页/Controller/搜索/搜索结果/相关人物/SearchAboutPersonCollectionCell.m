//
//  SearchAboutPersonCollectionCell.m
//  iCity
//
//  Created by mayonggang on 2018/6/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "SearchAboutPersonCollectionCell.h"


@interface SearchAboutPersonCollectionCell ()

/**头像*/
@property (nonatomic, strong) UIImageView * headerImgV;
/**姓名*/
@property (nonatomic, strong) UILabel * nameLab;

@end


@implementation SearchAboutPersonCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    //
    self.headerImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 212/2, 212/2)];
    self.headerImgV.userInteractionEnabled = YES;
    [self.contentView addSubview:self.headerImgV];
    
    //
    self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 212/2+8, 212/2, 17)];
    self.nameLab.textColor = kNightModeTextColor;
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    self.nameLab.font = JSFont(15);
    [self.contentView addSubview:self.nameLab];
}


-(void)setModel:(SearchAboutPersonModel *)model {
    
    [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:model.poster] placeholderImage:SZ_Place_Header];
    if (![model.poster isNotBlank]) {
        NSLog(@"--%@--%@--没有图片链接",model.poster,model.name);
    }
    
    if (_key.length>0) {
        NSString * oldString = model.name;
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc]initWithString:oldString];
        NSRange titleRang = [oldString rangeOfString:self.key];
        NSDictionary *colorAttrDic = @{NSForegroundColorAttributeName:kRedSearchTextColor};
        [titleString setAttributes:colorAttrDic range:titleRang];
        
        self.nameLab.attributedText = titleString;
    }else{
        self.nameLab.text = model.name;
    }
    
}

@end
