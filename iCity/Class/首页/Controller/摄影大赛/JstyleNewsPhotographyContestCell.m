//
//  JstyleNewsPhotographyContestCell.m
//  JstyleNews
//
//  Created by 王磊 on 2018/3/21.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsPhotographyContestCell.h"


@interface JstyleNewsPhotographyContestCell ()

@end

@implementation JstyleNewsPhotographyContestCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}



@end
