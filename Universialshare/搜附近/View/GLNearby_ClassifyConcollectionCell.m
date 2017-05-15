//
//  GLNearby_ClassifyConcollectionCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_ClassifyConcollectionCell.h"

@interface GLNearby_ClassifyConcollectionCell ()


@end

@implementation GLNearby_ClassifyConcollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.layer.borderColor = YYSRGBColor(184, 184, 184, 0.2).CGColor;
    self.bgView.clipsToBounds = YES;
}

@end
