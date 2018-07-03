//
//  NTESActionSheetCell.m
//  NTESActionSheet
//
//  Created by liuhu on 16/5/17.
//  Copyright © 2016年 LEA. All rights reserved.
//

#import "NTESActionSheetCell.h"

@implementation NTESActionSheetCell
#define kWidth                      [UIScreen mainScreen].bounds.size.width
#define kHeight                     [UIScreen mainScreen].bounds.size.height

#define ROW_HEIGHT                  44
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)buildUI{
    
    NTESLabel *titleLab = [[NTESLabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, ROW_HEIGHT)];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont systemFontOfSize:15.0];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:titleLab];
    self.actionLabel = titleLab ;
    [self.contentView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.5]];
    self.actionLabel = titleLab ;
    [self.actionLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated              // animate between regular and highlighted state
{
    
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        
        [self.actionLabel setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.5]];
    }else{
        
        [self.actionLabel setBackgroundColor:[UIColor whiteColor]];
    }
}

@end
