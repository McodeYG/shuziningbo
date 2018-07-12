//
//  ChannelView.m
//  标签栏
//
//  Created by admin on 2017/9/29.
//  Copyright © 2017年 xushuo. All rights reserved.
//

#import "ChannelView.h"

@interface ChannelView ()
@property (nonatomic, strong) UIScrollView *ScrollView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) NSMutableArray *upBtn;
@property (nonatomic, strong) NSMutableArray *belowBtn;

@property (nonatomic, strong) NSMutableArray <NSValue*>*upFranmeArr;
@property (nonatomic, strong) NSMutableArray <NSValue*>*belowFranmeArr;

@property (nonatomic, strong) UILabel *channelLabel;
//点击进入图片
@property (nonatomic, strong) UILabel *clickInLabel;

@end

@implementation ChannelView

-(NSMutableArray *)upBtn{
    if (!_upBtn) {
        _upBtn = [NSMutableArray array];
    }
    return _upBtn;
}

-(NSMutableArray *)belowBtn{
    if (!_belowBtn) {
        _belowBtn = [NSMutableArray array];
    }
    return _belowBtn;
}


- (NSMutableArray *)upFranmeArr{
    if (!_upFranmeArr) {
        _upFranmeArr = [NSMutableArray array];
    }
    return _upFranmeArr;
}

- (NSMutableArray *)belowFranmeArr{
    if (!_belowFranmeArr) {
        _belowFranmeArr = [NSMutableArray array];
    }
    return _belowFranmeArr;
}

static CGFloat btnW;
static CGFloat btnH;

