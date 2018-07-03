//
//  JstyleNewsNoSinglePlaceholderView.h
//  JstyleNews
//
//  Created by 王磊 on 2018/1/31.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsNoSinglePlaceholderView : UIView

@property (nonatomic, copy) void(^reloadBlock)();

- (void)showNoConnectedLabelWithStatus:(NSString *)status;

@end
