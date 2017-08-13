
//
//  GLIntegralGoodsCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "LBIntegralGoodsCollectionViewCell.h"

@interface GLIntegralGoodsCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

static NSString *ID = @"LBIntegralGoodsCollectionViewCell";
@implementation GLIntegralGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
     [self.collectionview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
   
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate clickcheckDetail:indexPath.item];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 26)/2, (SCREEN_WIDTH - 26)/2 + 50);
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 0, 10);
}



@end