- (void)willMoveToSuperview:(UIView *)newSuperview;
{
    if (self.btnNumber == 0) {
        self.btnNumber = 4;
    }
    
    btnW = (self.frame.size.width - 30 - (self.btnNumber-1)*10)/self.btnNumber;
    btnH = btnW * 30 / 66;
    
    self.ScrollView = [[UIScrollView alloc]init];
    self.ScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.ScrollView.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    [self addSubview:self.ScrollView];
    
    UILabel *compileLabel = [[UILabel alloc]init];
    compileLabel.textColor = ISNightMode?kDarkFiveColor:kDarkTwoColor;
    compileLabel.text = @"我的频道";
    compileLabel.font = [UIFont systemFontOfSize:15.0f];
    compileLabel.frame = CGRectMake(15, 0, 70, 50);
    [self.ScrollView addSubview:compileLabel];
    
    self.clickInLabel = [[UILabel alloc]init];
    self.clickInLabel.text = @"点击进入频道";
    self.clickInLabel.textColor = ISNightMode?kDarkFiveColor:kDarkNineColor;
    self.clickInLabel.font = [UIFont systemFontOfSize:12.0f];
    self.clickInLabel.frame = CGRectMake(compileLabel.right + 10, 0, 100, 50);
    [self.ScrollView addSubview:self.clickInLabel];
    
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.frame = CGRectMake(15, compileLabel.frame.size.height, self.frame.size.width-20, ((self.upBtnDataArr.count+self.belowBtnDataArr.count)/self.btnNumber)*btnH+10*((self.upBtnDataArr.count+self.belowBtnDataArr.count)/self.btnNumber)+100 + btnH);
    [self.ScrollView addSubview:self.backgroundView];
    
    self.ScrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.backgroundView.frame)+btnH);
    
    
    UIButton *compileBtn = [[UIButton alloc]init];
    [compileBtn setTitleColor:[UIColor colorFromHexString:@"#F60100"] forState:UIControlStateNormal];
    [compileBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [compileBtn addTarget:self action:@selector(compileBtn:) forControlEvents:UIControlEventTouchUpInside];
    [compileBtn setTitle:@"完成" forState:UIControlStateSelected];
    compileBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    compileBtn.frame = CGRectMake(self.ScrollView.frame.size.width - 60, 10, 46, 23);
    compileBtn.layer.cornerRadius = 11.5;
    compileBtn.layer.masksToBounds = YES;
    compileBtn.layer.borderWidth = 0.5;
    compileBtn.layer.borderColor = [UIColor colorFromHexString:@"#F60100"].CGColor;
    [self.ScrollView addSubview:compileBtn];
    self.compileBtn = compileBtn;
    
    compileBtn.lee_theme
    .LeeConfigButtonTitleColor(ThemeMainBtnTitleOrBorderColor, UIControlStateNormal)
    .LeeConfigButtonTitleColor(ThemeMainBtnTitleOrBorderColor, UIControlStateSelected)
    .LeeCustomConfig(ThemeMainBtnTitleOrBorderColor, ^(id item, id value) {
        [item layer].borderColor = [value CGColor];
    });
    
    for (int i = 0; i < self.upBtnDataArr.count; i ++) {
        int a = (i/self.btnNumber);
        UIButton *btn  = [self addBtnFrame:CGRectMake((i%self.btnNumber)*btnW+(i%self.btnNumber)*10, a*btnH + a*10, btnW, btnH)];
//        UIImageView *imageView = [UIImageView new];
//        imageView.image = [UIImage imageNamed:@"减少"];
//        [btn addSubview:imageView];
//        imageView.sd_layout
//        .topEqualToView(btn).offset(-7)
//        .rightEqualToView(btn).offset(7)
//        .widthIs(14)
//        .heightIs(14);
//        imageView.hidden = YES;
        
        [btn addTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:self.upBtnDataArr[i] forState:UIControlStateNormal];
        //添加手势
        //涛哥更改
        if (i != 0 && i != 1) {
            [self addLongPress:btn];
        }
        [self.upFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
        [self.upBtn addObject:btn];
    }
    
    self.channelLabel = [[UILabel alloc]init];
    self.channelLabel.textColor = ISNightMode?kDarkFiveColor:kDarkTwoColor;
    self.channelLabel.text = @"频道推荐";
    self.channelLabel.font = compileLabel.font;
    self.channelLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upFranmeArr[self.upFranmeArr.count-1].CGRectValue) + 5, self.backgroundView.frame.size.width, 100-btnH);
    [self.backgroundView addSubview:self.channelLabel];
    
    UILabel *clickAddLabel = [[UILabel alloc]init];
    clickAddLabel.text = @"点击添加频道";
    clickAddLabel.textColor = ISNightMode?kDarkFiveColor:kDarkNineColor;
    clickAddLabel.font = [UIFont systemFontOfSize:12.0f];
    clickAddLabel.frame = CGRectMake(80, 0, 100, self.channelLabel.height);
    [self.channelLabel addSubview:clickAddLabel];
    
    for (int j = 0; j < self.belowBtnDataArr.count; j ++) {
        int b = (j/self.btnNumber);
        UIButton *btn  = [self addBtnFrame:CGRectMake((j%self.btnNumber)*btnW+(j%self.btnNumber)*10, b*btnH + b*10 +  [self.upFranmeArr[self.upFranmeArr.count-1]CGRectValue].origin.y+compileLabel.frame.size.height*2, btnW, btnH)];
        
//        UIImageView *imageView = [UIImageView new];
//        imageView.image = [UIImage imageNamed:@"编辑加号"];
//        [btn addSubview:imageView];
//        imageView.sd_layout
//        .topEqualToView(btn).offset(-7)
//        .rightEqualToView(btn).offset(7)
//        .widthIs(14)
//        .heightIs(14);
        
        [btn addTarget:self action:@selector(clickBelowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:self.belowBtnDataArr[j] forState:UIControlStateNormal];
        [self.belowFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
        [self.belowBtn addObject:btn];
    }
    
    UIImageView *jianbian = [[UIImageView alloc]init];
    jianbian.image = [UIImage imageNamed:@"渐变"];
    jianbian.frame = CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50);
    [self addSubview:jianbian];
}


