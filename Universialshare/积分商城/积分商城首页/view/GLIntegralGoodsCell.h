//
//  GLIntegralGoodsCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMall_InterestModel.h"

@protocol GLIntegralGoodsCellDelegate <NSObject>

-(void)buyNow:(int)index;

@end

@interface GLIntegralGoodsCell : UITableViewCell

@property (nonatomic, strong)GLMall_InterestModel *model;

@property (nonatomic, assign)int index;

@property (nonatomic, assign)id<GLIntegralGoodsCellDelegate> delegate;

@end
