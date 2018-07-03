//
//  NTESActionSheet.m
//  NTESActionSheet
//
//  Created by LEA on 15/9/28.
//  Copyright © 2015年 LEA. All rights reserved.
//

#import "NTESActionSheet.h"
#import "NSString+NTES.h"
#import "NTESActionSheetCell.h"
#define kWidth                      [UIScreen mainScreen].bounds.size.width
#define kHeight                     [UIScreen mainScreen].bounds.size.height
#define RGBColor(r,g,b,a)           ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define BASE_COLOR                  RGBColor(245.0, 245.0, 245.0, 1.0)
#define TABLEVIEW_BORDER_COLOR      RGBColor(231.0, 231.0, 231.0, 1.0)
#define ROW_HEIGHT                  44
#define CancelButtonTop             5
#define CancelButtonMargin          (IS_iPhoneX ? 10.f : 0.f)

@implementation NTESActionSheet

- (NTESActionSheet *)initWithTitle:(NSString *)title delegate:(id<NTESActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        if (delegate) {
            self.delegate = delegate;
        }
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        _otherButtonTitles = [[NSMutableArray alloc] initWithArray:otherButtonTitles];
        if ([destructiveButtonTitle length]) {
            [_otherButtonTitles addObject:_destructiveButtonTitle];
        }
        if ([cancelButtonTitle length]) {
            [_otherButtonTitles addObject:cancelButtonTitle];
            self.cancelButtonIndex = [_otherButtonTitles count]-1;
        }
        
        _alphaView = [[UIView alloc] initWithFrame:self.bounds];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0.0;
        [self addSubview:_alphaView];
        [self sendSubviewToBack:_alphaView];
        [_alphaView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight];
        self.autoresizesSubviews = YES ;
        _alphaView.autoresizesSubviews = YES ;
        //取消
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [_alphaView addGestureRecognizer:tapGesture];
        
        CGFloat addH = [_cancelButtonTitle length]?CancelButtonTop:0;
        CGFloat viewH = [self tableHeadHeight]+ROW_HEIGHT*[_otherButtonTitles count]+addH + CancelButtonMargin;
        _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight, kWidth, viewH)];
        _sheetView.backgroundColor = BASE_COLOR;
        [self addSubview:_sheetView];
        [_sheetView addSubview:[self tableView]];
        [_sheetView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleTopMargin];
        _sheetView.autoresizesSubviews = YES ;
        
    }
    return self;
}

-(void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.25
                     animations:^{
                         _alphaView.alpha = 0.5;
                         [_sheetView setFrame:CGRectMake(0, kHeight-_sheetView.frame.size.height, kWidth, _sheetView.frame.size.height)];
                     }];
}

-(void)tappedCancel
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         _alphaView.alpha = 0;
                         [_sheetView setFrame:CGRectMake(0, kHeight, kWidth, _sheetView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark - 初始化数据
-(UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:_sheetView.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = TABLEVIEW_BORDER_COLOR;
    _tableView.tableFooterView = [UIView new];
    [self addTableHead];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleTopMargin];
    _tableView.autoresizesSubviews = YES ;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    return _tableView;
}

-(void)addTableHead
{
    UIView *tableHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, [self tableHeadHeight])];
    tableHead.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = tableHead;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kWidth-40, [_title sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(kWidth-40, kHeight)].height)];
    titleLab.text = _title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor grayColor];
    titleLab.font = [UIFont systemFontOfSize:14.0];
    titleLab.numberOfLines = 0;
    [tableHead addSubview:titleLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, tableHead.frame.size.height, kWidth, 0.5)];
    line.backgroundColor = TABLEVIEW_BORDER_COLOR;
    [tableHead addSubview:line];
}

-(CGFloat)tableHeadHeight
{
    CGFloat height = 0;
    if ([_title length]) {
        height += [_title sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(kWidth-40, kHeight)].height+40;
    }
    return height;
}

#pragma mark - tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_otherButtonTitles count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_cancelButtonTitle length] && indexPath.row == [_otherButtonTitles count]-1) {
        return ROW_HEIGHT + CancelButtonTop + CancelButtonMargin;
    }
    return ROW_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    NTESActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NTESActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell buildUI];
    }
    
    
    cell.actionLabel.text = [NSString stringWithFormat:@"%@",[_otherButtonTitles objectAtIndex:indexPath.row]];
    
    
    if ([_destructiveButtonTitle length] && indexPath.row == [_otherButtonTitles count]-2) {
        cell.actionLabel.textColor = [UIColor redColor];
    }
    if ([_cancelButtonTitle length] && indexPath.row == [_otherButtonTitles count]-1) {
        if (IS_iPhoneX) {
            cell.actionLabel.edgeInset = UIEdgeInsetsMake(0, 0, 10, 0);
        }
        cell.actionLabel.frame = CGRectMake(0, CancelButtonTop, kWidth, ROW_HEIGHT + CancelButtonMargin);
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_cancelButtonTitle length] && indexPath.row == [_otherButtonTitles count]-1)
    {
        [self tappedCancel];
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
        return;
    }
    [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    [self tappedCancel];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
