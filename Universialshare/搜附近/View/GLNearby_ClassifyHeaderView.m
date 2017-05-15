//
//  GLNearby_ClassifyHeaderView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_ClassifyHeaderView.h"
#import "GLNearby_ClassifyConcollectionCell.h"

@interface GLNearby_ClassifyHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

static NSString *ID = @"GLNearby_ClassifyConcollectionCell";
@implementation GLNearby_ClassifyHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        /* 添加子控件的代码*/
        self.backgroundColor = YYSRGBColor(184, 184, 184, 0.2);
        [self addSubview:self.collectionView];
        [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height - 10);
}
#pragma UICollectionViewDelegete UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    GLNearby_ClassifyConcollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.titleLabel.text = self.dataSource[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH /4, 30);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GLNearby_ClassifyConcollectionCell *cell = (GLNearby_ClassifyConcollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.block(cell.titleLabel.text);
    cell.bgView.backgroundColor = YYSRGBColor(40, 150, 58, 1);
    cell.titleLabel.textColor = [UIColor whiteColor];
    if(indexPath.row == self.dataSource.count){
        
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLNearby_ClassifyConcollectionCell *cell = (GLNearby_ClassifyConcollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bgView.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.textColor = [UIColor darkGrayColor];

}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
         NSArray *arr = [NSArray arrayWithObjects:@"美食",@"美酒",@"美女",@"7天",@"宜家",@"KTV",@"台球",@"网吧", nil];
        [_dataSource addObjectsFromArray:arr];

    }
    return _dataSource;
}
@end
