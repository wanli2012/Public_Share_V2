//
//  GLIncomeManagerCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIncomeManagerCell.h"

@interface GLIncomeManagerCell()
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@end

@implementation GLIncomeManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(GLIncomeManagerModel *)model {
    _model = model;
    self.nameLabel.text = model.shop_name;
    self.addressLabel.text = model.shop_address;
    
    if ([model.total_money floatValue] > 10000) {
        
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f万元",[model.total_money floatValue]/10000];
    }else{
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"%@元",model.total_money ];
    }
}
@end
