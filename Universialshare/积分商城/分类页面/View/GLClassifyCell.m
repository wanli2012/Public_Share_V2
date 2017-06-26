//
//  GLClassifyCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLClassifyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface GLClassifyCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;

@end

@implementation GLClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageViewHeight.constant = 142.5 * autoSizeScaleY;
}
- (void)setModel:(GLintegralGoodsModel *)model {
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    _nameLabel.text = model.goods_name;
    _priceLabel.text = [NSString stringWithFormat:@"%@米券",model.goods_price];
}
@end
