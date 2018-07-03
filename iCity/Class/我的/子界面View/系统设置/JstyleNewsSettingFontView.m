//
//  JstyleNewsSettingFontView.m
//  JstyleNews
//
//  Created by 数字跃动 on 2017/12/26.
//  Copyright © 2017年 JstyleNews. All rights reserved.
//



@interface JstyleNewsSettingFontCell : UITableViewCell

@end

@interface JstyleNewsSettingFontCell()

//字体大小
@property (nonatomic, copy) NSString *fontSize;
@property (nonatomic, weak) UILabel *fontSizeLabel;


@end

@implementation JstyleNewsSettingFontCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *fontSizeLabel = [UILabel labelWithColor:kDarkThreeColor fontSize:16 text:@"特大" alignment:NSTextAlignmentCenter];
    self.fontSizeLabel = fontSizeLabel;
    [fontSizeLabel sizeToFit];
    [self.contentView addSubview:fontSizeLabel];
    [fontSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = JSColor(@"#E7E4E4");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(0.5);
    }];
}

- (void)setFontSize:(NSString *)fontSize {
    _fontSize = fontSize;
    
    self.fontSizeLabel.text = fontSize;
}

@end

#import "JstyleNewsSettingFontView.h"

@interface JstyleNewsSettingFontView () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (nonatomic, strong) NSArray *fontSizeArray;

@end

static NSString *JstyleNewsSettingFontCellID = @"JstyleNewsSettingFontCellID";

@implementation JstyleNewsSettingFontView

- (NSArray *)fontSizeArray {
    if (_fontSizeArray == nil) {
        _fontSizeArray = @[@"小",@"中",@"大",@"特大"];
    }
    return _fontSizeArray;
}

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
    
    self.backgroundColor = [UIColor clearColor];
    
    self.cancleBtn.layer.cornerRadius = 8;
    self.cancleBtn.layer.masksToBounds = YES;
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerClass:[JstyleNewsSettingFontCell class] forCellReuseIdentifier:JstyleNewsSettingFontCellID];
    
    self.tableView.layer.cornerRadius = 8;
    self.tableView.layer.masksToBounds = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.bounces = NO;
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fontSizeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleNewsSettingFontCell *cell = [tableView dequeueReusableCellWithIdentifier:JstyleNewsSettingFontCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fontSize = self.fontSizeArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 47)];
    
    UILabel *titleLabel = [UILabel labelWithColor:kDarkNineColor fontSize:12 text:@"设置字体大小" alignment:NSTextAlignmentCenter];
    [titleLabel sizeToFit];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = JSColor(@"#E7E4E4");
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(0.5);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 47;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [JstyleToolManager sharedManager].titleFontSize = nil;
    //本地化保存
    [[NSUserDefaults standardUserDefaults] setObject:self.fontSizeArray[indexPath.row] forKey:@"JstyleNewsFontSize"];
    //发送全局字体更改通知
    [[NSNotificationCenter defaultCenter] postNotificationName:KJstyleNewsChangeFontSizeNotification object:nil];
    
    __weak typeof(self)weakSelf = self;
    if (self.fontSizeBlock) {
        self.fontSizeBlock(weakSelf.fontSizeArray[indexPath.row]);
    }
}

- (void)cancleBtnClick {
    if (self.cancleBtnBlock) {
        self.cancleBtnBlock();
    }
}

@end
