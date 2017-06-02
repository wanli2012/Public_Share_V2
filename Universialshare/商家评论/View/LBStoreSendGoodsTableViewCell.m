//
//  LBStoreSendGoodsTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreSendGoodsTableViewCell.h"

@implementation LBStoreSendGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.layer.cornerRadius = 4;
    self.button.clipsToBounds = YES;
    
}
//发货
- (IBAction)sendGoodsEvent:(UIButton *)sender {
    
    [self.delegete clickSendGoods:self.indexRow];
}

@end
