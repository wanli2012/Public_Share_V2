
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
@property (weak, nonatomic) IBOutlet UIButton *panicBuyingBtn;
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
    self.panicBuyingBtn.layer.cornerRadius = 5.f;
    self.panicBuyingBtn.clipsToBounds = YES;
    [self changeColor:self.jifenLabel rangeNumber:2666];
    self.imageV.layer.cornerRadius = 4;
    self.imageviewWidth.constant = 120 * autoSizeScaleX;
}


- (void)changeColor:(UILabel*)label rangeNumber:(NSInteger )rangeNum
{
    NSString *remainBeans;
    if (rangeNum > 10000) {
        remainBeans = [NSString stringWithFormat:@"%.2f",(float)rangeNum /10000];
    }else{
        remainBeans = [NSString stringWithFormat:@"%zd",rangeNum];
    }
    
    NSString *totalStr = [NSString stringWithFormat:@"%@ 米券",remainBeans];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:remainBeans];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:rangel];
    [label setAttributedText:textColor];
}
- (IBAction)buy:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buyNow:)]) {
        [self.delegate buyNow:self.index];
    }
}

- (void)setModel:(GLMall_InterestModel *)model{
    _model = model;
    
    [self changeColor:_jifenLabel rangeNumber:[model.discount integerValue]];
    _nameLabel.text = model.goods_name;
    
    if([model.goods_price floatValue] > 10000){
         _pre_priceLabel.text = [NSString stringWithFormat:@"%.2f米券",[model.goods_price floatValue]/10000];
    }else{
        _pre_priceLabel.text = [NSString stringWithFormat:@"%@ 米券",model.goods_price];
    }
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model.thumb]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
}

@end
