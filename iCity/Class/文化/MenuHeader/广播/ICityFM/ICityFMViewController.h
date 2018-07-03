//
//  ICityFMViewController.h
//  HSQiCITY
//
//  Created by chunzheng wang on 2018/5/1.
//  Copyright © 2018年 chunzheng wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICityBoradcastModel.h"

@interface ICityFMViewController : UIViewController

@property(nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSArray<ICityBoradcastModel *> *fmDatas;

@end
