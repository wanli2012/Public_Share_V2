//
//  LBMineCenterPayPagesViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterPayPagesViewController.h"
#import "LBMineCenterPayPagesTableViewCell.h"
#import "LBIntegralMallViewController.h"
#import "GLOrderPayView.h"
#import "GLSet_MaskVeiw.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"


@interface LBMineCenterPayPagesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView *_loadV;
    GLSet_MaskVeiw *_maskV;
    GLOrderPayView *_contentView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *sureBt;

@property (strong, nonatomic)  NSMutableArray *dataarr;
@property (strong, nonatomic)  NSMutableArray *selectB;
@property (assign, nonatomic)  NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *ordercode;
@property (weak, nonatomic) IBOutlet UILabel *orderMoney;
@property (weak, nonatomic) IBOutlet UILabel *orderMTitleLb;

@end

@implementation LBMineCenterPayPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"支付页面";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.selectIndex = -1;

    self.tableview.tableFooterView = [UIView new];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterPayPagesTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterPayPagesTableViewCell"];
    
    self.ordercode.text = self.order_sn;
    self.orderMoney.text = [NSString stringWithFormat:@"%.2f",[self.orderPrice floatValue]];

    if (self.payType == 1 || self.payType == 3) {
        self.orderMTitleLb.text = @"订单金额:";
        if (self.payType == 1) {
            self.orderType.text = @"消费订单";
        }else{
            self.orderType.text = @"面对面订单";
        }
        
    }else if(self.payType == 2){
        self.orderMTitleLb.text = @"订单米券:";
        self.orderType.text = @"米券订单";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRepuest:) name:@"input_PasswordNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Alipaysucess) name:@"Alipaysucess" object:nil];
    
    /**
     *微信支付成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
    /**
     *判断是否展示支付
     */
    [self isShowPayInterface];
    
}

-(void)isShowPayInterface{

    [NetworkManager requestPOSTWithURLStr:@"shop/getPayTypeIsCloseByConfig" paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            if ([responseObject[@"data"][@"alipay"] integerValue] == 1) {
                if (self.payType == 1 || self.payType == 3) {
                
                    [self.dataarr addObject:@{@"image":@"支付宝",@"title":@"支付宝支付"}];
                }
            }
            
            if ([responseObject[@"data"][@"mz_pay"] integerValue] == 1) {
                
                if (self.payType == 1 || self.payType == 3) {
                    
                     [self.dataarr addObject:@{@"image":@"余额",@"title":@"米子支付"}];
                }
            
            }
                
            if ([responseObject[@"data"][@"mq_pay"] integerValue] == 1) {
                
                if (self.payType == 2){
                    [self.dataarr addObject:@{@"image":@"支付米分",@"title":@"米券支付"}];
                }
            }
                
            if ([responseObject[@"data"][@"wechat"] integerValue] == 1) {
                
                if (self.payType == 1 || self.payType == 3) {
                    
                    [self.dataarr addObject:@{@"image":@"微信",@"title":@"微信支付"}];
                }
                
            }
            
            for (int i=0; i<_dataarr.count; i++) {
                
                [self.selectB addObject:@NO];
                
            }
            
            [self.tableview reloadData];
            
        }
        
    } enError:^(NSError *error) {
        
    }];

}

-(void)wxpaysucess{
    
    if(self.pushIndex == 1){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterPayPagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterPayPagesTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.payimage.image = [UIImage imageNamed:_dataarr[indexPath.row][@"image"]];
    cell.paytitile.text = _dataarr[indexPath.row][@"title"];
    
    if([self.dataarr[indexPath.row][@"title"] isEqualToString:@"米子支付"] || [self.dataarr[indexPath.row][@"title"] isEqualToString:@"米券支付"]){//米子
        if (self.payType == 1 || self.payType == 3) {
            
            cell.reuseScoreLabel.text  = [NSString stringWithFormat:@"剩余:%@",[UserModel defaultUser].ketiBean];
        }else{//米券
            cell.reuseScoreLabel.text  = [NSString stringWithFormat:@"剩余:%@",[UserModel defaultUser].mark];
        }
    }
    
    if ([self.selectB[indexPath.row]boolValue] == NO) {
        
        cell.selectimage.image = [UIImage imageNamed:@"支付未选中"];
    }else{
    
        cell.selectimage.image = [UIImage imageNamed:@"支付选中"];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectIndex == -1) {
        BOOL a=[self.selectB[indexPath.row]boolValue];
        [self.selectB replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!a]];
        self.selectIndex = indexPath.row;
        
    }else{
    
        if (self.selectIndex == indexPath.row) {
            return;
        }
        BOOL a=[self.selectB[indexPath.row]boolValue];
        [self.selectB replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!a]];
        [self.selectB replaceObjectAtIndex:self.selectIndex withObject:[NSNumber numberWithBool:NO]];
        self.selectIndex = indexPath.row;
    
    }
    
    [self.tableview reloadData];
}

