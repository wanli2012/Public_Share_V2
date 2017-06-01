//
//  LBPayTheBillViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/19.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBPayTheBillViewController.h"
#import "CommonMenuView.h"
#import "UIView+AdjustFrame.h"
#import "UIView+TYAlertView.h"
#import "GLSet_MaskVeiw.h"
#import "GLOrderPayView.h"

@interface LBPayTheBillViewController ()<UITextFieldDelegate>
{
    NSArray *_dataArray;
    LoadWaitView *_loadV;
    GLSet_MaskVeiw *_maskV;
    GLOrderPayView *_contentView;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (weak, nonatomic) IBOutlet UIButton *surebt;

@property (weak, nonatomic) IBOutlet UITextField *moneytf;
@property (weak, nonatomic) IBOutlet UITextField *methodTf;
@property (weak, nonatomic) IBOutlet UITextField *modelTf;
@property (weak, nonatomic) IBOutlet UITextField *infoTf;

@property (nonatomic, assign)NSInteger payType;
@property (nonatomic, assign)NSInteger modelType;


@end

@implementation LBPayTheBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"支付";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRepuest:) name:@"input_PasswordNotification" object:nil];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
- (IBAction)ensurePay:(id)sender {
    
//    if (![self.selectB containsObject:@(YES)]){
//        [MBProgressHUD showError:@"请选择支付方式"];
//        return;
//    }
    
    CGFloat contentViewH = 300;
    CGFloat contentViewW = SCREEN_WIDTH;
    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _maskV.bgView.alpha = 0.4;
    
    _contentView = [[NSBundle mainBundle] loadNibNamed:@"GLOrderPayView" owner:nil options:nil].lastObject;
    [_contentView.backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _contentView.layer.cornerRadius = 4;
    _contentView.layer.masksToBounds = YES;
    _contentView.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.moneytf.text];
    _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, contentViewW, 0);
    [_maskV showViewWithContentView:_contentView];
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT - contentViewH, contentViewW, contentViewH);
        [_contentView.passwordF becomeFirstResponder];
    }];

    
    
    
}
- (void)dismiss{
    
    [_contentView.passwordF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    }completion:^(BOOL finished) {
        [_maskV removeFromSuperview];
    }];
}

//支付请求
- (void)postRepuest:(NSNotification *)sender {
    
    if (self.payType == 1) {
        
        //支付宝支付
        
    }else if (self.payType == 2){
        //微信支付
        
    }else{
        //米子支付
        [self ricePay:sender];
        
    }
    
}

- (void)ricePay:(NSNotification *)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"shop_uid"] = self.shop_uid;
    dict[@"type"] = [NSString stringWithFormat:@"%lu",self.payType]; //支付方式: 1 支付宝 2 微信 3:米子
    dict[@"price"] = self.moneytf.text;//价格
    dict[@"remark"] = self.infoTf.text;//备注
    dict[@"rl_type"] = [NSString stringWithFormat:@"%lu",self.modelType];//让利模式 1:20%  2:10%  3:5%
    dict[@"version"] = @"3";//版本 3:Ios
    //    dict[@"crypt"] = @"";
    dict[@"pwd"] =  [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];;
    
    NSLog(@"dict = %@",dict);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"shop/faceToFacePay" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
           
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        [MBProgressHUD showError:responseObject[@"message"]];

    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    
}

- (IBAction)tapgestureMethod:(UITapGestureRecognizer *)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"请选择支付方式"];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"微信支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
          self.methodTf.text = action.title;
        self.payType = 2;
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"支付宝支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
          self.methodTf.text = action.title;
        self.payType = 1;
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"米子支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
           self.methodTf.text = action.title;
        self.payType = 3;
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {

    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (IBAction)tapgesturemodel:(UITapGestureRecognizer *)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"请选择奖金模式"];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"5%" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        self.modelTf.text = action.title;
        self.modelType = 3;
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"10%" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        self.modelTf.text = action.title;
        self.modelType = 2;
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"20%" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        self.modelTf.text = action.title;
        self.modelType = 1;
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
  
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
    
   
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.infoTf && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;

}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.surebt.layer.cornerRadius = 4;
    self.surebt.clipsToBounds = YES;
    
    self.baseview.layer.cornerRadius = 4;
    self.baseview.clipsToBounds = YES;

    self.contentH.constant = 510;
    self.contentW.constant = SCREEN_WIDTH;

}
@end
