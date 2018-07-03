//
//  JstyleNewsImagePickerViewController.m
//  JstyleNews
//
//  Created by JingHongMuYun on 2018/1/30.
//  Copyright © 2018年 JstyleNews. All rights reserved.
//

#import "JstyleNewsImagePickerViewController.h"

@interface JstyleNewsImagePickerViewController ()

@end

@implementation JstyleNewsImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NightModeManager defaultManager].nightView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NightModeManager defaultManager].nightView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
