//
//  GLClassifyView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLClassifyView.h"
#import "GLClassifyRecommendCell.h"
#import "GLClassifyHeaderView.h"

@interface GLClassifyView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign)NSInteger selectIndex;
@property (nonatomic, copy)NSString *chooseStr;
@property (nonatomic, strong)NSMutableArray *cellArr;

@end

static NSString *ID = @"GLClassifyRecommendCell";
@implementation GLClassifyView

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 64 - 40) / 3 , 30);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(0, SCREEN_HEIGHT / 4);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);//设置section的编距
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLClassifyRecommendCell" bundle:nil] forCellWithReuseIdentifier:ID];
    //注册头视图

    [self.collectionView registerNib:[UINib nibWithNibName:@"GLClassifyHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLClassifyHeaderView"];

    self.selectIndex = 0;
}
//确定
- (IBAction)ensureClick:(id)sender {
    
    for(int i = 0 ; i < self.classifyModels.count ; i++) {
        
        GLClassifyModel *model = self.classifyModels[i];
        
        if (model.isClicked) {
            
            self.block(_chooseStr);
            
            break;
        }
    }
}

//重置
- (IBAction)resetClick:(id)sender {

    [self chooseClassify:0];
    
}

- (void)chooseClassify:(NSInteger )index{
    
    GLClassifyModel *model = self.classifyModels[index];
    
    if (self.selectIndex == -1) {
        
        model.isClicked = !model.isClicked;
        self.selectIndex = index;
        
    }else{
        
        if (self.selectIndex == index) {
            
            return;
        }
        
        model.isClicked = !model.isClicked;
        GLClassifyModel *model1 = self.classifyModels[self.selectIndex];
        model1.isClicked = NO;
        
        self.selectIndex = index;
        
    }
    
    self.chooseStr = model.cate_id;
    [self.collectionView reloadData];

}
#pragma  UICollectionDelegate UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.classifyModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GLClassifyRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.classifyModels[indexPath.row];

    return  cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self chooseClassify:indexPath.row];

}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    GLClassifyHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLClassifyHeaderView"  forIndexPath:indexPath];

    
    return headView;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return CGSizeMake(self.frame.size.width, 40);
    }
    else {
        return CGSizeMake(0, 0);
    }
}

- (NSMutableArray *)cellArr{
    if (!_cellArr) {
        _cellArr = [NSMutableArray array];
    }
    return _cellArr;
}
@end
