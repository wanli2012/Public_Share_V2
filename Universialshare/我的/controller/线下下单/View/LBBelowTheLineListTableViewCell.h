//
//  LBBelowTheLineListTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBBelowTheLineListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *modelLb;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *moenyLb;
@property (weak, nonatomic) IBOutlet UILabel *numLb;

@end
