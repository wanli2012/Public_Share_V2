//
//  LBIntegralGoodsCollectionViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBIntegralGoodsCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LBIntegralGoodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageV.layer.cornerRadius = 3;
    _imageV.clipsToBounds = YES;
}

- (void)setModel:(GLMall_InterestModel *)model{
    _model = model;
    
     _name.text = model.goods_name;
     [self changeColor:_price rangeNumber:[model.discount integerValue]];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model.thumb]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    _oldPrice.text = [NSString stringWithFormat:@"%@/米券",_model.goods_price];
    
}

- (void)changeColor:(UILabel*)label rangeNumber:(NSInteger )rangeNum
{
    NSString *remainBeans;
    if (rangeNum > 10000) {
        remainBeans = [NSString stringWithFormat:@"%.2f",(float)rangeNum /10000];
    }else{
        remainBeans = [NSString stringWithFormat:@"%zd",rangeNum];
    }
    
    NSString *totalStr = [NSString stringWithFormat:@"%@/米券",remainBeans];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:remainBeans];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:rangel];
    [label setAttributedText:textColor];
}
@end
