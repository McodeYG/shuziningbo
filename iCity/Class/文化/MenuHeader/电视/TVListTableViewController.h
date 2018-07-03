//
//  TVListTableViewController.h
//  iCity
//
//  Created by mayonggang on 2018/6/21.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSArray+Addition.h"

#import "ICityTVTableViewCell.h"
#import "ZJScrollPageView.h"

static NSString*const cellID = @"cellID";

@interface TVListTableViewController : UITableViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *sendId;

@end
