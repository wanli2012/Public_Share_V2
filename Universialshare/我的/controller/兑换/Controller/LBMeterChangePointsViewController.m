//
//  LBMeterChangePointsViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/7/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMeterChangePointsViewController.h"
#import "LBMeterChangePointsRecordViewController.h"
#import "QQPopMenuView.h"

@interface LBMeterChangePointsViewController (){

    LoadWaitView *_loadV;

}

@property (weak, nonatomic) IBOutlet UILabel *meterLb;
@property (weak, nonatomic) IBOutlet UITextField *meterTf;
@property (weak, nonatomic) IBOutlet UITextField *secretTf;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet UIButton *sureBT;
@property (strong, nonatomic)UIButton *buttonedt;
@property (weak, nonatomic) IBOutlet UITextField *typeTf;

@property (strong, nonatomic)NSArray *typeArr;
@property (strong, nonatomic)NSArray *methodArr;
@property (weak, nonatomic) IBOutlet UITextField *method;
@property (weak, nonatomic) IBOutlet UILabel *infoLb;

@property (assign, nonatomic)NSInteger typeIndex;
@property (assign, nonatomic)NSInteger methodIndex;

@end

@implementation LBMeterChangePointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"兑换";
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.typeArr = @[@{@"title":@"理财一",@"imageName":@""},
                     @{@"title":@"理财二",@"imageName":@""},  ];
    self.methodArr = @[@{@"title":@"T+1",@"imageName":@""},
                     @{@"title":@"T+2",@"imageName":@""}, @{@"title":@"T+2",@"imageName":@""} ];
    
    _buttonedt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
    [_buttonedt setTitle:@"记录" forState:UIControlStateNormal];
    [_buttonedt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _buttonedt.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonedt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonedt addTarget:self action:@selector(edtingInfo) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];

    self.meterLb.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].ketiBean floatValue]];
    self.infoLb.text = [NSString stringWithFormat:@" 1.理财一：兑换金额的70%%转换为积分，收取10%%服务费，20%%转化为米券\n 2.理财二：兑换金额的50%%转换为积分，收取10%%服务费，20%%转化为米券，20%%兑换为现金，同时收取对应的手续费\n 3.投资后米子和积分按1:5的比例返还积分\n 4.兑换米子数量至少为1000米子且为500的倍数 "] ;
    
}
- (IBAction)surebutton:(UIButton *)sender {
    
    if (self.secretTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入兑换米子"];
        return;
    }
    
    if ([self.meterTf.text floatValue] <1000) {
        [MBProgressHUD showError:@"至少兑换1000"];
        return;
    }
    
    if ([self.meterTf.text floatValue] > [self.meterLb.text floatValue]) {
        [MBProgressHUD showError:@"兑换米子超过可兑换米子"];
        return;
    }
    
    if ([self.meterTf.text integerValue] % 500  != 0) {
        [MBProgressHUD showError:@"兑换米子需是500的整数倍"];
        return;
    }
    
    if (self.secretTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if (self.secretTf.text.length != 6) {
        [MBProgressHUD showError:@"输入密码密码长度不对"];
        return;
    }
    
    if (self.typeTf.text.length <= 0) {
        [MBProgressHUD showError:@"请选择兑换类型"];
        return;
    }
    
    if (self.method.text.length <= 0) {
        [MBProgressHUD showError:@"请选择到账方式"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"typer"] = @(self.typeIndex);

    dict[@"num"] = self.meterTf.text;
    dict[@"IDcar"] = @"";
    dict[@"address"] = @"";
    dict[@"type"] = @(self.methodIndex);
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.typeTf.text publicKey:public_RSA];
    dict[@"password"] = encryptsecret;
   
    dict[@"donatetype"] = @"1";

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/back" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];

        if ([responseObject[@"code"] integerValue] == 1){

        }else{
        
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];

    }];

    
    
}

- (IBAction)tapgestureChooseType:(UITapGestureRecognizer *)sender {
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[sender.view convertRect: sender.view.bounds toView:window];
    
    __weak typeof(self) weakself = self;
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:self.typeArr
                              
                                                           width:120
                                                triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, rect.origin.y+20)
                                                          action:^(NSInteger index) {
                                                           
                                                              self.typeTf.text = weakself.typeArr[index][@"title"];
                                                              self.typeIndex = index + 2;
                                                           
                                                          }];
    
    popview.isHideImage = YES;
    
    [popview show];
}
//到账方式
- (IBAction)moneyMethod:(UITapGestureRecognizer *)sender {
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[sender.view convertRect: sender.view.bounds toView:window];
    
    __weak typeof(self) weakself = self;
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:self.methodArr
                              
                                                           width:120
                                                triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, rect.origin.y+20)
                                                          action:^(NSInteger index) {
                                                              
                                                              self.method.text = weakself.methodArr[index][@"title"];
                                                              self.methodIndex = index + 1;
                                                              
                                                          }];
    
    popview.isHideImage = YES;
    
    [popview show];
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.contentW.constant = SCREEN_WIDTH;
    self.contentH.constant = SCREEN_HEIGHT + 50;
    self.sureBT.layer.cornerRadius = 4;
    self.sureBT.clipsToBounds = YES;

}
//记录
-(void)edtingInfo{
    self.hidesBottomBarWhenPushed=YES;
    LBMeterChangePointsRecordViewController  *vc = [[LBMeterChangePointsRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}


@end
