//
//  ICityTVTableViewController.h
//  ICityTable
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSArray+Addition.h"
#import "ICityTVModel.h"
#import "ICityTVTableViewCell.h"
static NSString*const cellID = @"cellID";

@interface ICityTVTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *SettingOtherData;
@end
