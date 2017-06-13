//
//  LBStoreProductDetailAddNumTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreProductDetailAddNumTableViewCell.h"

@implementation LBStoreProductDetailAddNumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.baseview.layer.cornerRadius = 3;
    self.baseview.clipsToBounds = YES;
    
    self.baseview.layer.borderWidth = 1;
    self.baseview.layer.borderColor = [UIColor grayColor].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
