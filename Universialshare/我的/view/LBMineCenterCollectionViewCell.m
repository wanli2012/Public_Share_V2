//
//  LBMineCenterCollectionViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterCollectionViewCell.h"

@implementation LBMineCenterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.baseView.layer.shadowOpacity = 0.5;// 阴影透明度
    self.baseView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    self.baseView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    self.baseView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    
    
 //   CALayer *layer = [CALayer layer];
//    layer.frame = self.baseView.frame;
//    layer.backgroundColor = [UIColor grayColor].CGColor;
//    layer.shadowOffset = CGSizeMake(2, 2);
//    layer.shadowOpacity = 0.5;
//    layer.cornerRadius = 3;
//    [self.baseView.layer addSublayer:layer];
//    
//    self.baseView.layer.masksToBounds =YES;
//    self.baseView.layer.cornerRadius =3;
    
}

@end
