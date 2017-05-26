//
//  LBMySalesmanListTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMySalesmanListTableViewCell.h"

@interface LBMySalesmanListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *tgLabel;
@property (weak, nonatomic) IBOutlet UILabel *gtLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueNameLabel;

@end

@implementation LBMySalesmanListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.imagev.layer.cornerRadius = 35;
    self.imagev.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureimage:)];
    [self.imagev addGestureRecognizer:tap];
    
}

- (void)tapgestureimage:(UITapGestureRecognizer *)sender {
    
    if (self.returntapgestureimage) {
        self.returntapgestureimage(self.index);
    }
}

- (void)setModel:(GLMySalesmanModel *)model{
    
    _model = model;
    self.IDLabel.text=[NSString stringWithFormat:@"用户ID:%@",model.username];
    self.tgLabel.text=[NSString stringWithFormat:@"推广员:%@个",model.djtg];
    self.gtLabel.text=[NSString stringWithFormat:@"高级推广员:%@个",model.gjtg];
    self.shopNumLabel.text=[NSString stringWithFormat:@"商家:%@家",model.shop];
    self.addTimeLabel.text=[NSString stringWithFormat:@"推荐时间:%@",model.addtime];
    self.trueNameLabel.text=[NSString stringWithFormat:@"真实姓名:%@",model.truename];

}

@end
