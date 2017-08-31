//
//  GLMyHeartController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMyHeartController.h"
#import "GLThreePersentController.h"
#import "GLSixPersentController.h"
#import "GLTwelevePersentController.h"
#import "GLTweleveFourController.h"

@interface GLMyHeartController ()

{
    UIButton *_tmpBtn;
}

@property (nonatomic, strong)GLThreePersentController *threePersentVC;
@property (nonatomic, strong)GLSixPersentController *sixPersentVC;
@property (nonatomic, strong)GLTwelevePersentController *twelvePercentVC;
@property (nonatomic, strong)GLTweleveFourController *twentyfourPercentVC;
@property (nonatomic, strong)UIViewController *currentViewController;
@property (nonatomic, strong)UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UIButton *twelveBtn;
@property (weak, nonatomic) IBOutlet UIButton *twelveFourBtn;

@property (weak, nonatomic) IBOutlet UIButton *threeBtn;

@property (nonatomic, strong)UIButton *currentButton;

@property (nonatomic,strong)NSMutableArray *models;

@end

@implementation GLMyHeartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的米分";
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor=[UIColor whiteColor];

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    [self.view addSubview:self.contentView];
    
    [self addChildViewController:self.threePersentVC];
    [self addChildViewController:self.sixPersentVC];
    [self addChildViewController:self.twelvePercentVC];
    [self addChildViewController:self.twentyfourPercentVC];
    
//    self.currentViewController = _sixPersentVC;
//    [self fitFrameForChildViewController:_sixPersentVC];
//    [self.contentView addSubview:_sixPersentVC.view];

    [self buttonEvent:self.sixBtn];
    
       
}
//- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
//    CGRect frame = self.contentView.frame;
//    frame.origin.y = 0;
//    childViewController.view.frame = frame;
//}

//百分之六激励
- (IBAction)buttonEvent:(UIButton *)sender {

    [self.sixBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.twelveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.twelveFourBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.threeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    if (sender == self.sixBtn) {

        [self.contentView addSubview:self.sixPersentVC.view];
//        [self transitionFromVC:self.currentViewController toviewController:_sixPersentVC];
//        [self fitFrameForChildViewController:_sixPersentVC];
        
    }else if (sender == self.twelveBtn){

        [self.contentView addSubview:self.twelvePercentVC.view];
//        [self transitionFromVC:self.currentViewController toviewController:_twelvePercentVC];
//        [self fitFrameForChildViewController:_twelvePercentVC];
        
    }else if(sender == self.twelveFourBtn){

        [self.contentView addSubview:self.twentyfourPercentVC.view];
//        [self transitionFromVC:self.currentViewController toviewController:_twentyfourPercentVC];
//        [self fitFrameForChildViewController:_twentyfourPercentVC];
        
    }else{
        
        [self.contentView addSubview:self.threePersentVC.view];
//        [self transitionFromVC:self.currentViewController toviewController:_threePersentVC];
//        [self fitFrameForChildViewController:_threePersentVC];
        
    }
}


//- (void)transitionFromVC:(UIViewController *)viewController toviewController:(UIViewController *)toViewController {
//    
//    if ([toViewController isEqual:self.currentViewController]) {
//        return;
//    }
//    [self transitionFromViewController:viewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionCurveLinear animations:nil completion:^(BOOL finished) {
//        [viewController willMoveToParentViewController:nil];
//        [toViewController willMoveToParentViewController:self];
//        self.currentViewController = toViewController;
//    }];
//}

- (GLThreePersentController*)threePersentVC{
    if (!_threePersentVC) {
        _threePersentVC = [[GLThreePersentController alloc] init];
    }
    return _threePersentVC;
}
- (GLSixPersentController *)sixPersentVC{
    if (!_sixPersentVC) {
        _sixPersentVC = [[GLSixPersentController alloc] init];
    }
    return _sixPersentVC;
}
- (GLTwelevePersentController *)twelvePercentVC{
    if (!_twelvePercentVC) {
        _twelvePercentVC = [[GLTwelevePersentController alloc] init];
    }
    return _twelvePercentVC;
}
- (GLTweleveFourController *)twentyfourPercentVC{
    if (!_twentyfourPercentVC) {
        _twentyfourPercentVC = [[GLTweleveFourController alloc] init];
    }
    return _twentyfourPercentVC;
}
@end
