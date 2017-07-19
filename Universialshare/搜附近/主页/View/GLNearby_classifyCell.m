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

@end

@implementation GLNearby_classifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = 5.f;
    self.picImageWidth.constant = 120 * autoSizeScaleX;

}
- (void)setModel:(GLNearby_NearShopModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/guangguang",model.store_pic]] placeholderImage:[UIImage imageNamed:MERCHAT_PlaceHolder]];

    self.nameLabel.text = model.shop_name;
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",model.shop_address];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话:%@",model.phone];
    self.numberLabel.text = [NSString stringWithFormat:@"销售额:¥ %@",model.total_money];
    
    if([model.limit floatValue] > 1000){
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",[model.limit floatValue]/1000];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"%@m",model.limit];
    }
    
}

@end
