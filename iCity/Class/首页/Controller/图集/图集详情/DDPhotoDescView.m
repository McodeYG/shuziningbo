//
//  DDPhotoDescView.m
//  DDNews
//
//  Created by Dvel on 16/4/20.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import "DDPhotoDescView.h"

#define DescViewDefaultHeight 50

@interface DDPhotoDescView()

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation DDPhotoDescView

- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc index:(NSInteger)index totalCount:(NSInteger)totalCount
{
	self = [super init];
	if (self) {
		// 描述文本
		UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 0)];
        descLabel.numberOfLines = 0;
        descLabel.attributedText = [desc attributedStringWithlineSpace:5 textColor:kLightWhiteColor textFont:13];
        CGRect descRect = [desc getAttributedStringRectWithSpace:5 withFont:13 withWidth:kScreenWidth - 20];
		descLabel.frame = CGRectMake(10, 0, kScreenWidth - 20, descRect.size.height);
		
		// self
		self = [[DDPhotoDescView alloc] initWithFrame:CGRectMake(0, kScreenHeight - DescViewDefaultHeight - 49, kScreenWidth, 999)];
		self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
		[self addSubview:descLabel];
		// descLabel.height 和 descLabel.contentSize.height
		self.tag = descRect.size.height > DescViewDefaultHeight ? descRect.size.height : DescViewDefaultHeight - 10;
		
        // 标题View里的index
        UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 30, 30)];
        indexLabel.text = [[NSString stringWithFormat:@"%zd", index + 1] stringByAppendingString:[NSString stringWithFormat:@" ∕ %zd", totalCount]];
        indexLabel.textAlignment = NSTextAlignmentRight;
        indexLabel.textColor = kLightWhiteColor;
        indexLabel.font = [UIFont systemFontOfSize:15];
        [indexLabel sizeToFit];
        indexLabel.x = kScreenWidth - indexLabel.width - 10;
		
		// 标题View里的标题
        CGRect rect = [title boundingRectWithSize:CGSizeMake(indexLabel.left - 15, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:nil context:nil];
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, indexLabel.left - 15, rect.size.height)];
		titleLabel.text = title;
		titleLabel.textColor = kLightWhiteColor;
		titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.numberOfLines = 0;
		[titleLabel sizeToFit];
        
        // 标题View
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, titleLabel.height + 28)];
        titleView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        titleView.y = descLabel.y - (titleLabel.height + 28);
        
//        UIView *singleLine = [[UIView alloc]initWithFrame:CGRectMake(10, titleView.height - 11, kScreenWidth - 20, 0.3)];
//        singleLine.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        
        [titleView addSubview:indexLabel];
        [titleView addSubview:titleLabel];
//        [titleView addSubview:singleLine];
        [self addSubview:titleView];
		
		// 手势 ***一个view可以有多个手势，一个手势只能对应一个view
		UISwipeGestureRecognizer *swipeUp	= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
		UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
		swipeUp.direction	= UISwipeGestureRecognizerDirectionUp;
		swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
		[self addGestureRecognizer:swipeUp];
		[self addGestureRecognizer:swipeDown];
	}
	return self;
}

/** 为了使超出self范围titleView也能响应手势，重写hitTest方法 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	UIView *view = [super hitTest:point withEvent:event];
	if (view == nil) {
		for (UIView *subView in self.subviews) {
			CGPoint p = [subView convertPoint:point fromView:self];
			if (CGRectContainsPoint(subView.bounds, p)) {
				view = subView;
			}
		}
	}
	return view;
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer
{
	if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
		[UIView animateWithDuration:0.3 animations:^{
			self.y = kScreenHeight - self.tag - 20 - 49;
		}];
	} else if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
		[UIView animateWithDuration:0.3 animations:^{
			self.y = kScreenHeight - DescViewDefaultHeight - 49;
		}];
	} else {
		NSLog(@"wocao");
	}
}
@end
