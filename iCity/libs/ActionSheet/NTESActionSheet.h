//
//  NTESActionSheet.h
//  NTESActionSheet
//
//  Created by LEA on 15/9/28.
//  Copyright © 2015年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESActionSheetDelegate;
@interface NTESActionSheet : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *_tableView;
    UIView          *_sheetView;
    UIView          *_alphaView;
}

@property (nonatomic, weak) id<NTESActionSheetDelegate> delegate;
@property (nonatomic, assign) NSInteger cancelButtonIndex;
@property (nonatomic, assign) NSInteger destructiveButtonIndex;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *destructiveButtonTitle;
@property (nonatomic, strong) NSMutableArray *otherButtonTitles;
@property (nonatomic, readonly) NSInteger numberOfButtons;

- (NTESActionSheet *)initWithTitle:(NSString *)title delegate:(id<NTESActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

- (void)showInView:(UIView *)view;

@end


@protocol NTESActionSheetDelegate <NSObject>
@optional

- (void)actionSheet:(NTESActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
