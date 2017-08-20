//
//  GLNearby_classifyCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_classifyCell.h"
#import "GLNearby_ClassifyConcollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLNearby_classifyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *surpluslimitLb;

@end

@implementation GLNearby_classifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = 3.f;
    self.picImageWidth.constant = 100 ;

}
- (void)setModel:(GLNearby_NearShopModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/guangguang",model.store_pic]] placeholderImage:[UIImage imageNamed:MERCHAT_PlaceHolder]];

    self.nameLabel.text = model.shop_name;
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",model.shop_address];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话:%@",model.phone];
    self.numberLabel.text = [NSString stringWithFormat:@"今日销售额:¥%@",model.today_money];
     self.surpluslimitLb.text =@"";
    
    if([model.limit floatValue] > 1000){
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",[model.limit floatValue]/1000];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"%@m",model.limit];
    }
    
    if ([self.phoneLabel.text rangeOfString:@"null"].location != NSNotFound) {
        self.phoneLabel.text = @"电话:暂无";
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.numberLabel.text];
    NSRange range = [self.numberLabel.text rangeOfString:model.today_money];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                            NSFontAttributeName:[UIFont systemFontOfSize:13]} range:range];//添加属性
    [self.numberLabel setAttributedText:attStr];
    
}

-(void)setShopmodel:(LBRecomendShopModel *)shopmodel{
    _shopmodel = shopmodel;

    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/guangguang",_shopmodel.pic]] placeholderImage:[UIImage imageNamed:MERCHAT_PlaceHolder]];
    
    self.nameLabel.text = _shopmodel.shop_name;
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",_shopmodel.shop_address];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话:%@",_shopmodel.corporation_phone];
    self.numberLabel.text = [NSString stringWithFormat:@"今日销售额:¥%@",_shopmodel.today_money];
    self.surpluslimitLb.text =@"";
    
    self.distanceLabel.hidden = YES;
    
    if ([self.phoneLabel.text rangeOfString:@"null"].location != NSNotFound) {
        self.phoneLabel.text = @"电话:暂无";
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.numberLabel.text];
    NSRange range = [self.numberLabel.text rangeOfString:_shopmodel.today_money];
    [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                            NSFontAttributeName:[UIFont systemFontOfSize:13]} range:range];//添加属性
    [self.numberLabel setAttributedText:attStr];
}

@end
