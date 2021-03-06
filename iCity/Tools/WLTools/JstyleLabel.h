//
//  JstyleLabel.h
//  Exquisite
//
//  Created by 赵涛 on 2016/11/16.
//  Copyright © 2016年 LanBao. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
}VerticalAlignment;

@interface JstyleLabel : UILabel
{
    @private VerticalAlignment _verticalAlignment;
}
@property (nonatomic) VerticalAlignment verticalAlignment;

@end
