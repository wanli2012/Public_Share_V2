//
//  GLIncomeManagerCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLIncomeManagerModel.h"

@interface GLIncomeManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, strong)GLIncomeManagerModel *model;
@end
