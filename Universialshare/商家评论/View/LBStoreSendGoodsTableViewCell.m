//
//  LBStoreSendGoodsTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreSendGoodsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LBStoreSendGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.layer.cornerRadius = 4;
    self.button.clipsToBounds = YES;
    
}
//发货
- (IBAction)sendGoodsEvent:(UIButton *)sender {
    
    [self.delegete clickSendGoods:self.indexpath name:_WaitOrdersListModel.user_name];
}

-(void)setWaitOrdersListModel:(LBSendGoodsProductModel *)WaitOrdersListModel{
    _WaitOrdersListModel = WaitOrdersListModel;

    self.codelb.text = [NSString stringWithFormat:@"%@",_WaitOrdersListModel.goods_name];
    self.pricelb.text = [NSString stringWithFormat:@"x%@  ¥%@",_WaitOrdersListModel.goods_num,_WaitOrdersListModel.goods_price];
   self.namelb.text = [NSString stringWithFormat:@"%@",_WaitOrdersListModel.goods_info];
    self.phonelb.text = [NSString stringWithFormat:@"tel: %@",_WaitOrdersListModel.phone];
    self.timelb.text = [NSString stringWithFormat:@"消费者: %@",_WaitOrdersListModel.user_name];
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_WaitOrdersListModel.thumb] placeholderImage:[UIImage imageNamed:@"熊"]];
    
    if ([_WaitOrdersListModel.is_receipt isEqualToString:@"3"]) {
        self.button.backgroundColor = [UIColor grayColor];
        [self.button setTitle:@"已发货" forState:UIControlStateNormal];
        self.button.userInteractionEnabled = NO;
    }else if ([_WaitOrdersListModel.is_receipt isEqualToString:@"2"]){
        self.button.backgroundColor = TABBARTITLE_COLOR;
        self.button.userInteractionEnabled = YES;
        [self.button setTitle:@"发货" forState:UIControlStateNormal];
    }
}
@end
