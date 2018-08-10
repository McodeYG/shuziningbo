//
//  JstylePartyHomeHeaderViewCell.h
//  Exquisite
//
//  Created by 数字宁波 on 2017/7/18.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstylePartyModel.h"

typedef void(^AddressBlock)(NSString *longAddress);

@interface JstylePartyHomeHeaderViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *partyImageView;
@property (weak, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyAddressLabel;

@property (nonatomic, strong) JstylePartyHomeModel *model;
@property (nonatomic, copy) AddressBlock addressBlock;

@end
