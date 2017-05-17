//
//  GLRecommendStroe_RecordController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendStroe_RecordController.h"
#import "GLRecommendStore_RecordCell.h"
#import "GLRecommendStroe_RecordDateCell.h"

@interface GLRecommendStroe_RecordController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

static NSString *ID = @"GLRecommendStore_RecordCell";
static NSString *ID2 = @"GLRecommendStroe_RecordDateCell";
@implementation GLRecommendStroe_RecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"推店记录";
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [self.collectionView registerNib:[UINib nibWithNibName:ID2 bundle:nil] forCellWithReuseIdentifier:ID2];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLRecommendStore_RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = 0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.estimatedRowHeight = 11;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
//    GLRecommendStore_RecordCell *consumerVC = [[GLRecommendStore_RecordCell alloc] init];
//    [self.navigationController pushViewController:consumerVC animated:YES];
}

#pragma UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 24;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    GLRecommendStroe_RecordDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID2 forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];

    return cell;
    
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 50);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GLRecommendStroe_RecordDateCell *cell = (GLRecommendStroe_RecordDateCell *) [collectionView cellForItemAtIndexPath:indexPath];
    cell.bgView.backgroundColor = [UIColor greenColor];
    
}
@end
