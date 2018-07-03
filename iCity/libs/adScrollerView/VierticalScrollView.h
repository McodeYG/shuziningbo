//
//  VierticalScrollView.h
//  上下滚动btn
//
//  Created by 李杨 on 16/2/25.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VierticalScrollViewDelegate <NSObject>

@optional

-(void)clickTitleButton:(UIButton *)button;

@end//


#import <UIKit/UIKit.h>

typedef void(^MyBtnBlock)(NSInteger btnIndex);


@interface VierticalScrollView : UIView


-(instancetype)initWithArray:(NSArray *)titles AndTime:(NSArray *)times AndIsRemand:(NSArray *)IsRemand AndFrame:(CGRect)frame;
+(instancetype)initWithTitleArray:(NSArray *)titles times:(NSArray *)times isRemandArr:(NSArray *)isRemandArr  AndFrame:(CGRect)frame;

@property (copy, nonatomic)   MyBtnBlock btnIndex;

@property (copy, nonatomic)   void(^yuGaoBlock)(NSInteger index);

@end


