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
#import <SDWebImage/UIImageView+WebCache.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

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
@property (nonatomic, strong)NSDictionary *dataDic;

@end

@implementation LBPayTheBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"支付";
    self.payType = 0;
    self.modelType = 0;
    _dataDic = [NSDictionary dictionary];
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:self.pic] placeholderImage:[UIImage imageNamed:@"商户暂位图"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRepuest:) name:@"input_PasswordNotification" object:nil];
    /**
     *支付宝支付成功
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"Alipaysucess" object:nil];
    /**
     *微信支付成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
    
    self.namelb.text = self.namestr;
    
    self.moneytf.placeholder = [NSString stringWithFormat:@"最多可消费¥%@",self.surplusLimit];
    
    [self isShowPayInterface];
}

-(void)isShowPayInterface{
    
    [NetworkManager requestPOSTWithURLStr:@"shop/getPayTypeIsCloseByConfig" paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            self.dataDic = responseObject[@"data"];
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}


-(void)wxpaysucess{
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
- (IBAction)ensurePay:(id)sender {
    
    if (self.moneytf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写支付金额"];
        return;
    }
    if (self.payType == 0) {
        [MBProgressHUD showError:@"请选择支付类型"];
        return;
    }
    if (self.modelType == 0) {
        [MBProgressHUD showError:@"请选择奖金模式"];
        return;
    }
    
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    if (self.payType == 1) {//支付宝
        [self ricePay:nil];
    }else if (self.payType == 2) {//微信支付
        [self WeChatPay:@"2"];
    }else if (self.payType == 4) {//米子支付
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
    
        //米子支付
        [self ricePay:sender];
    
}

- (void)WeChatPay:(NSString *)payType{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"shop_uid"] = self.shop_uid;
    dict[@"type"] = [NSString stringWithFormat:@"%zd",self.payType]; //支付方式: 1 支付宝 2 微信 4:米子
    dict[@"price"] = self.moneytf.text;//价格
    dict[@"remark"] = self.infoTf.text;//备注
    dict[@"rl_type"] = [NSString stringWithFormat:@"%zd",self.modelType];//让利模式 1:20%  2:10%  3:5%
    dict[@"version"] = @"3";//版本 3:Ios
   // dict[@"pwd"] =  [RSAEncryptor encryptString:@"" publicKey:public_RSA];

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/faceToFacePay" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self dismiss];
        if ([responseObject[@"code"] integerValue] == 1){
            //调起微信支付
            PayReq* req = [[PayReq alloc] init];
            req.openID=responseObject[@"data"][@"weixinpay"][@"appid"];
            req.partnerId = responseObject[@"data"][@"weixinpay"][@"partnerid"];
            req.prepayId = responseObject[@"data"][@"weixinpay"][@"prepayid"];
            req.nonceStr = responseObject[@"data"][@"weixinpay"][@"noncestr"];
            req.timeStamp = [responseObject[@"data"][@"weixinpay"][@"timestamp"] intValue];
            req.package = responseObject[@"data"][@"weixinpay"][@"package"];
            req.sign = responseObject[@"data"][@"weixinpay"][@"sign"];
            [WXApi sendReq:req];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];
}


- (void)ricePay:(NSNotification *)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"shop_uid"] = self.shop_uid;
    dict[@"type"] = [NSString stringWithFormat:@"%zd",self.payType]; //支付方式: 1 支付宝 2 微信 4:米子
    dict[@"price"] = self.moneytf.text;//价格
    dict[@"remark"] = self.infoTf.text;//备注
    dict[@"rl_type"] = [NSString stringWithFormat:@"%zd",self.modelType];//让利模式 1:20%  2:10%  3:5%
    dict[@"version"] = @"3";//版本 3:Ios

    dict[@"pwd"] =  [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"shop/faceToFacePay" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
           
            if (self.payType == 1) {
                
                [ [AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"][@"url"] fromScheme:@"univerAlipay" callback:^(NSDictionary *resultDic) {
                    
                    NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                    if (orderState==9000) {
                        
                        [MBProgressHUD showError:@"支付成功"];

                    }else{
                        NSString *returnStr;
                        switch (orderState) {
                            case 8000:
                                returnStr=@"订单正在处理中";
                                break;
                            case 4000:
                                returnStr=@"订单支付失败";
                                break;
                            case 6001:
                                returnStr=@"订单取消";
                                break;
                            case 6002:
                                returnStr=@"网络连接出错";
                                break;
                                
                            default:
                                break;
                        }
                        
                        [MBProgressHUD showError:returnStr];
                        
                    }
                    
                }];
                
            }else if (self.payType == 2){
            
            }else if (self.payType == 4){
                 [MBProgressHUD showError:@"支付成功"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",responseObject[@"message"]]];

        [self dismiss];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self dismiss];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

- (IBAction)tapgestureMethod:(UITapGestureRecognizer *)sender {
    if (self.dataDic.count <= 0) {
         TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"暂无支付方式"];
        TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
   
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"请选择支付方式"];
    if ([self.dataDic[@"mz_pay"] integerValue] == 1) {
        [alertView addAction:[TYAlertAction actionWithTitle:@"米子支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            self.methodTf.text = action.title;
            self.payType = 4;
        }]];
    }
    if ([self.dataDic[@"alipay"] integerValue] == 1) {
        [alertView addAction:[TYAlertAction actionWithTitle:@"支付宝支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            self.methodTf.text = action.title;
            self.payType = 1;
            
        }]];
    }

    if ([self.dataDic[@"wechat"] integerValue] == 1) {
        [alertView addAction:[TYAlertAction actionWithTitle:@"微信支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            self.methodTf.text = action.title;
            self.payType = 2;
        }]];
    }
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {

    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)tapgesturemodel:(UITapGestureRecognizer *)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"请选择奖金模式"];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"3%" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        self.modelTf.text = action.title;
        self.modelType = [KThreePersent integerValue];
    }]];
    
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
