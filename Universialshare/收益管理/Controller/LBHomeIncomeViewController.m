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
#import "LBApplicationLimitView.h"

@interface LBHomeIncomeViewController ()

@property (strong, nonatomic)LBHomeIncomeFristViewController *fristVc;
@property (strong, nonatomic)LBHomeIncomesecondViewController *secondVc;
@property (strong, nonatomic)UIViewController *currentVC;

@property (assign, nonatomic)BOOL firstBool;
@property (assign, nonatomic)BOOL secondBool;
@property (weak, nonatomic) IBOutlet UIButton *chooseBt;
@property (strong, nonatomic)LoadWaitView *loadV;

@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)LBApplicationLimitView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *applyBt;

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
    
    UITapGestureRecognizer *maskvgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskviewgesture)];
    [self.maskView addGestureRecognizer:maskvgesture];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([[UserModel defaultUser].isapplication isEqualToString:@"1"]) {
       
        [self.applyBt setTitle:@"申请中..." forState:UIControlStateNormal];
        self.applyBt.userInteractionEnabled = NO;
    }else{
        [self.applyBt setTitle:@"申请额度" forState:UIControlStateNormal];
        self.applyBt.userInteractionEnabled = YES;
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
//申请额度
- (IBAction)applyMoneny:(UIButton *)sender {
    
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.loginView];
    
}
//确认申请
-(void)sureapplication{
    
    if (self.loginView.phoneTf.text .length <= 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (self.loginView.yzmTf.text .length <= 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    if (self.loginView.moneyTF.text .length <= 0) {
        [MBProgressHUD showError:@"请输入申请额度"];
        return;
    }
    
    if ([self.loginView.moneyTF.text  floatValue] <= [[UserModel defaultUser].allLimit floatValue]) {
         [MBProgressHUD showError:@"输入大于当前额度"];
        return;
    }

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/applyMoreSaleMoney" paramDic:@{@"yzm":self.loginView.yzmTf.text,
                                                                                @"uid":[UserModel defaultUser].uid ,
                                                                                @"token":[UserModel defaultUser].token,
                                                                                @"userphone":self.loginView.phoneTf.text,
                                                                                @"money":self.loginView.moneyTF.text  } finish:^(id responseObject)
     {
         
         [_loadV removeloadview];
         
         if ([responseObject[@"code"] integerValue]==1) {
             [self maskviewgesture];
             [self.applyBt setTitle:@"申请中..." forState:UIControlStateNormal];
             self.applyBt.userInteractionEnabled = NO;
             [UserModel defaultUser].isapplication = @"1";
             [usermodelachivar achive];
             [MBProgressHUD showError:responseObject[@"message"]];
         }else{
             [MBProgressHUD showError:responseObject[@"message"]];
         }
         
     } enError:^(NSError *error) {
         [_loadV removeloadview];
         [MBProgressHUD showError:error.localizedDescription];
         
     }];


}

//点击maskview
-(void)maskviewgesture{
    
    [self.maskView removeFromSuperview];
    [self.loginView removeFromSuperview];
    
}

//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.loginView.yzmbt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.loginView.yzmbt.userInteractionEnabled = YES;
                self.loginView.yzmbt.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                self.loginView.yzmbt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loginView.yzmbt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.loginView.yzmbt.userInteractionEnabled = NO;
                self.loginView.yzmbt.backgroundColor = YYSRGBColor(184, 184, 184, 1);
               self.loginView.yzmbt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (void)getcode:(UIButton *)sender {
    
    if (self.loginView.phoneTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.loginView.phoneTf.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"user/get_yzm" paramDic:@{@"phone":self.loginView.phoneTf.text} finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {

    }];
    
}


-(LBApplicationLimitView*)loginView{
    
    if (!_loginView) {
        _loginView=[[NSBundle mainBundle]loadNibNamed:@"LBApplicationLimitView" owner:self options:nil].firstObject;
        _loginView.frame=CGRectMake(20, (SCREEN_HEIGHT - 230)/2, SCREEN_WIDTH-40, 230);
        _loginView.alpha=1;
        _loginView.layer.cornerRadius = 4;
        _loginView.clipsToBounds = YES;
        [_loginView.yzmbt addTarget:self action:@selector(getcode:) forControlEvents:UIControlEventTouchUpInside];
         [_loginView.cancelBt addTarget:self action:@selector(maskviewgesture) forControlEvents:UIControlEventTouchUpInside];
         [_loginView.sureBt addTarget:self action:@selector(sureapplication) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginView;
    
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];
        
    }
    return _maskView;
    
}

@end
