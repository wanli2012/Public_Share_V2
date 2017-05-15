//
//  LBProductManagementTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LBProductManagementDelegete <NSObject>

-(void)LBProductManagementButtonOne:(NSInteger)index;
-(void)LBProductManagementButtonTwo:(NSInteger)index;

@end

@interface LBProductManagementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UIImageView *imageT;
@property (weak, nonatomic) IBOutlet UILabel *modelLb;

@property (weak, nonatomic) IBOutlet UILabel *productNameLb;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UIView *editView;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerXconstant;

@property (assign, nonatomic) NSInteger rowIndex;
@property (assign, nonatomic) id<LBProductManagementDelegete> delegete;

@end
