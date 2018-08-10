//
//  JstyleArticleCommentCollectionCell.h
//  Exquisite
//
//  Created by 数字宁波 on 2017/6/22.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMCommentModel.h"

@interface JstyleArticleCommentCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**细线singleLine*/
@property (nonatomic, strong) UIView *singleLine;
/**[评论内容*/
@property (nonatomic, strong) JstyleLabel *contentLabel;

@property (nonatomic, strong) JMCommentModel *model;

@end
