//
//  JMMyInformationViewCell.h
//  Exquisite
//
//  Created by 赵涛 on 16/5/5.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMMyInformationViewCell : JstyleNewsBaseTableViewCell

/**列表选项标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleName;
/**修改完成所显示的信息*/
@property (weak, nonatomic) IBOutlet JstyleNewsBaseTitleLabel *nameLabel;


@end
