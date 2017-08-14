//
//  GLNearby_classifyCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLNearby_NearShopModel.h"
#import "LBRecomendShopModel.h"

@interface GLNearby_classifyCell : UITableViewCell


@property (nonatomic, strong)GLNearby_NearShopModel *model;

@property (nonatomic, strong)LBRecomendShopModel *shopmodel;

@end
