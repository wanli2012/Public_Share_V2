//
//  LBIntegralGoodsCollectionViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMall_InterestModel.h"

@interface LBIntegralGoodsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;

@property (nonatomic, strong)GLMall_InterestModel *model;

@end
