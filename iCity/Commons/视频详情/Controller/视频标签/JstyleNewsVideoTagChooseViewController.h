//
//  JstyleNewsVideoTagChooseViewController.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/11.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyChannelBlock)(NSArray *channelsArray);
typedef void(^MyChannelClicked)(NSString *channelName);

@interface JstyleNewsVideoTagChooseViewController : JstyleNewsBaseViewController

@property (nonatomic, strong) MyChannelBlock myChannelBlock;

@property (nonatomic, strong) MyChannelClicked myChannelClicked;

@end
