//
//  NewspaperController.h
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageView.h"


@interface NewspaperController : UIViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *sendId;

@end
