//
//  GLHourseDetailFirstCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHourseDetailFirstCell.h"

@interface GLHourseDetailFirstCell()
{
    NSString *_price;
}

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanliLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthSellLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation GLHourseDetailFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLGoodsDetailModel *)model{
    _model = model;

    _fanliLabel.text = [NSString stringWithFormat:@"现价:%.2f米券",[model.rebate floatValue]];

    _priceLabel.text = [NSString stringWithFormat:@"¥%@米券",model.money];
    _monthSellLabel.text = [NSString stringWithFormat:@"月销%@笔",model.sell_count];
    _yunfeiLabel.text = [NSString stringWithFormat:@"运费:%@元",model.posttage];
    
    if ([_priceLabel.text rangeOfString:@"null"].location != NSNotFound) {
        _priceLabel.text = [NSString stringWithFormat:@"¥0.00米券"];
    }
    if ([_monthSellLabel.text rangeOfString:@"null"].location != NSNotFound) {
        _monthSellLabel.text = [NSString stringWithFormat:@"月销0笔"];
    }
    if ([_yunfeiLabel.text rangeOfString:@"null"].location != NSNotFound) {
        _yunfeiLabel.text = [NSString stringWithFormat:@"运费:0.00元"];
    }
    
    NSMutableString *attrStr = [NSMutableString string];
    
    for (int i = 0; i < model.attr.count; i ++) {
        [attrStr appendFormat:@" %@",model.attr[i]];
    }
    NSString *strone = [NSString stringWithFormat:@"[%@]",attrStr];
    long len1 = [strone length];
    NSString *strtwo = [NSString stringWithFormat:@"[%@] %@",attrStr,model.goods_info];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:strtwo];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,len1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0,len1)];
    
    if(attrStr.length <= 0){
        _nameLabel.text = model.goods_info;
    }else{
        
        _nameLabel.attributedText = str;
    }
//    _nameLabel.text = model.goods_info;
}

@end
