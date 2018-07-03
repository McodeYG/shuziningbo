//
//  JstyleNewsUserHasLoginedBeforeViewController.h
//  JstyleNews
//
//  Created by 王磊 on 2018/2/12.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsUserHasLoginedBeforeViewController : UIViewController

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *poster;

@property (nonatomic, copy) void(^goLoginBlock)(BOOL success);

@end