- (void)dismiss{
    [_contentView.passwordF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    }completion:^(BOOL finished) {
        [_maskV removeFromSuperview];
    }];
}
- (IBAction)surebutton:(UIButton *)sender {
    
    if (![self.selectB containsObject:@(YES)]){
        [MBProgressHUD showError:@"请选择支付方式"];
        return;
    }
    
    if ((self.payType == 1 || self.payType == 2 || self.payType == 3)  && ([self.dataarr[self.selectIndex][@"title"] isEqualToString:@"米子支付"] || [self.dataarr[self.selectIndex][@"title"] isEqualToString:@"米券支付"])) {
        CGFloat contentViewH = 300;
        CGFloat contentViewW = SCREEN_WIDTH;
        _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskV.bgView.alpha = 0.4;
        _contentView = [[NSBundle mainBundle] loadNibNamed:@"GLOrderPayView" owner:nil options:nil].lastObject;
        [_contentView.backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _contentView.layer.cornerRadius = 4;
        _contentView.layer.masksToBounds = YES;
        _contentView.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.orderPrice];
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, contentViewW, 0);
        [_maskV showViewWithContentView:_contentView];
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.frame = CGRectMake(0, SCREEN_HEIGHT - contentViewH, contentViewW, contentViewH);
            [_contentView.passwordF becomeFirstResponder];
        }];
    }else{
    
         if ([self.dataarr[self.selectIndex][@"title"] isEqualToString:@"支付宝支付"]){
            //支付宝支付
            [self alipay:@"1"];
        }else{
            //微信支付
            [self WeChatPay:@"2"];
            
        }
    
    }
    
 
}
- (void)ricePay:(NSNotification *)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    
    NSString *orderID = [NSString stringWithFormat:@"%@_%@_%@",self.order_sh,self.order_id,self.order_sn];
    //    NSString *uid = [RSAEncryptor encryptString:[UserModel defaultUser].uid publicKey:public_RSA];
    //    dict[@"uid"] = uid;
    dict[@"order_id"] = [RSAEncryptor encryptString:orderID publicKey:public_RSA];
    
    if (self.selectIndex == 0) {
        
        dict[@"type"] = @4;
    }else{
        dict[@"type"] = @4;
    }
    dict[@"uid"] = [UserModel defaultUser].uid;
//    dict[@"order_id"] = self.order_id;
    dict[@"password"] = [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
    [NetworkManager requestPOSTWithURLStr:@"shop/ricePayCoupons" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];

        if ([responseObject[@"code"] integerValue] == 1){

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hidesBottomBarWhenPushed = YES;
                if(self.pushIndex == 1){
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [MBProgressHUD showSuccess:responseObject[@"message"]];
                });
                self.hidesBottomBarWhenPushed = NO;
            });
            
        }else{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:responseObject[@"message"]];
            });
            
        }
        [self dismiss];
    } enError:^(NSError *error) {
         [MBProgressHUD showError:error.localizedDescription];
        [_loadV removeloadview];
        
    }];

}
- (void)integralPay:(NSNotification *)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    
    //    NSString *orderID = [RSAEncryptor encryptString:self.orderNum publicKey:public_RSA];
    //    NSString *uid = [RSAEncryptor encryptString:[UserModel defaultUser].uid publicKey:public_RSA];
    //    dict[@"uid"] = uid;
    //    dict[@"order_id"] = orderID;
    
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"order_id"] = self.order_id;
    dict[@"password"] = [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
    
    [NetworkManager requestPOSTWithURLStr:@"shop/markPay" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        [self dismiss];

        if ([responseObject[@"code"] integerValue] == 1){

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hidesBottomBarWhenPushed = YES;
                if(self.pushIndex == 1){
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [MBProgressHUD showSuccess:responseObject[@"message"]];
                self.hidesBottomBarWhenPushed = NO;
            });
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
        [_loadV removeloadview];
        
    }];

}

- (void)WeChatPay:(NSString *)payType{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"order_id"] = self.order_id;
    dict[@"paytype"] = payType;
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/payParam" paramDic:dict finish:^(id responseObject) {
        
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
        [MBProgressHUD showError:error.localizedDescription];
        [_loadV removeloadview];
        
    }];
}

- (void)alipay:(NSString *)payType{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"order_id"] = self.order_id;
    dict[@"paytype"] = payType;
    
    [NetworkManager requestPOSTWithURLStr:@"shop/payParam" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self dismiss];
        if ([responseObject[@"code"] integerValue] == 1){
            
            [ [AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"][@"url"] fromScheme:@"univerAlipay" callback:^(NSDictionary *resultDic) {
                
                NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                if (orderState==9000) {
                    self.hidesBottomBarWhenPushed = YES;
                    if(self.pushIndex == 1){
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    self.hidesBottomBarWhenPushed = NO;
                    
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
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
        [_loadV removeloadview];
        
    }];
}

//支付宝客户端支付成功之后 发送通知
-(void)Alipaysucess{
    
    self.hidesBottomBarWhenPushed = YES;
    if(self.pushIndex == 1){
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
    
}
//支付请求
- (void)postRepuest:(NSNotification *)sender {

    if (self.payType == 2) {
        
        //米劵支付(米分)
        [self integralPay:sender];
        
    }else{
        
        if (self.selectIndex == 0) {
            
            //米子支付
            [self ricePay:sender];
            
        }
    }
  
}

-(NSMutableArray*)dataarr{

    if (!_dataarr) {
   
        _dataarr = [NSMutableArray array];
    }

    return _dataarr;
}

-(NSMutableArray*)selectB{

    if (!_selectB) {
        _selectB=[NSMutableArray array];
    }
    
    return _selectB;

}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.sureBt.layer.cornerRadius = 4;
    self.sureBt.clipsToBounds = YES;

}

@end
