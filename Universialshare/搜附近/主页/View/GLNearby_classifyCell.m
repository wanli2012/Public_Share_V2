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
//"uid": "430",
//"shop_name": "wqwq",
//"store_pic": "https://www.51dztg.com/index.php/Uploads/Store/images/2017/05/09/1494313915a49fe8914df0eada4d4b7d530d7fa5ba.jpg",
//"shop_id": "403",
//"shop_address": "bfdhfghfghf",
//"total_money": "0.00",
//"lng": "104.104523",
//"lat": "30.653295",
//"phone": "15823261652"
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
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.store_pic] placeholderImage:[UIImage imageNamed:MERCHAT_PlaceHolder]];

    self.nameLabel.text = model.shop_name;
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",model.shop_address];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话:%@",model.phone];
    self.numberLabel.text = [NSString stringWithFormat:@"销售额:¥ %@",model.total_money];
    
    if([model.limit floatValue] > 1000){
        
        self.distanceLabel.text = [NSString stringWithFormat:@"< %.2fKm",[model.limit floatValue]/1000];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"< %@m",model.limit];
    }
    
}

@end
