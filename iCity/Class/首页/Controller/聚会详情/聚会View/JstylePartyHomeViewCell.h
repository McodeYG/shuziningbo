//
//  JstylePartyHomeViewCell.h
//  Exquisite
//
//  Created by 赵涛 on 2017/7/5.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstylePartyModel.h"

typedef void(^AddressBlock)(NSString *longAddress);

@interface JstylePartyHomeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *partyImageView;
@property (weak, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyPeapleLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyLookNumLabel;
@property (weak, nonatomic) IBOutlet UIView *singleLine1;
@property (weak, nonatomic) IBOutlet UIView *singleLine2;

@property (nonatomic, strong) JstylePartyHomeModel *model;
@property (nonatomic, copy) AddressBlock addressBlock;

@end
