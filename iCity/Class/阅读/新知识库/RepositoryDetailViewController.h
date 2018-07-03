//
//  RepositoryDetailViewController.h
//  iCity
//
//  Created by mayonggang on 2018/6/22.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "JstyleNewsBaseViewController.h"

@interface RepositoryDetailViewController : JstyleNewsBaseViewController

//选中的行id
@property (nonatomic, copy) NSString *selectID;

/**城市百科 传field_type=3  ：  知识库 传field_type=2*/
@property (nonatomic, copy) NSString *field_type;
@end
