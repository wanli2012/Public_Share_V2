//
//  LBMineCenterMYOrderEvaluationDetailTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCStarRatingView.h"
#import "orderEvaluationModel.h"

@protocol LBMineCenterMYOrderEvaluationDetailDelegete <NSObject>

-(void)tapgestureshowmoreinfo:(NSInteger)index;
-(void)ishidekeyboard;
-(void)submitevaluationinfo:(NSInteger)index;

@end

@interface LBMineCenterMYOrderEvaluationDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *submitbt;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet LCStarRatingView *starview;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UILabel *limiteLb;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLb;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *sizelb;
@property (weak, nonatomic) IBOutlet UILabel *infilb;
@property (weak, nonatomic) IBOutlet UIImageView *underimage;

@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *moenyLb;

@property (weak, nonatomic) IBOutlet UIView *headview;
@property (assign, nonatomic)id<LBMineCenterMYOrderEvaluationDetailDelegete> delegete;
@property (assign, nonatomic)NSInteger index;
@property (strong, nonatomic)orderEvaluationModel *orderEvaluationModel;

@property (weak, nonatomic) IBOutlet UILabel *baseviewrepaly;
@property (weak, nonatomic) IBOutlet LCStarRatingView *baseviewstar;
@property (weak, nonatomic) IBOutlet UIView *baseview1;
@property (weak, nonatomic) IBOutlet UILabel *showlb;

@end
