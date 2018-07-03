//
//  JstyleNewsHomeTagChooseViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/1.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyChannelBlock)(NSArray *channelsArray);
typedef void(^MyChannelClicked)(NSString *channelName);

@interface JstyleNewsHomeTagChooseViewController : JstyleNewsBaseViewController

@property (nonatomic, strong) MyChannelBlock myChannelBlock;

@property (nonatomic, strong) MyChannelClicked myChannelClicked;

@end