-(UIButton *)addBtnFrame:(CGRect)frame{
    UIButton *btn  = [[UIButton alloc]init];
//    btn.layer.borderWidth = 0.5;
//    btn.layer.borderColor = [UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1.0].CGColor;
    btn.layer.cornerRadius = 4;
//    btn.clipsToBounds = YES;
    btn.backgroundColor = ISNightMode?JSColor(@"191A1C"):JSColor(@"#F6F7FB");
    btn.frame = frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:self.btnTextFont];
    [btn setTitleColor:(ISNightMode?kDarkNineColor:kDarkOneColor) forState:UIControlStateNormal];
    [self.backgroundView addSubview:btn];
    
    UIImageView *militaryFork = [[UIImageView alloc]init];
    CGFloat width = 14;
    militaryFork.layer.masksToBounds = YES;
    militaryFork.frame = CGRectMake(btn.frame.size.width - width/2, - width/2, width, width);
    militaryFork.image = [UIImage imageNamed:@"closeLab"];
    militaryFork.hidden = YES;
    [btn addSubview:militaryFork];
    
    return btn;
}

- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender{
    if (!self.compileBtn.selected) {
        return;
    }
    UIView *view = paramSender.view;
    static  CGRect viewFrame;
    if (paramSender.state == UIGestureRecognizerStateBegan){
        [self.backgroundView insertSubview:view atIndex:self.backgroundView.subviews.count-1];
        viewFrame = view.frame;
        CGAffineTransform transform = CGAffineTransformScale(view.transform, 1.2f, 1.2f);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.0f];
        [view setTransform:transform];
        [UIView commitAnimations];
    }
    
    if (paramSender.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [paramSender locationInView:paramSender.view.superview];
        view.center = location;
        
        for (int i = 0; i < self.upBtn.count; i ++) {
            //涛哥更改:没有=1.
            if ((i == 0 || i == 1) && !self.IS_compileFirstBtn) continue;
            UIButton *btn = self.upBtn[i];
            if (btn == view)continue;
            if (CGRectContainsPoint(btn.frame,location)) {
                [self.upBtn removeObject:view];
                [self.upBtn insertObject:view atIndex:i];
                [UIView animateWithDuration:0.3 animations:^{
                    [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj != view) {
                            obj.frame = [self.upFranmeArr[idx] CGRectValue];
                        }else{
                            viewFrame = [self.upFranmeArr[idx] CGRectValue];
                        }
                        
                    }];
                }];
                
                break;
            }
        }
    }
    
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        view.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = viewFrame;
        }];
    }
}


//编辑
-(void)compileBtn:(UIButton *)btn{
    if (btn.selected) {
        NSMutableArray *upBtnText = [NSMutableArray array];
        [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (UIImageView *militaryFork in obj.subviews) {
                if ([militaryFork isKindOfClass:[UIImageView class]]) {
                    militaryFork.hidden = YES;
                }
            }
            [upBtnText addObject:obj.titleLabel.text];
        }];
        
        if (self.dataBlock) {
            self.dataBlock(upBtnText);
        }
    }else{
        
        [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (UIImageView *militaryFork in obj.subviews) {
                if ([militaryFork isKindOfClass:[UIImageView class]]) {
                    militaryFork.hidden = NO;
                    if (([obj.titleLabel.text isEqualToString:self.upBtnDataArr[0]] || [obj.titleLabel.text isEqualToString:@"关注"] || [obj.titleLabel.text isEqualToString:@"推荐"]) && !self.IS_compileFirstBtn) {
                        militaryFork.hidden = YES;
                    }
                }
            }
            
        }];
        
    }
    btn.selected = !btn.selected;
    if (btn.selected ==YES) {
        self.clickInLabel.text = @"拖拽可以排序";
    }else{
        self.clickInLabel.text = @"点击进入频道";
    }
}

