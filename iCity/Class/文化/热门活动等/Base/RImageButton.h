//
//  RImageButton.h
//  Gxj
//
//  Created by 马永刚 on 2017/11/24.
//  Copyright © 2017年 马永刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RImageButton : UIButton

@property(nonatomic)CGRect imageRect;

@property(nonatomic)CGRect titleRect;

@property(nonatomic,assign) BOOL isSelect;

@end
