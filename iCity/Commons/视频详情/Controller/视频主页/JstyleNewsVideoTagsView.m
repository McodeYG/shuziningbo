//
//  JstyleNewsVideoTagsView.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/14.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsVideoTagsView.h"

#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      5.0f
#define KBtnTag            1000

@implementation JstyleNewsVideoTagsView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        totalHeight = 0;
        self.frame = frame;
        _tagArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setTagWithTagArray:(NSArray *)array{
    totalHeight = 0;
    [self removeAllSubviews];
    previousFrame = CGRectZero;
    [_tagArr addObjectsFromArray:array];
    [array enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        UIButton*tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kDarkNineColor;
        tagBtn.frame = CGRectZero;
        if(_signalTagColor){
            //可以单一设置tag的颜色
            tagBtn.backgroundColor=_signalTagColor;
        }else{
            //tag颜色多样
            tagBtn.backgroundColor=[UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        }
        if(_canTouch){
            tagBtn.userInteractionEnabled = YES;
        }else{
            tagBtn.userInteractionEnabled = NO;
        }
        [tagBtn setTitleColor:kDarkNineColor forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:_tagFont?_tagFont:13];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:[NSString stringWithFormat:@"#%@", str] forState:UIControlStateNormal];
        tagBtn.tag = KBtnTag+idx;
        tagBtn.layer.cornerRadius = self.cornerRadius?self.cornerRadius:2;
//        tagBtn.backgroundColor = self.tagBackgroundColor?self.tagBackgroundColor:[UIColor colorFromHexString:@"#F6F7FB"];
        tagBtn.backgroundColor = [UIColor clearColor];
        tagBtn.clipsToBounds = YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:_tagFont?_tagFont:13]};
        CGSize Size_str = [str sizeWithAttributes:attrs];
        Size_str.width += (_horizontalPadding?_horizontalPadding:7)*2;
        Size_str.height += (_verticalPadding?_verticalPadding:17);
        
        CGRect newRect = CGRectZero;
        
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width - 20) {
            
            newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
        }
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        [lineView setFrame:CGRectMake(tagBtn.right + 5,tagBtn.y + _verticalPadding, 0.6, 8)];
        previousFrame = tagBtn.frame;
        [self setheight:self andheight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tagBtn];
        [self addSubview:lineView];
        if (idx == array.count - 1) {
            lineView.hidden = YES;
        }else{
            lineView.hidden = NO;
        }
    }];
//    if(_GBbackgroundColor){
//        self.backgroundColor = _GBbackgroundColor;
//    }else{
//        self.backgroundColor = [UIColor whiteColor];
//    }
}

#pragma mark-改变控件高度
- (void)setheight:(UIView *)view andheight:(CGFloat)height
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = height;
    view.frame = tempFrame;
}
- (void)tagBtnClick:(UIButton*)button{
    button.selected=!button.selected;
    if(button.selected == YES){
        self.didselectItemBlock(button.tag-KBtnTag);
    }
}

@end
