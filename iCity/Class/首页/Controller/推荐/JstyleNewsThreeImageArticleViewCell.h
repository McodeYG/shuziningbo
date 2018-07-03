//
//  JstyleNewsThreeImageArticleViewCell.h
//  JstyleNews
//
//  Created by 赵涛 on 2017/10/24.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsHomeModel.h"
#import "JstylePhotosContainerView.h"

@interface JstyleNewsThreeImageArticleViewCell : JstyleNewsBaseTableViewCell<JstylePhotosContainerViewDelegate>

/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**三个图背景图*/
@property (nonatomic, strong) JstylePhotosContainerView *photosContainerView;
/**栏目名字、时间*/
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
/**关闭*/
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
/**黑色小view*/
@property (weak, nonatomic) IBOutlet UIView *holdView;
/**icon*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**图片数量*/
@property (weak, nonatomic) IBOutlet UILabel *imageNumLabel;

@property (nonatomic, strong) JstyleNewsHomePageModel *model;
//置顶
@property (nonatomic,strong)UILabel * setTopLab;
/**分割线*/
@property (nonatomic, strong) UIView * footerView;

- (void)setModel:(JstyleNewsHomePageModel *)model withIndex:(NSIndexPath *)index;


@end
