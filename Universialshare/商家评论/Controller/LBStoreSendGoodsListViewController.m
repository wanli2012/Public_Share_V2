//
//  LBStoreSendGoodsListViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreSendGoodsListViewController.h"
#import "LBIncomeChooseHeaderFooterView.h"
#import "LBStoreSendGoodsListFirstViewController.h"
#import "LBStoreSendGoodsSecondViewController.h"

@interface LBStoreSendGoodsListViewController ()<LBIncomeChooseHeaderdelegete>
@property (strong ,nonatomic)LBIncomeChooseHeaderFooterView *buttonview;
@property (strong, nonatomic)LBStoreSendGoodsListFirstViewController *fristVc;
@property (strong, nonatomic)LBStoreSendGoodsSecondViewController *secondVc;
@property (strong, nonatomic)UIViewController *currentVC;
@end

@implementation LBStoreSendGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单";
    [self.view addSubview:self.buttonview];
    
    self.fristVc = [[LBStoreSendGoodsListFirstViewController alloc] init];
    self.fristVc.view.frame = CGRectMake(0, 110, SCREEN_WIDTH, SCREEN_HEIGHT - 110);
    [self addChildViewController:_fristVc];
    
    self.secondVc = [[LBStoreSendGoodsSecondViewController alloc] init];
    self.secondVc.view.frame = CGRectMake(0, 110, SCREEN_WIDTH, SCREEN_HEIGHT - 110);
    [self addChildViewController:_secondVc];
    
    //设置默认控制器为fristVc
    self.currentVC = self.fristVc;
    [self.view addSubview:self.fristVc.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark ---  LBIncomeChooseHeaderdelegete 
//待发货
-(void)clickonlinebutton{

    [self replaceFromOldViewController:self.secondVc toNewViewController:self.fristVc];

}
//已发货
-(void)clickunderlinebutton{

    [self replaceFromOldViewController:self.fristVc toNewViewController:self.secondVc];
}

- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    /**
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController    当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options              动画效果(渐变,从下往上等等,具体查看API)UIViewAnimationOptionTransitionCrossDissolve
     *  animations            转换过程中得动画
     *  completion            转换完成
     */
    if (self.currentVC == newVc) {
        return;
    }
    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
            self.currentVC = newVc;
        }else{
            self.currentVC = oldVc;
        }
    }];
}


-(LBIncomeChooseHeaderFooterView*)buttonview{

    if (!_buttonview) {
        _buttonview = [[LBIncomeChooseHeaderFooterView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 45)];
        _buttonview.delegete = self;
    }
    
    return _buttonview;

}
@end
