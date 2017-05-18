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

@end


@implementation GLNearby_classifyCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
- (void)setModel:(GLNearby_NearShopModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.store_pic] placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
    if (self.picImageV.image == nil) {
        self.picImageV.image = [UIImage imageNamed:@"XRPlaceholder"];
    }
    self.nameLabel.text = model.shop_name;
    self.addressLabel.text = model.shop_address;
    self.phoneLabel.text = model.phone;
    self.numberLabel.text = model.total_money;
}

@end
