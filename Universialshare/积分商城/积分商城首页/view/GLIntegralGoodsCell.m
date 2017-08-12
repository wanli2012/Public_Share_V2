
//
//  GLIntegralGoodsCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralGoodsCell.h"
#import "UIImageView+WebCache.h"

@interface GLIntegralGoodsCell()
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *pre_priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageviewWidth;

@end

@implementation GLIntegralGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self changeColor:self.jifenLabel rangeNumber:2666];
    self.imageV.layer.cornerRadius = 4;
    self.imageviewWidth.constant = 100 * autoSizeScaleX;
}


- (void)changeColor:(UILabel*)label rangeNumber:(NSInteger )rangeNum
{
    NSString *remainBeans;
    if (rangeNum > 10000) {
        remainBeans = [NSString stringWithFormat:@"%.0f",(float)rangeNum /10000];
    }else{
        remainBeans = [NSString stringWithFormat:@"%.0f",(float)rangeNum];
    }
    
    NSString *totalStr = [NSString stringWithFormat:@"%@/米券",remainBeans];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:remainBeans];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:rangel];
    [label setAttributedText:textColor];
}

- (void)setModel:(GLMall_InterestModel *)model{
    _model = model;
    
    [self changeColor:_jifenLabel rangeNumber:[model.discount integerValue]];
    _nameLabel.text = model.goods_name;
    
    _pre_priceLabel.text = [NSString stringWithFormat:@"%.0f/米券",[model.goods_price floatValue]];
    NSString  *floatStr = [NSString stringWithFormat:@"%.0f",[model.goods_price floatValue]];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:_pre_priceLabel.text];
    NSRange rangel = [_pre_priceLabel.text  rangeOfString:floatStr];
    [textColor addAttribute:NSForegroundColorAttributeName value:YYSRGBColor(121, 120, 120, 1) range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rangel];
    [_pre_priceLabel setAttributedText:textColor];

    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model.thumb]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
}

@end
