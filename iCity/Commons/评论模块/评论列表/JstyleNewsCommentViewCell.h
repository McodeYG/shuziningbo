//
//  JstyleNewsCommentViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/4.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsCommentModel.h"

@class JstyleNewsCommentViewCell;

@protocol CommentViewCellDelegate <NSObject>

@required
- (void)cell:(JstyleNewsCommentViewCell*)cell unflodBtnAction:(UIButton *)button;
@end

@interface JstyleNewsCommentViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIButton *thumbBtn;
@property (weak, nonatomic) IBOutlet UILabel *thumbNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (nonatomic,assign) id<CommentViewCellDelegate>delegate;

/**全文按钮*/
@property (nonatomic, strong) UIButton * showBtn;
/**index*/
@property (nonatomic,strong) NSIndexPath * index;


@property (nonatomic, copy) void(^replyBlock)(NSString *userName, NSString *contentId);
@property (nonatomic, copy) void(^praiseBlock)(NSString *contentId,BOOL isSelected);


@property (nonatomic, strong) JstyleNewsCommentModel *model;

@end
