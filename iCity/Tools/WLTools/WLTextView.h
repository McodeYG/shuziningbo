//
//  WLTextView.h
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/5.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLTextView : UITextView

@property (strong, nonatomic) UILabel *surplusLbl; // 剩余可输入字数
@property (strong, nonatomic) UILabel *placeholderLbl; // 占位文字
@property (assign, nonatomic) NSInteger maxLength; // 最大文字长度

@property (assign, nonatomic) CGFloat textViewH; // 初始化时的textView高度
@property (weak, nonatomic) UIView *subView; // 父控件

@end
