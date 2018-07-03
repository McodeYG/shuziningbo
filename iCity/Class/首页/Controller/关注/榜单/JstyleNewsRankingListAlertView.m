//
//  JstyleNewsRankingListAlertView.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/4/24.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsRankingListAlertView.h"

@interface JstyleNewsRankingListAlertView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, copy) NSString *chooseStr;

@end

@implementation JstyleNewsRankingListAlertView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray
{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = dataArray;
        if (self.dataArray.count) {
            _chooseStr = [NSString stringWithFormat:@"%@", [self.dataArray objectAtIndex:0]];
        }
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = kWhiteColor;
    alertView.layer.cornerRadius = 5;
    [self addSubview:alertView];
    alertView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(311)
    .heightIs(186);
    
    UIView *singLine1 = [[UIView alloc] init];
    singLine1.backgroundColor = kSingleLineColor;
    [alertView addSubview:singLine1];
    singLine1.sd_layout
    .bottomSpaceToView(alertView, 45)
    .leftEqualToView(alertView)
    .rightEqualToView(alertView)
    .heightIs(0.5);
    
    UIView *singLine2 = [[UIView alloc] init];
    singLine2.backgroundColor = kSingleLineColor;
    [alertView addSubview:singLine2];
    singLine2.sd_layout
    .bottomSpaceToView(alertView, 10)
    .topSpaceToView(singLine1, 10)
    .centerXEqualToView(alertView)
    .widthIs(0.5);
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.titleLabel.font = JSFont(15);
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:kDarkNineColor forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [alertView addSubview:cancelBtn];
    cancelBtn.sd_layout
    .leftSpaceToView(alertView, 0)
    .rightSpaceToView(singLine2, 0)
    .topSpaceToView(singLine1, 0)
    .bottomSpaceToView(alertView, 0);
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.titleLabel.font = JSFontWithWeight(15, UIFontWeightMedium);
    sureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:kDarkThreeColor forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [alertView addSubview:sureBtn];
    sureBtn.sd_layout
    .leftSpaceToView(singLine2, 0)
    .rightSpaceToView(alertView, 0)
    .topSpaceToView(singLine1, 0)
    .bottomSpaceToView(alertView, 0);
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [alertView addSubview:pickerView];
    pickerView.sd_layout
    .leftSpaceToView(alertView, 0)
    .rightSpaceToView(alertView, 0)
    .topSpaceToView(alertView, 5)
    .bottomSpaceToView(singLine1, 0);
}

- (void)cancelBtnClicked:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (void)sureBtnClicked:(UIButton *)sender
{
    if (self.chooseBlock) {
        self.chooseBlock(_chooseStr);
    }
    
    [self removeFromSuperview];
}

#pragma mark -- pickerView的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return [self.genderArray objectAtIndex:row];
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    _chooseStr = [NSString stringWithFormat:@"%@",self.dataArray[row]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = kSingleLineColor;
        }
    }
    
    UILabel *chooseLabel = [UILabel new];
    chooseLabel.font = JSFont(15);
    chooseLabel.textAlignment = NSTextAlignmentCenter;
    chooseLabel.text = self.dataArray[row];
    chooseLabel.textColor = kDarkThreeColor;
    
    return chooseLabel;
}


@end
