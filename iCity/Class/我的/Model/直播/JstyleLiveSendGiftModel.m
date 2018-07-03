//
//  JstyleLiveSendGiftModel.m
//  Exquisite
//
//  Created by 赵涛 on 2017/2/10.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleLiveSendGiftModel.h"

@implementation JstyleLiveSendGiftModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
