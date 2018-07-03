//
//  RepositoryCollectionViewController.m
//  iCity
//
//  Created by mayonggang on 2018/6/14.
//  Copyright © 2018年 LongYuan. All rights reserved.
//

#import "RepositoryCollectionViewController.h"
#import "RepositoryCollectionViewCell.h"
#import "ICityKnowledgeBaseModel.h"


@interface RepositoryCollectionViewController ()

@property (nonatomic, assign) NSInteger cell_count;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation RepositoryCollectionViewController

static NSString *const RepositoryCollectionViewCellID = @"RepositoryCollectionViewCellID";


- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake((kScreenWidth-40)/3.0, (kScreenWidth-40)*70/3.0/112);
        _layout.minimumLineSpacing = 14.5;//竖直方向
        _layout.minimumInteritemSpacing = 9.5;//水平方向
        _layout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (void)setPid:(NSString *)pid {
    _pid = pid;
    [self loadMenuDataWithTag:@"3" parentID:pid];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collectionView.backgroundColor = kNightModeBackColor;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = kWhiteColor;
    [self.collectionView setCollectionViewLayout:self.layout];
    
    
    [self.collectionView registerClass:[RepositoryCollectionViewCell class] forCellWithReuseIdentifier:RepositoryCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RepositoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RepositoryCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.item < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lifeCollectionMenuBlock) {
        NSString *selectID = [self.dataArray[indexPath.item] id];
        
        NSString *title = [self.dataArray[indexPath.item] name];
        self.lifeCollectionMenuBlock(title,selectID);
        
    }
}

- (void)loadMenuDataWithTag:(NSString * _Nonnull)tag parentID:(NSString * _Nullable)parentid {
    
    if ([_pid isNotBlank]) {
        
        NSDictionary *parameters = @{
                                     @"field_type":@"2",
                                     @"level":@"2",
                                     @"pid":_pid  };
        [[JstyleNewsNetworkManager shareManager] GETURL:Read_Mediafield_URL parameters:parameters success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 1) {
                self.dataArray = [NSArray modelArrayWithClass:[ICityKnowledgeBaseModel class] json:responseObject[@"data"]];
            }
            [self.collectionView reloadData];
            if (self.refreshBlock&&self.cell_count!=self.dataArray.count) {
                
                self.refreshBlock(self.dataArray.count);
            }
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
   
}


@end
