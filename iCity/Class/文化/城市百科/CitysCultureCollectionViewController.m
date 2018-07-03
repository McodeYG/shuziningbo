//
//  CitysCultureCollectionViewController.m
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.





//===============================这个控制器没用了===================

#import "CitysCultureCollectionViewController.h"
#import "ICityCitiesCultureCollectionViewCell.h"


@interface CitysCultureCollectionViewController ()

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *dataArray;


@end

@implementation CitysCultureCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(kScreenWidth / 4.0, 85);
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (void)setParentID:(NSString *)parentID {
    _parentID = parentID;
    [self loadMenuDataWithTag:@"3" parentID:parentID];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collectionView.backgroundColor = kNightModeBackColor;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = kWhiteColor;
    [self.collectionView setCollectionViewLayout:self.layout];
    
    // Register cell classes
    [self.collectionView registerClass:[ICityCitiesCultureCollectionViewCell class] forCellWithReuseIdentifier:@"ICityCitiesCultureCollectionViewCell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ICityCitiesCultureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ICityCitiesCultureCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lifeCollectionMenuBlock) {
        NSString *url = [self.dataArray[indexPath.item] html];
        NSString *title = [self.dataArray[indexPath.item] name];
        self.lifeCollectionMenuBlock(title,url);
    }
}

- (void)loadMenuDataWithTag:(NSString * _Nonnull)tag parentID:(NSString * _Nullable)parentid {

//    NSDictionary *parameters = @{
//                                 @"tag":tag,
//                                 @"parentid":(parentid == nil ? @" " : parentid)
//                                 };
//
//    [[JstyleNewsNetworkManager shareManager] GETURL:Life_CateList_URL parameters:parameters success:^(id responseObject) {
//
//        if ([responseObject[@"code"] integerValue] == 1) {
//            self.dataArray = [NSArray modelArrayWithClass:[ICityKnowledgeBaseModel class] json:responseObject[@"data"]];
//        }
//        [self.collectionView reloadData];
//
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
}

@end
