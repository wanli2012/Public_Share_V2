//
//  LBMineCenterReceivingGoodsTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterReceivingGoodsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LBWaitOrdersListModel.h"

@implementation LBMineCenterReceivingGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.buyBt.layer.borderWidth = 1;
//    self.buyBt.layer.borderColor = YYSRGBColor(191, 0, 0, 1).CGColor;
//    
//    self.SeeBt.layer.borderWidth = 1;
//    self.SeeBt.layer.borderColor = YYSRGBColor(191, 0, 0, 1).CGColor;
    
    self.sureSend.layer.cornerRadius = 4;
    self.sureSend.clipsToBounds = YES;
}

-(void)setWaitOrdersListModel:(LBWaitOrdersListModel *)WaitOrdersListModel{

    if (_WaitOrdersListModel != WaitOrdersListModel) {
        _WaitOrdersListModel = WaitOrdersListModel;
    }
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_WaitOrdersListModel.image_cover] placeholderImage:[UIImage imageNamed:@""]];
    self.cartype.text = [NSString stringWithFormat:@"%@",_WaitOrdersListModel.goods_name];
    self.numlb.text = [NSString stringWithFormat:@"数量:x%@",_WaitOrdersListModel.goods_num];
    self.pricelb.text = [NSString stringWithFormat:@"价格:¥%@",_WaitOrdersListModel.goods_price];
    self.storename.text = [NSString stringWithFormat:@"店名:%@",_WaitOrdersListModel.shop_name];
    
    if ([_WaitOrdersListModel.is_receipt isEqualToString:@"0"]) {//未收货
        [self.sureSend setTitle:@"确认收货" forState:UIControlStateNormal];
        self.sureSend.backgroundColor = TABBARTITLE_COLOR;
        self.sureSend.userInteractionEnabled = YES;
    }else if ([_WaitOrdersListModel.is_receipt isEqualToString:@"2"]){// 未发货
        [self.sureSend setTitle:@"未发货" forState:UIControlStateNormal];
        self.sureSend.backgroundColor = [UIColor redColor];
        self.sureSend.userInteractionEnabled = NO;
    }else if ([_WaitOrdersListModel.is_receipt isEqualToString:@"1"]){// 已收货
        [self.sureSend setTitle:@"已收货" forState:UIControlStateNormal];
        self.sureSend.backgroundColor = [UIColor grayColor];
        self.sureSend.userInteractionEnabled = NO;
    }

}


- (IBAction)buyevent:(UIButton *)sender {
    
    [self.delegete BuyAgaingoodid:_WaitOrdersListModel.orderGoodsId  orderid:self.order_id indexpath:self.indexpath];
}

//
//- (IBAction)SeeEvent:(UIButton *)sender {
//    
//    [self.delegete checklogistics:self.index];
//    
//}



@end
