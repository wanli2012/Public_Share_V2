//
//  LBProductManagementTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBProductManagementTableViewCell.h"

@implementation LBProductManagementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.buttonOne.layer.cornerRadius = 4;
    self.buttonOne.clipsToBounds = YES;
    
    self.buttonTwo.layer.cornerRadius = 4;
    self.buttonTwo.clipsToBounds = YES;
}

- (IBAction)buttonOneEvent:(UIButton *)sender {
    
    [self.delegete LBProductManagementButtonOne:self.rowIndex];
}

- (IBAction)buttonTwoEvent:(UIButton *)sender {
    
    [self.delegete LBProductManagementButtonTwo:self.rowIndex];
}


@end
