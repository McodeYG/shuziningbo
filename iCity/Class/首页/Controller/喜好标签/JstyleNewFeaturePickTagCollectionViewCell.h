//
//  JstyleNewFeaturePickTagCollectionViewCell.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/8/24.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewFeaturePickTagCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^iconClickBlock)(BOOL isSelect,NSString *tagName);
@property (nonatomic, strong) NSMutableArray *alreadySelectArrayM;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
