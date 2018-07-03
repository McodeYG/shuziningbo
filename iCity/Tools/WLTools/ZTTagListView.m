//
//  ViewController.m
//  ZTTagListView
//
//  Created by 赵涛 on 16/5/23.
//  Copyright © 2016年 赵涛. All rights reserved.
//

#import "ZTTagListView.h"

#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      15.0f
#define KBtnTag            1000
#define R_G_B_16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ZTTagListView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        totalHeight = 0;
        self.frame = frame;
        _tagArr = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setTagWithTagArray:(NSArray*)arr{
    totalHeight = 0;
    [self removeAllSubviews];
    previousFrame = CGRectZero;
    [_tagArr addObjectsFromArray:arr];
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        
        UIButton*tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
        [tagBtn setTitleColor:self.titleColor?self.titleColor:kDarkOneColor forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:_tagFont?_tagFont:13];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:str forState:UIControlStateNormal];
        tagBtn.tag = KBtnTag+idx;
        tagBtn.layer.cornerRadius = self.cornerRadius?self.cornerRadius:2;
        tagBtn.backgroundColor = self.tagBackgroundColor?self.tagBackgroundColor:[UIColor colorFromHexString:@"#F6F7FB"];
        tagBtn.clipsToBounds = YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:_tagFont?_tagFont:13]};
        CGSize Size_str = [str sizeWithAttributes:attrs];
        Size_str.width += (_horizontalPadding?_horizontalPadding:7)*2.5;
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
        previousFrame = tagBtn.frame;
        [self setheight:self andheight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tagBtn];
        
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
    button.selected=!button.selected;
    if(button.selected == YES){
        self.didselectItemBlock(button.tag-KBtnTag);
    }else if (button.selected == NO){
        
    }
//    [self didSelectItems];
}
-(void)didSelectItems{
    
    for(UIView*view in self.subviews){
        
        if([view isKindOfClass:[UIButton class]]){
            UIButton*tempBtn = (UIButton*)view;
            if (tempBtn.selected==YES) {
                self.didselectItemBlock(tempBtn.tag-KBtnTag);
            }
        }
    }
}
@end