//点击上btn
-(void)clickUpBtn:(UIButton *)btn{
    if (!self.compileBtn.selected) {
        //点击的不同位置
        if (btn.titleLabel.text) {
            _clickIndexBlock(btn.titleLabel.text);
        }
        return;
    }
    if (([btn.titleLabel.text isEqualToString:self.upBtnDataArr[0]] || [btn.titleLabel.text isEqualToString:@"关注"] || [btn.titleLabel.text isEqualToString:@"推荐"]) && !self.IS_compileFirstBtn) {
        return;
    }
    for (UIImageView *militaryFork in btn.subviews) {
        if ([militaryFork isKindOfClass:[UIImageView class]]) {
            militaryFork.hidden = YES;
        }
    }
 
    [btn removeTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];

    [btn removeGestureRecognizer:btn.gestureRecognizers[0]];
    
    [btn addTarget:self action:@selector(clickBelowBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self.upBtn removeObject:btn];
    [self.upFranmeArr removeObjectAtIndex:self.upFranmeArr.count-1];
    [self.belowBtn insertObject:btn atIndex:0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = self.upFranmeArr[idx].CGRectValue;
        }];
    }];
    
    [self.belowFranmeArr removeAllObjects];
    [UIView animateWithDuration:0.3 animations:^{
        [self.belowBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger j, BOOL * _Nonnull stop) {
            int b = ((int)j/self.btnNumber);
            obj.frame = CGRectMake((j%self.btnNumber)*btnW+(j%self.btnNumber)*10, b*btnH + b*10 +  [self.upFranmeArr[self.upFranmeArr.count-1]CGRectValue].origin.y+100, btnW, btnH);
            [self.belowFranmeArr addObject:[NSValue valueWithCGRect:obj.frame]];
        }];
    }];

    [UIView animateWithDuration:0.3 animations:^{
        self.channelLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upFranmeArr[self.upFranmeArr.count-1].CGRectValue), self.channelLabel.frame.size.width, self.channelLabel.frame.size.height);
    }];
}


//添加长按手势
-(void)addLongPress:(UIButton *)btn{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPressGestures:)];
    longPress.numberOfTouchesRequired = 1;
    longPress.allowableMovement = 100.0f;
    longPress.minimumPressDuration = 0.5;
    [btn addGestureRecognizer:longPress];
}

//点击下Btn
-(void)clickBelowBtn:(UIButton *)btn{
    if (self.compileBtn.selected) {
        for (UIImageView *militaryFork in btn.subviews) {
            if ([militaryFork isKindOfClass:[UIImageView class]]) {
                militaryFork.hidden = NO;
            }
        }
    }
    [btn removeTarget:self action:@selector(clickBelowBtn:) forControlEvents:UIControlEventTouchUpInside];
   
    [btn addTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];
  
    [self addLongPress:btn];
    
    [self.belowFranmeArr removeObjectAtIndex:self.belowFranmeArr.count-1];
    [self.belowBtn removeObject:btn];
    [self.upBtn addObject:btn];
    int i = (int)self.upBtn.count-1;
    int a = ((int)i/self.btnNumber);
    [UIView animateWithDuration:0.3 animations:^{
        btn.frame =  CGRectMake((i%self.btnNumber)*btnW+(i%self.btnNumber)*10, a*btnH + a*10, btnW, btnH);
        [self.upFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
        self.channelLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upFranmeArr[self.upFranmeArr.count-1].CGRectValue), self.channelLabel.frame.size.width, self.channelLabel.frame.size.height);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.belowBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int b = ((int)idx/self.btnNumber);
            CGRect btnFrame = self.belowFranmeArr[idx].CGRectValue;
            obj.frame = CGRectMake(btnFrame.origin.x,  b*btnH + b*10 +  [self.upFranmeArr[self.upFranmeArr.count-1]CGRectValue].origin.y+100, btnFrame.size.width, btnFrame.size.height);
        }];
    }];
    NSMutableArray *upTitleArray = [NSMutableArray array];
    for (UIButton *btn in self.upBtn) {
        [upTitleArray addObject:btn.titleLabel.text];
    }
    if (self.dataBlock) {
        self.dataBlock(upTitleArray);
    }
}



@end
