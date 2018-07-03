//
//  JstyleNewFeatureTagModel.h
//  Exquisite
//
//  Created by 数字跃动 on 2017/8/24.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JstyleNewFeatureTagModel : NSObject

///标签ID
@property (nonatomic, copy) NSString *ID;
//标签名称
@property (nonatomic, copy) NSString *name;
//标签图片
@property (nonatomic, copy) NSString *image;

+ (instancetype)newFeatureTagModelWithDictionary:(NSDictionary *)dict;

@end
