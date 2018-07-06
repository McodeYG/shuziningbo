//
//  JstyleNewsCommentModel.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2017/12/7.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//

#import "JstyleNewsCommentModel.h"

@implementation JstyleNewsCommentModel

-(instancetype)init {
    self = [super init];
    if (self) {
        self.isShowBtn = YES;
    }
    return self;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

//-(void)setContent:(NSString *)content {
//    _content = content;
//    CGFloat comH = [content heightForFont:[UIFont systemFontOfSize:14] width:SCREEN_W-20];
//    if (comH>70) {//文字大于四行
//        _isShowBtn = YES;
//    }else{
//        _isShowBtn = NO;
//    }
//}

@end
