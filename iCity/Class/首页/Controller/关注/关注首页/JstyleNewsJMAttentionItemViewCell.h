//
//  JstyleNewsJMAttentionItemViewCell.h
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/3/28.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JstyleNewsJMAttentionItemViewCell : JstyleNewsBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *attentionMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *rankingListBtn;
@property (weak, nonatomic) IBOutlet UIButton *myAttentionBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, copy) void(^attentionMoreBlock)();
@property (nonatomic, copy) void(^rankingListBlock)();
@property (nonatomic, copy) void(^myAttentionBlock)();

@end
