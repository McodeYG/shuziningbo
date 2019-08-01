//
//  MoreListView.m
//  iCity
//
//  Created by mayonggang on 2018/7/13.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "MoreListView.h"


#define LEFT_MARGIN        20.0f
#define LABEL_MARGIN       15.0f            //左右间距
#define BOTTOM_MARGIN      15.0f            //上下间距
#define KBtnTag            1000
#define R_G_B_16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MoreListView ()

/**背景图*/
@property (nonatomic, strong) UIView * whiteView;

@end

@implementation MoreListView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.totalHeight = 0;
        self.frame = frame;
        _tagArr = [[NSMutableArray alloc]init];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.2)];
    self.whiteView.backgroundColor = ISNightMode?[UIColor colorFromHexString:@"#292929"]:kWhiteColor;
    self.whiteView.tag = 2000;
    [self addSubview:self.whiteView];
    
    UITapGestureRecognizer * whiteTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whiteViewTapAction)];
    [self.whiteView addGestureRecognizer:whiteTap];
    
    UITapGestureRecognizer * backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewTapAction)];
    [self addGestureRecognizer:backTap];
}

-(void)setTagWithTagArray:(NSArray*)arr andSelectIndex:(NSUInteger)index{
    
    self.totalHeight = 0;
    [self.whiteView removeAllSubviews];
    self.previousFrame = CGRectZero;
    [_tagArr addObjectsFromArray:arr];
    
    
    [arr enumerateObjectsUsingBlock:^(ICityLifeMenuModel *model, NSUInteger idx, BOOL *stop) {
        
        UIButton*tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame = CGRectMake(LEFT_MARGIN, 25, 0, 0);
        
        
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:self.tagFont?self.tagFont:13];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:model.name forState:UIControlStateNormal];
        tagBtn.tag = KBtnTag+idx;
        
        if (idx == index) {
            tagBtn.selected = YES;
            tagBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            tagBtn.layer.borderWidth = 0;

        } else {
            tagBtn.selected = NO;
            tagBtn.layer.borderColor = [UIColor colorFromHexString:@"#999999"].CGColor;
            tagBtn.layer.borderWidth = 0.5;

        }
        
        //主题换肤
        tagBtn.lee_theme
        .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
            UIButton *button = (UIButton *)item;
            [button setTitleColor:kWhiteColor forState:UIControlStateSelected];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:value] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageWithColor:kWhiteColor] forState:UIControlStateNormal];
        });

        
        tagBtn.clipsToBounds = YES;
        tagBtn.layer.cornerRadius = self.cornerRadius?self.cornerRadius:2;

        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:self.tagFont?self.tagFont:13]};
        CGSize Size_str = [model.name sizeWithAttributes:attrs];
        
        Size_str.width += (self.horizontalPadding?self.horizontalPadding:7)*2;
        
        if (Size_str.width>SCREEN_W-2*LEFT_MARGIN) {
            Size_str.width = SCREEN_W-2*LEFT_MARGIN;
        }
        Size_str.height = 28;
    
        
        CGRect newRect = CGRectZero;
        if (self.previousFrame.origin.x==0&&self.previousFrame.origin.y==0) {
            newRect.origin = CGPointMake(LEFT_MARGIN, 25);
        }else if (self.previousFrame.origin.x + self.previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width - 2*LEFT_MARGIN) {
            
            newRect.origin = CGPointMake(LEFT_MARGIN, self.previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            self.totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }else {
            newRect.origin = CGPointMake(self.previousFrame.origin.x + self.previousFrame.size.width + LABEL_MARGIN, self.previousFrame.origin.y);
        }
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        self.previousFrame = tagBtn.frame;
     
        [self setheight:self.whiteView andheight:self.totalHeight+Size_str.height + BOTTOM_MARGIN+35];
        [self.whiteView addSubview:tagBtn];
        
    }];
    if(_GBbackgroundColor){
        self.backgroundColor = _GBbackgroundColor;
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark-改变控件高度
- (void)setheight:(UIView *)view andheight:(CGFloat)height
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = height;
    view.frame = tempFrame;
}
-(void)tagBtnClick:(UIButton*)button{
    
    button.selected=YES;
    button.layer.borderWidth=0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    for (UIButton * btn in self.whiteView.subviews) {
        if (btn.tag>=KBtnTag&&btn.tag != button.tag) {
            btn.selected = NO;
            button.layer.borderWidth=0;
            button.layer.borderColor = [UIColor colorFromHexString:@"#999999"].CGColor;
        }
    }
    if (self.didselectItemBlock) {
        self.didselectItemBlock(button.tag-KBtnTag);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mj_h = 0.5;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    
}

- (void)whiteViewTapAction {
    return;
    //屏蔽收缩动画的区域
}

- (void)backViewTapAction {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mj_h = 0.5;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}



@end
