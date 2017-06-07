//
//  GLNearby_MerchatListCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_MerchatListCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLNearby_MerchatListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;

@end

@implementation GLNearby_MerchatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.picImageV.layer.cornerRadius = 5.f;
    self.mapBtn.layer.cornerRadius = 5.f;
    
}
- (IBAction)mapToHere:(id)sender {
    if ([self.delegate respondsToSelector:@selector(mapTo:)]) {
        [self.delegate mapTo:self.index];
    }
}

- (void)setModel:(GLNearby_MerchatListModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.store_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    if (self.picImageV.image == nil) {
        self.picImageV.image = [UIImage imageNamed:PlaceHolderImage];
    }
    self.nameLabel.text = model.shop_name;
    self.adressLabel.text = [NSString stringWithFormat:@"地址:%@",model.shop_address];
    self.phoneNumLabel.text = [NSString stringWithFormat:@"电话:%@", model.phone];
    
    self.contentLabel.text = [NSString stringWithFormat:@"销售额:¥ %@",model.total_money];
    if ([model.limit floatValue] > 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2fKm", [model.limit floatValue] / 1000];

    }else{
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%@m", model.limit];
    }
    
}

@end
