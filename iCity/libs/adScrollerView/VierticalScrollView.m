//
//  VierticalScrollView.m
//  上下滚动btn
//
//  Created by 李杨 on 16/2/25.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "VierticalScrollView.h"

#define MYScreenW [UIScreen mainScreen].bounds.size.width
#define MYScreenH [UIScreen mainScreen].bounds.size.height
#define BTNWidth self.bounds.size.width
#define BTNHeight self.bounds.size.height
#define btnX 130

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MYFont(x)  [UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:(MYScreenW > 320 ? (CGFloat)x  : (CGFloat)x /1.1)]

@interface VierticalScrollView ()
@property (nonatomic,strong) NSMutableArray *titles;
@property (nonatomic,strong) NSMutableArray *times;
@property (nonatomic,strong) NSMutableArray *isRemands;
@property(assign, nonatomic)int titleIndex;
@property(assign, nonatomic)int timeIndex;
@property(assign, nonatomic)int isRemandIndex;
@property(assign, nonatomic)int index;
@property (nonatomic,copy) NSString *nameString;
/**提醒我按钮*/
@property (nonatomic,strong) UIButton *isRemandOneBtn;
@property (nonatomic,strong) UIButton *isRemandTwoBtn;
@end

@implementation VierticalScrollView

-(instancetype)initWithArray:(NSArray *)titles AndTime:(NSArray *)times AndIsRemand:(NSArray *)IsRemand AndFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titles = [NSMutableArray arrayWithArray:titles];
        self.times = [NSMutableArray arrayWithArray:times];
        self.isRemands = [NSMutableArray arrayWithArray:IsRemand];
        NSString *str = @"";
        [self.titles addObject:str];
        [self.times addObject:str];
        [self.isRemands addObject:str];
        self.index = 1;
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(0, 0, kScreenWidth - 170, 56);
        btn.tag = self.index;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *nameStrOne = [NSString stringWithFormat:@"%@",self.titles[0]];
//        NSString *timeStrOne = [NSString stringWithFormat:@"%@",self.times[0]];
        NSString *isRemandOne = [NSString stringWithFormat:@"%@",self.isRemands[0]];
//        UIButton *isRemandOneBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 170, 13, 78, 30)];
//        isRemandOneBtn.tag = self.index;
//        isRemandOneBtn.hidden = YES;
//        [isRemandOneBtn.layer setCornerRadius:5.0];
//        self.isRemandOneBtn = isRemandOneBtn;
//        if ([isRemandOne isEqualToString:@"0"]) {
//            [isRemandOneBtn setBackgroundImage:[UIImage imageNamed:@"提醒"] forState:(UIControlStateNormal)];
//            [isRemandOneBtn setTitle:@"提醒" forState:UIControlStateNormal];
//            isRemandOneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//            [isRemandOneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [isRemandOneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//            isRemandOneBtn.userInteractionEnabled=YES;
//        }else{
//            isRemandOneBtn.backgroundColor = [UIColor whiteColor];
//            isRemandOneBtn.layer.borderWidth = 0.5;
//            isRemandOneBtn.layer.borderColor = [[UIColor colorFromHexString:@"#EFECEC"] CGColor];
//            [isRemandOneBtn setTitle:@"已提醒" forState:UIControlStateNormal];
//            isRemandOneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//            [isRemandOneBtn setTitleColor:[kDarkNineColor colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
//            [isRemandOneBtn setTitleColor:[kDarkNineColor colorWithAlphaComponent:0.8] forState:UIControlStateSelected];
//            isRemandOneBtn.userInteractionEnabled=NO;
//        }
//        if (self.isRemands.count != 0) {
//            [self addSubview:isRemandOneBtn];
//        }
//        [isRemandOneBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *oneLabOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, kScreenWidth - 200, 12)];
        oneLabOne.text = nameStrOne;
        oneLabOne.font = [UIFont systemFontOfSize:12];
        oneLabOne.textColor = kDarkFiveColor;
        [btn addSubview:oneLabOne];
        
        if ([nameStrOne containsString:@"暂无预告"]) {
            oneLabOne.frame = CGRectMake(0, 28, kScreenWidth - 90, 28);
//            isRemandOneBtn.hidden = YES;
        }else{
            oneLabOne.frame = CGRectMake(0, 28, kScreenWidth - 90, 12);
//            isRemandOneBtn.hidden = NO;
        }
        
//        UILabel *oneLabTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(oneLabOne.frame) + 6, kScreenWidth - 200, 12)];
//        oneLabTwo.text = timeStrOne;
//        oneLabTwo.textColor = kDarkNineColor;
//        oneLabTwo.font = [UIFont systemFontOfSize:12];
//        [btn addSubview:oneLabTwo];
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn pointInside:CGPointMake(btn.width - 100, 10) withEvent:nil];
        [self addSubview:btn];
        self.clipsToBounds = NO;
        [btn setTitleColor:UIColorFromRGB(0x4c4c4c) forState:UIControlStateNormal];
        btn.titleLabel.numberOfLines = 2;
        
        if (self.titles.count == 2) {
            
        }else{
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextButton) userInfo:nil repeats:YES];
        }
    }
    
    return self;
}

