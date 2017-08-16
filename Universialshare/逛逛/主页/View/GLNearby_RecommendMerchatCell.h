//
//  GLNearby_RecommendMerchatCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLNearby_RecommendMerchatCell : UITableViewCell

@property (nonatomic, strong)NSArray *models;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
