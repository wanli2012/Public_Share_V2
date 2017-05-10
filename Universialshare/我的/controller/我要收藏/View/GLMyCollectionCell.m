//
//  GLMyCollectionCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMyCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLMyCollectionCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation GLMyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.clipsToBounds = YES;
}

//- (void)setModel:(GLMyCollectionModel *)model{
//    _model = model;
//    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
//    self.nameLabel.text = model.name;
//    self.detailLabel.text = model.detail;
//    self.priceLabel.text = model.price;
//}

@end
