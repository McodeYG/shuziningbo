//
//  JstyleMyEarningsServiceTermsCell.h
//  Exquisite
//
//  Created by JingHongMuYun on 2018/3/6.
//  Copyright © 2018年 JstyleStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleMyEarningsServiceTermsCell : UITableViewCell

@property (nonatomic, assign) BOOL cellSelected;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, copy) void(^selectBlock)(BOOL selected);

@end
