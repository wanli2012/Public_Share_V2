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
   
    self.button.layer.shadowOpacity = 0.5;// 阴影透明度
    self.button.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    self.button.layer.shadowRadius = 3;// 阴影扩散的范围控制
    self.button.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    
}

@end
