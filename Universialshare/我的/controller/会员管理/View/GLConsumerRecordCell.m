//
//  GLConsumerRecordCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLConsumerRecordCell.h"

@interface GLConsumerRecordCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumerSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumerDateLabel;


@end

@implementation GLConsumerRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLMemberConsumerModel *)model{
    _model = model;
    self.nameLabel.text = model.goods_name;
    self.priceLabel.text = model.fh_price;
    self.consumerSumLabel.text = model.total_price;
    self.consumerDateLabel.text = model.addtime;
}
@end
