//
//  NSString+attributedString.m
//  Exquisite
//
//  Created by 数字宁波 on 2016/11/29.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import "NSString+attributedString.h"

@implementation NSString (attributedString)

- (NSAttributedString *)attributedStringWithTextColor:(UIColor *)textcolor
                                                range:(NSRange)range
                                             textFont:(NSInteger)fontSize{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self attributes:nil];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:textcolor range:range];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:fontSize] range:range];
    
    return attributedStr;
}

- (NSAttributedString *)attributedStringWithTextColor:(UIColor *)textcolor
                                                range:(NSRange)range
                                             fontSize:(UIFont *)fontSize{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self attributes:nil];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:textcolor range:range];
    [attributedStr addAttribute:NSFontAttributeName
                          value:fontSize range:range];
    
    return attributedStr;
}

- (NSAttributedString *)attributedStringWithlineSpace:(CGFloat)lineSpace range:(NSRange)range textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textcolor textFont:(UIFont *)fontSize{
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.alignment = textAlignment;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    // 创建文字属性
    [attriStr addAttribute:NSForegroundColorAttributeName
                     value:textcolor range:range];
    [attriStr addAttribute:NSFontAttributeName
                     value:fontSize range:range];
    return attriStr;
}

- (NSAttributedString *)attributedStringWithlineSpace:(CGFloat)lineSpace textColor:(UIColor *)textcolor textFont:(NSInteger)fontSize{
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.lineSpacing = lineSpace;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@-0.5f};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    
    return attriStr;
}

- (NSAttributedString *)attributedStringWithlineSpace:(CGFloat)lineSpace font:(UIFont *)font{
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.lineSpacing = lineSpace;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@-0.5f};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSFontAttributeName:font};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    
    return attriStr;
}

- (NSAttributedString *)attributedStringWithlineSpace:(CGFloat)lineSpace textColor:(UIColor *)textcolor font:(UIFont *)font{
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.lineSpacing = lineSpace;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSFontAttributeName:font};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    return attriStr;
}

- (NSAttributedString *)attributedStringWithlineSpace:(CGFloat)lineSpace textColor:(UIColor *)textcolor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment{
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.alignment = textAlignment;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@-0.5f};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:font};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    
    return attriStr;
}

- (NSAttributedString *)attributedStringWithHorizontalSpace:(CGFloat)horizontalSpace textColor:(UIColor *)textcolor font:(UIFont *)font{
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:[NSString stringWithFormat:@"%f",horizontalSpace]};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:font};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    
    return attriStr;
}

- (NSAttributedString *)attributedColorStringWithTextColor:(UIColor *)textcolor font:(UIFont *)font
{
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:font};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    return attriStr;
}

- (NSAttributedString *)attributedLineStringWithTextColor:(UIColor *)textcolor font:(UIFont *)font
{
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:font,NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    return attriStr;
}

- (CGRect)getAttributedStringRectWithSpace:(CGFloat)lineSpace withFont:(CGFloat)font withWidth:(CGFloat)width{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paraStyle.lineSpacing = lineSpace;
    //NSKernAttributeName字体间距
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect;
}

+ (CGRect)getStringSizeWithString:(NSString *)string andFont:(CGFloat)font andWidth:(CGFloat)width{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect;
}


- (NSAttributedString *)attributedStringWithKey:(NSString *)key lineSpace:(CGFloat)lineSpace font:(UIFont *)font{
    
    
    
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    paragraphStyle.lineSpacing = lineSpace;
//    // NSKernAttributeName字体间距
//    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@-0.5f};
//    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
//    // 创建文字属性
//    NSDictionary * attriBute = @{NSFontAttributeName:font};
//    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
//
//    //关键字换色
//    NSRange titleRang = [self rangeOfString:key];
//    NSDictionary *colorAttrDic = @{NSForegroundColorAttributeName:kRedSearchTextColor};
//    [attriStr addAttributes:colorAttrDic range:titleRang];
    
    NSRange titleRang = [self rangeOfString:key];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:kRedSearchTextColor
                          range:titleRang];
    
    [AttributedStr addAttribute:NSFontAttributeName
                          value:font
                          range:NSMakeRange(0 , self.length)];
    
    //修改行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineSpace];
    [AttributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, self.length)];
    
    
    return AttributedStr;
}




//热门推荐图书
- (CGFloat)getAttributedStringHeightWithSpace:(CGFloat)lineSpace withFont:(UIFont *)font withWidth:(CGFloat)width {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineSpacing = lineSpace;
    
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size.height;
}


@end
