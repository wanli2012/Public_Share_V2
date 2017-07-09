//
//  GLNearby_RecommendMerchatCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_RecommendMerchatCell.h"
#import "GLNearby_RecommendMerchatCollectionCell.h"
#import "LBStoreMoreInfomationViewController.h"
#import "GLNearbyViewController.h"

@interface GLNearby_RecommendMerchatCell ()<UICollectionViewDelegate,UICollectionViewDataSource>


@end

static NSString *ID = @"GLNearby_RecommendMerchatCollectionCell";
@implementation GLNearby_RecommendMerchatCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];

}
- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[GLNearbyViewController class]]) {
            return (GLNearbyViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma UICollectionViewDelegete UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.models.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLNearby_RecommendMerchatCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewFlowLayout *layout;
//    layout = (UICollectionViewFlowLayout *)collectionViewLayout;
//    layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH / 3, 130);
    
    return CGSizeMake(SCREEN_WIDTH / 3, SCREEN_WIDTH / 3 + 26);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self viewController].hidesBottomBarWhenPushed = YES;
    if (indexPath.row < self.models.count) {
        
        LBStoreMoreInfomationViewController *store = [[LBStoreMoreInfomationViewController alloc] init];
        
        [[self viewController].navigationController pushViewController:store animated:YES];
        store.lat = [[GLNearby_Model defaultUser].latitude floatValue];
        store.lng = [[GLNearby_Model defaultUser].longitude floatValue];
        GLNearby_NearShopModel *model = self.models[indexPath.row];
        store.storeId = model.shop_id;
    }
    
    [self viewController].hidesBottomBarWhenPushed = NO;

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat jx=0.0f;
    return jx;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat jx=0.0f;
    return jx;
}
@end
