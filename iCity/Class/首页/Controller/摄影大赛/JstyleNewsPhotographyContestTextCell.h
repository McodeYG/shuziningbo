//
//  JstyleNewsPhotographyContestTextCell.h
//  JstyleNews
//
//  Created by 王磊 on 2018/3/22.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JstyleNewsPhotographyContestModel.h"

typedef NS_ENUM(NSInteger,JstyleNewsPhotographyContestTextfieldType) {
    JstyleNewsPhotographyContestTextfieldTypePhotoName = 20001,//作品名称
    JstyleNewsPhotographyContestTextfieldTypeContestantName = 20002//拍摄者名称
};

@interface JstyleNewsThemeButton : UIButton

@property (nonatomic, copy) NSString *themeid;

+ (instancetype)buttonWithThemeModel:(JstyleNewsPhotographyContestThemeModel *)model;

@end

@interface JstyleNewsPhotographyContestTextCell : UITableViewCell

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSArray<JstyleNewsPhotographyContestThemeModel *> *themeArray;
@property (nonatomic, copy) void(^themeBtnBlock)(JstyleNewsThemeButton *themeBtn);

@end