+(instancetype)initWithTitleArray:(NSArray *)titles times:(NSArray *)times isRemandArr:(NSArray *)isRemandArr AndFrame:(CGRect)frame{
    
    return [[self alloc]initWithArray:titles  AndTime:times AndIsRemand:isRemandArr AndFrame:frame];
}

-(void)nextButton{
    [self.isRemandOneBtn removeFromSuperview];
    [self.isRemandTwoBtn removeFromSuperview];
    UIButton *firstBtn = [self viewWithTag:self.index];
    UIButton *modelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth - 170, 50)];
    modelBtn.titleLabel.numberOfLines = 2;
    modelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    modelBtn.tag = self.index + 1;
    if ([self.titles[self.titleIndex+1] isEqualToString:@""]) {
        self.titleIndex = -1;
        self.timeIndex = -1;
        self.isRemandIndex = -1;
        self.index = 0;
    }
    if (modelBtn.tag == self.titles.count) {
        
        modelBtn.tag = 1;
    }
    [modelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    NSString *nameStr = [NSString stringWithFormat:@"%@",self.titles[self.titleIndex+1]];
//    NSString *timeStr = [NSString stringWithFormat:@"%@",self.times[self.titleIndex+1]];
    NSString *isRemandTwo = [NSString stringWithFormat:@"%@",self.isRemands[self.titleIndex+1]];
    UIButton *isRemandTwoBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 170, 13, 78, 30)];
    [isRemandTwoBtn.layer setCornerRadius:5.0];
    isRemandTwoBtn.hidden = YES;
    self.isRemandTwoBtn = isRemandTwoBtn;
    isRemandTwoBtn.tag = self.index +1;
    if ([isRemandTwo isEqualToString:@"0"]) {
        [isRemandTwoBtn setBackgroundImage:[UIImage imageNamed:@"提醒"] forState:(UIControlStateNormal)];
        [isRemandTwoBtn setTitle:@"提醒" forState:UIControlStateNormal];
        isRemandTwoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [isRemandTwoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [isRemandTwoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        isRemandTwoBtn.userInteractionEnabled=YES;
    }else{
        isRemandTwoBtn.backgroundColor = [UIColor whiteColor];
        isRemandTwoBtn.layer.borderWidth = 0.5;
        isRemandTwoBtn.layer.borderColor = [[UIColor colorFromHexString:@"#EFECEC"] CGColor];
        [isRemandTwoBtn setTitle:@"已提醒" forState:UIControlStateNormal];
        isRemandTwoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [isRemandTwoBtn setTitleColor:[kDarkNineColor colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [isRemandTwoBtn setTitleColor:[kDarkNineColor colorWithAlphaComponent:0.8] forState:UIControlStateSelected];
        isRemandTwoBtn.userInteractionEnabled=NO;
    }
    if (isRemandTwoBtn.tag == self.titles.count) {
        
        isRemandTwoBtn.tag = 1;
    }
    if (self.isRemands.count != 0) {
        [self addSubview:isRemandTwoBtn];
    }
    [isRemandTwoBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *twoLabOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, kScreenWidth - 90, 12)];
    twoLabOne.text = nameStr;
    twoLabOne.font = [UIFont systemFontOfSize:12];
    twoLabOne.textColor = kDarkFiveColor;
    [modelBtn addSubview:twoLabOne];
    
    if ([nameStr containsString:@"暂无预告"]) {
        twoLabOne.frame = CGRectMake(0, 28, kScreenWidth - 90, 28);
        isRemandTwoBtn.hidden = YES;
    }else{
        twoLabOne.frame = CGRectMake(0, 28, kScreenWidth - 90, 12);
        isRemandTwoBtn.hidden = YES;
    }
    
//    UILabel *twoLabTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(twoLabOne.frame) + 6, kScreenWidth - 200, 12)];
//    twoLabTwo.text = timeStr;
//    twoLabTwo.textColor = kDarkNineColor;
//    twoLabTwo.font = [UIFont systemFontOfSize:12];
//    [modelBtn addSubview:twoLabTwo];

    [self addSubview:modelBtn];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        firstBtn.y = -BTNHeight;
        modelBtn.y = 0;
    } completion:^(BOOL finished) {
        [firstBtn removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        firstBtn.y = -BTNHeight;
        modelBtn.y = 0;
        
    } completion:^(BOOL finished) {
        [firstBtn removeFromSuperview];
    } ];
    self.index++;
    self.titleIndex++;
    self.timeIndex++;
    self.isRemandIndex++;
}

-(void)clickBtn:(UIButton *)btn{
    if (self.btnIndex) {
        self.btnIndex(btn.tag);
    }
    if (self.yuGaoBlock) {
        self.yuGaoBlock(btn.tag);
    }
}

//-(void)clickBtn
//{
//    if (self.yuGaoBlock) {
//        self.yuGaoBlock();
//    }
//}

@end
