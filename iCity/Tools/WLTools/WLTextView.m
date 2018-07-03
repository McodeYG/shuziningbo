//
//  WLTextView.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/5.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "WLTextView.h"

@interface WLTextView () <UITextViewDelegate>


@end

@implementation WLTextView

/**
 初始化方法
 
 @param frame     尺寸
 @param subView   父控件
 @param title     textView 内容文本
 @param place     占位文字
 @param maxLength 最大文字长度
 */
- (instancetype)initWithFrame:(CGRect)frame subView:(UIView *)subView title:(NSString *)title place:(NSString *)place maxLength:(NSInteger)maxLength
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxLength = maxLength;
        self.textViewH = frame.size.height;
        self.subView = subView;
        
        self.layer.cornerRadius = 5;
        self.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        
//        [self configSurplusLbl];
//        [self configPlaceholderLbl];
        
        // 如果有内容文本，就让占位文字隐藏，计算可输入字数
        if (title) {
            self.placeholderLbl.hidden = YES;
            self.attributedText = [self textViewAttributedStr:title];
            self.surplusLbl.text = [NSString stringWithFormat:@"%ld/%ld", maxLength - title.length, maxLength];
        } else {
            self.placeholderLbl.hidden = NO;
            self.placeholderLbl.text = place;
            self.surplusLbl.text = [NSString stringWithFormat:@"%ld/%ld", maxLength, maxLength];
        }
        // 如果textView的contentSize.height的高度大于初始化高度，就更新textView的实际高度，更新剩余可输入字数的Y值
        if (frame.size.height < self.contentSize.height) {
            frame.size.height = self.contentSize.height;
            self.frame = frame;
            self.surplusLbl.top = CGRectGetMaxY(frame) + 10;
        }
        
        // 监听键盘改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}
// 返回文本格式
- (NSAttributedString *)textViewAttributedStr:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
#pragma mark - UITextViewDelegate

// 计算剩余可输入字数 超出最大可输入字数，就禁止输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 设置占位文字是否隐藏
    if(![text isEqualToString:@""]) {
        [self.placeholderLbl setHidden:YES];
    }
    if([text isEqualToString:@""] && range.length == 1 && range.location == 0){
        [self.placeholderLbl setHidden:NO];
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < self.maxLength) {
            return YES;
        }else{
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = self.maxLength - comcatstr.length;
    if (caninputlen >= 0){
        return YES;
    }else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0, MAX(len, 0)};
        if (rg.length > 0){
            // 因为我的是不需要输入表情，所以没有计算表情的宽度
                        NSString *s =@"";
                        //判断是否只普通的字符或asc码(对于中文和表情返回NO)
                        BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
                        if (asc) {
                            s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
                        }else{
                            __block NSInteger idx = 0;
                            __block NSString  *trimString =@"";//截取出的字串
                            //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                            [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
                                if (idx >= rg.length) {
                                    *stop =YES;//取出所需要就break，提高效率
                                    return ;
                                }
                                trimString = [trimString stringByAppendingString:substring];
                                idx++;
                            }];
                            s = trimString;
                        }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setAttributedText: [self textViewAttributedStr:[textView.text stringByReplacingCharactersInRange:range withString:[text substringWithRange:rg]]]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.surplusLbl.text = [NSString stringWithFormat:@"%d/%ld",0,(long)self.maxLength];
        }
        return NO;
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > self.maxLength){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:self.maxLength];
        [textView setAttributedText: [self textViewAttributedStr:s]];
    }
    //不让显示负数
    self.surplusLbl.text = [NSString stringWithFormat:@"%ld/%ld",MAX(0,self.maxLength - existTextNum),self.maxLength];
    
    // 自动增加textView的高度
    //    CGRect bouns = textView.bounds;
    //    CGSize maxSize = CGSizeMake(bouns.size.width, CGFLOAT_MAX);
    //    CGSize newSize = [textView sizeThatFits:maxSize];
    //    NSLog(@"%@", NSStringFromCGSize(self.size));
    //    if (newSize.height > self.height) {
    //        textView.height = newSize.height + 20;
    //        self.surplusLbl.top = textView.height - 20;
    //        self.placeholderLbl.top = CGRectGetMaxY(textView.frame);
    //    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeholderLbl.hidden = YES;
    } else {
        self.placeholderLbl.hidden = NO;
    }
    return YES;
}

- (void)textViewKeyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        // 键盘下去了
        if (keyboardF.origin.y >= kScreenHeight) {
            CGRect frame = self.frame;
            if (frame.size.height < self.contentSize.height) {
                frame.size.height = self.contentSize.height;
                self.frame = frame;
                self.surplusLbl.top = CGRectGetMaxY(self.frame) + 10;
            }
            // 键盘上来了
        } else {
            CGRect frame = self.frame;
            frame.size.height = self.textViewH;
            self.frame = frame;
            self.surplusLbl.top = CGRectGetMaxY(self.frame) + 10;
        }
    }];
}
// 限制输入表情

+ (BOOL)isStringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}


@end
