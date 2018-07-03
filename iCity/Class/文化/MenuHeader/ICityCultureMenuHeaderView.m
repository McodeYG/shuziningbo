//
//  ICityCultureMenuHeaderView.m
//  iCity
//
//  Created by 王磊 on 2018/5/1.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "ICityCultureMenuHeaderView.h"
#import "ICityBaseMenuButton.h"

@interface ICityCultureMenuHeaderView()

@property (nonatomic, strong) NSMutableArray *menuButtons;

@end

@implementation ICityCultureMenuHeaderView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
       
    }
    return self;
}

- (void)setupUI {
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:NightModeManagerNotification object:nil];
    
    self.menuButtons = [NSMutableArray arrayWithCapacity:4];
    CGFloat buttonWidth = kScreenWidth / 4.0;
    
    UIImage *buttonImage;
    NSString *buttonTitle;
    
    for (NSInteger i = 0; i < 4; i++) {
        switch (i) {
            case 0:
                buttonImage = JSImage(@"TV");
                buttonTitle = @"电视";
                break;
            case 1:
                buttonImage = JSImage(@"broadcast");
                buttonTitle = @"广播";
                break;
            case 2:
                buttonImage = JSImage(@"newspaper");
                buttonTitle = @"报纸";
                break;
            case 3:
                buttonImage = JSImage(@"new_midia");
                buttonTitle = @"新媒体";
                break;
            default:
                break;
        }
        ICityBaseMenuButton *menuButton = [ICityBaseMenuButton buttonWithImage:buttonImage title:buttonTitle];
        menuButton.frame = CGRectMake(i*buttonWidth, 0, buttonWidth, 98 * kScale);
        menuButton.tag = 3000 + i;
        [menuButton setBackgroundColor:[UIColor clearColor]];
        [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
        [self.menuButtons addObject:menuButton];
    }
    [self applyTheme];
}

- (void)menuButtonClick:(UIButton *)button {
    
    if (self.menuButtonClickBlock) {
        ICityLifeMenuModel *model = self.menuArray[button.tag - 3000];
        self.menuButtonClickBlock(button.titleLabel.text, model.html == nil ? @"" : model.html);
    }
}

- (void)setMenuArray:(NSArray<ICityLifeMenuModel *> *)menuArray {
    _menuArray = menuArray;
    
    for (NSInteger i = 0; i < self.menuButtons.count; i++) {
        
        ICityBaseMenuButton *button = self.menuButtons[i];
        if (i < menuArray.count) {
            NSURL *imageUrl = [NSURL URLWithString:[menuArray[i] icon]];
            NSString *title = [menuArray[i] name];
            [button setImageWithURL:imageUrl forState:UIControlStateNormal placeholder:SZ_Place_Header];
            [button setTitle:title forState:UIControlStateNormal];
        }
    }
}


- (void)applyTheme {

    self.backgroundColor = kNightModeBackColor;
    for (ICityBaseMenuButton *button  in self.menuButtons) {
        if ([button isKindOfClass:[ICityBaseMenuButton class]]) {
            
            UIColor * color = ISNightMode?[UIColor whiteColor]:kDarkThreeColor;
            [button setTitleColor:color forState:(UIControlStateNormal)];
        }
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
