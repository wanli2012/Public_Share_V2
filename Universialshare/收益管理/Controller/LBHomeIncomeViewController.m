//
//  LBHomeIncomeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeIncomeViewController.h"
#import "LBHomeIncomeFristViewController.h"
#import "LBHomeIncomesecondViewController.h"

@interface LBHomeIncomeViewController ()

@property (strong, nonatomic)LBHomeIncomeFristViewController *fristVc;
@property (strong, nonatomic)LBHomeIncomesecondViewController *secondVc;
@property (strong, nonatomic)UIViewController *currentVC;

@property (assign, nonatomic)BOOL firstBool;
@property (assign, nonatomic)BOOL secondBool;
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;


@end

@implementation LBHomeIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.fristVc = [[LBHomeIncomeFristViewController alloc] init];
    self.fristVc.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    [self addChildViewController:_fristVc];
    
    self.secondVc = [[LBHomeIncomesecondViewController alloc] init];
    self.secondVc.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    [self addChildViewController:_secondVc];
    
    //设置默认控制器为fristVc
    self.currentVC = self.fristVc;
    [self.view addSubview:self.fristVc.view];
    
    self.firstBool = NO;
    self.secondBool =NO;
}

- (IBAction)segmentEvent:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.chooseBt.selected = self.firstBool;
            [self replaceFromOldViewController:self.secondVc toNewViewController:self.fristVc];
            break;
        case 1:
            self.chooseBt.selected = self.secondBool;
            [self replaceFromOldViewController:self.fristVc toNewViewController:self.secondVc];
            break;
        default:
            break;
    }
    
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


- (IBAction)searchEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.currentVC == self.fristVc) {
        self.firstBool = sender.selected;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LBHomeIncomeFristViewController" object:nil userInfo:@{@"show":[NSNumber numberWithBool:sender.selected]}];
    }else{
        self.secondBool = sender.selected;
      [[NSNotificationCenter defaultCenter]postNotificationName:@"LBHomeIncomesecondViewController" object:nil userInfo:@{@"show":[NSNumber numberWithBool:sender.selected]}];
    }
    
}


@end
