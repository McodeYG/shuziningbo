//
//  JstyleNewsCoverCommentViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/7.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsCommentModel.h"

@class JstyleNewsCoverCommentViewCell;

@protocol CoverCommentViewCellDelegate <NSObject>

@required
- (void)coverCell:(JstyleNewsCoverCommentViewCell*)cell unflodBtnAction:(UIButton *)button;
@end

@interface JstyleNewsCoverCommentViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbBtn;
@property (weak, nonatomic) IBOutlet UILabel *thumbNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic,assign) id<CoverCommentViewCellDelegate>delegate;

/**全文按钮*/
@property (nonatomic, strong) UIButton * showBtn;
/**index*/
@property (nonatomic,strong) NSIndexPath * index;



@property (nonatomic, copy) void(^praiseBlock)(NSString *contentId);

@property (nonatomic, strong) JstyleNewsCommentModel *model;

@end
