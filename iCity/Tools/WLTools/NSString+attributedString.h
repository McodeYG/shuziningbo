//
//  NSString+attributedString.h
//  Exquisite
//
//  Created by 赵涛 on 2016/11/29.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (attributedString)

/**
 * 设置富文本某一区间颜色样式
 @param textcolor              文字颜色
 @param range                  颜色区间
 @param fontSize               字体大小
 @return 富文本
 */
- (NSAttributedString *)attributedStringWithTextColor:(UIColor *)textcolor
                                                range:(NSRange)range
                                             textFont:(NSInteger)fontSize;
/**同上:可以设置粗字体*/
- (NSAttributedString *)attributedStringWithTextColor:(UIColor *)textcolor
                                                range:(NSRange)range
                                             fontSize:(UIFont *)fontSize;
/**同上:可以设置对齐方式*/
- (NSAttributedString *)attributedStringWithlineSpace:(CGFloat)lineSpace textColor:(UIColor *)textcolor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

/**同上:不需要设置颜色*/
- (NSAttributedString *)attributedStringWithlineSpace:(CGFloat)lineSpace font:(UIFont *)font;

/**可以自定义字体粗细的段落设置*/
- (NSAttributedString *)attributedStringWithlineSpace:(CGFloat)lineSpace textColor:(UIColor *)textcolor font:(UIFont *)font;


/**
 设置段落样式

 @param lineSpace 行间距
 @param textcolor 字体颜色
 @param fontSize 字体大小
 @return 返回富文本
 */
- (NSAttributedString *)attributedStringWithlineSpace:(CGFloat)lineSpace
                                            textColor:(UIColor *)textcolor
                                             textFont:(NSInteger)fontSize;

/**可以设置水平文字间距*/
- (NSAttributedString *)attributedStringWithHorizontalSpace:(CGFloat)horizontalSpace textColor:(UIColor *)textcolor font:(UIFont *)font;

/**富文本文字中间加线*/
- (NSAttributedString *)attributedLineStringWithTextColor:(UIColor *)textcolor font:(UIFont *)font;

/**富文本文字、只能设置字体和颜色*/
- (NSAttributedString *)attributedColorStringWithTextColor:(UIColor *)textcolor font:(UIFont *)font;

/**
 * 设置富文本行间距，并设置某一区间颜色样式
 @param lineSpace 行间距
 @param range 特殊颜色范围
 @param textAlignment 对齐方式
 @param textcolor 特殊颜色
 @param fontSize 特殊颜色字体
 @return 返回富文本
 */
- (NSAttributedString *)attributedStringWithlineSpace:(CGFloat)lineSpace range:(NSRange)range textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textcolor textFont:(UIFont *)fontSize;

/**
 富文本高度
 @param lineSpace 行间距
 @param font 字体大小
 @param width label宽度
 @return 返回rect
 */
- (CGRect)getAttributedStringRectWithSpace:(CGFloat)lineSpace
                                  withFont:(CGFloat)font
                                 withWidth:(CGFloat)width;

/**
 * 计算文字高度
 @param string       传入的文字
 @param font         字体大小
 @param width        文字所占宽度
 @return             文本的尺寸
 */
+ (CGRect)getStringSizeWithString:(NSString *)string
                          andFont:(CGFloat)font
                         andWidth:(CGFloat)width;




/**搜索*/
- (NSAttributedString *)attributedStringWithKey:(NSString *)key lineSpace:(CGFloat)lineSpace font:(UIFont *)font;






//热门推荐图书
- (CGFloat)getAttributedStringHeightWithSpace:(CGFloat)lineSpace withFont:(UIFont *)font withWidth:(CGFloat)width;



@end
