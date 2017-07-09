//
//  GLIntegralMallTopCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLIntegralMallTopCellDelegete <NSObject>

-(void)tapgestureTag:(UITapGestureRecognizer*)Tag;

@end

@interface GLIntegralMallTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (nonatomic, strong)NSArray *models;
@property (nonatomic, assign)id<GLIntegralMallTopCellDelegete> delegete;
@property (nonatomic, assign)NSInteger index;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsViewHeight;

@end
