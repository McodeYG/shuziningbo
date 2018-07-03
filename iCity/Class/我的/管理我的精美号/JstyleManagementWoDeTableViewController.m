//
//  JstyleManagementWoDeTableViewController.m
//  Exquisite
//
//  Created by 数字跃动 on 2017/10/11.
//  Copyright © 2017年 Jstyle. All rights reserved.
//

#import "JstyleManagementWoDeTableViewController.h"
#import "JstyleManagementWoDeCell.h"
#import "JstyleManagementMyMessageBaseViewController.h"
#import "JstyleManagementAccountInfoViewController.h"

static NSString *managementWoDeCellID = @"managementWoDeCellID";
@interface JstyleManagementWoDeTableViewController ()

@end

@implementation JstyleManagementWoDeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"JstyleManagementWoDeCell" bundle:nil] forCellReuseIdentifier:managementWoDeCellID];
    self.tableView.backgroundColor = ISNightMode?kNightModeBackColor:kWhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            //push进账号信息VC
            JstyleManagementAccountInfoViewController *jstyleManagerAccountInfoVC = [JstyleManagementAccountInfoViewController new];
            [self.navigationController pushViewController:jstyleManagerAccountInfoVC animated:YES];
        }
            break;
        case 1:{
            //push进消息中心VC
            JstyleManagementMyMessageBaseViewController *myMessageVC = [JstyleManagementMyMessageBaseViewController new];
            [self.navigationController pushViewController:myMessageVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46 * kScale;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JstyleManagementWoDeCell *cell = [tableView dequeueReusableCellWithIdentifier:managementWoDeCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.iconImageView.image = [UIImage imageNamed:@"账号"];
            cell.titleLabel.text = @"账号信息";
            break;
        case 1:
            cell.iconImageView.image = [UIImage imageNamed:@"消息中心"];
            cell.titleLabel.text = @"消息中心";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
