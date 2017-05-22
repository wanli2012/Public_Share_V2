//
//  GLNearby_RecommendMerchatCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_RecommendMerchatCell.h"
#import "GLNearby_RecommendMerchatCollectionCell.h"

@interface GLNearby_RecommendMerchatCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

static NSString *ID = @"GLNearby_RecommendMerchatCollectionCell";
@implementation GLNearby_RecommendMerchatCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];

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
    
    return CGSizeMake(SCREEN_WIDTH / 3, 130);
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
