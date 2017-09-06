//
//  GLMine_RicePayController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/8/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_RicePayController.h"
#import "LBMineCenterPayPagesTableViewCell.h"
#import "LBIntegralMallViewController.h"
#import "GLOrderPayView.h"
#import "GLSet_MaskVeiw.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface GLMine_RicePayController ()
{
    LoadWaitView *_loadV;
    GLSet_MaskVeiw *_maskV;
//    GLOrderPayView *_contentView;
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

@property (nonatomic, assign)NSInteger paySituation;//1:米劵支付 2:米劵+米子  3:米劵+微信 4:米劵+支付宝 5:米子支付 6:微信支付 7:支付宝
@property (nonatomic, strong)GLOrderPayView *contentView;

@end

@implementation GLMine_RicePayController

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
    
    self.orderMTitleLb.text = @"订单米券:";
    self.orderType.text = @"米券订单";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRepuest:paySituation:) name:@"input_PasswordNotification" object:nil];
    
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
    
    [self.dataarr addObject:@{@"image":@"支付积分",@"title":@"米券支付"}];
    [self.dataarr addObject:@{@"image":@"余额",@"title":@"米子支付"}];
    [self.dataarr addObject:@{@"image":@"微信",@"title":@"微信支付"}];
    [self.dataarr addObject:@{@"image":@"支付宝",@"title":@"支付宝支付"}];
    
    [self setPayType];
    
}

- (void)setPayType {

    //没有米劵
    if ([[UserModel defaultUser].mark floatValue] == 0.0) {
        
        for ( int i = 0 ; i < self.dataarr.count; i++) {
            [self.selectB addObject:@NO];
        }
        
    }else{
        
        [self.selectB addObject:@YES];
        
        if (self.dataarr.count <= 1) {
            return;
        }
        
        for ( int i = 1 ; i < self.dataarr.count; i++) {
            [self.selectB addObject:@NO];
        }
    }
}

-(void)wxpaysucess{
    
    [self.navigationController popToRootViewControllerAnimated:YES];

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

    if ([self.selectB[indexPath.row] boolValue] == NO) {
        
        cell.selectimage.image = [UIImage imageNamed:@"支付未选中"];
        
    }else{
        
        cell.selectimage.image = [UIImage imageNamed:@"支付选中"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //米劵足够
    if ([self.orderPrice floatValue] < [[UserModel defaultUser].mark floatValue]) {
        [MBProgressHUD showError:@"请优先使用米劵"];
        return;
    }
    
    //米劵不足
    if ([self.orderPrice floatValue] > [[UserModel defaultUser].mark floatValue]) {
        
        //米子不足
        if(([self.orderPrice floatValue] - [[UserModel defaultUser].mark floatValue]) > [[UserModel defaultUser].ketiBean floatValue]){
            
            if (indexPath.row == 1) {
                
                [MBProgressHUD showError:@"米子不足"];
                
                return;
                
            }else if(indexPath.row == 2 || indexPath.row == 3){
                
                [self choosePayType:indexPath.row];

            }
        }else{//米子足够

            [self choosePayType:indexPath.row];
        
        }
    }
    //没有米劵
    if ([[UserModel defaultUser].mark floatValue] == 0) {
        if (indexPath.row == 0 ) {
            [MBProgressHUD showError:@"米劵为0,请选择其他支付方式"];
            return;
            
        }else if(indexPath.row == 1 && [self.orderPrice floatValue] > [[UserModel defaultUser].ketiBean floatValue]){//米子不足
            [MBProgressHUD showError:@"米子不足,请选择其他支付方式"];
            return;
            
        }else{
            
            [self choosePayType:indexPath.row];
        }
    }
    
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableview reloadData];
    
}

- (void)choosePayType:(NSInteger )index {
    
    if (self.selectIndex == -1) {
        
        BOOL a=[self.selectB[index] boolValue];
        [self.selectB replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!a]];
        self.selectIndex = index;
        
    }else{
        
        if (self.selectIndex == index) {
            return;
        }
        
        BOOL a=[self.selectB[index]boolValue];
        [self.selectB replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!a]];
        [self.selectB replaceObjectAtIndex:self.selectIndex withObject:[NSNumber numberWithBool:NO]];
        self.selectIndex = index;
        
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
//确定支付
- (IBAction)surebutton:(UIButton *)sender {
    
    //判断选中了几中支付方式
    int yesNum = 0;
    
    for (int i = 0; i < self.selectB.count; i++) {
        
        if ([self.selectB[i] boolValue]) {
            yesNum += 1;
        }
    }
    
    if ([[UserModel defaultUser].mark floatValue] == 0) {//米劵为0
        if (self.selectIndex == 1) {
          
            self.paySituation = 5;
            
        }else if(self.selectIndex == 2){
   
            self.paySituation = 6;
            
        }else if(self.selectIndex == 3){
   
            self.paySituation = 7;
        }
        
    }else{//米劵不为0
        
        if([self.orderPrice floatValue] <= [[UserModel defaultUser].mark floatValue]){//米劵支付
   
            self.paySituation = 1;
            
        }else if([self.orderPrice floatValue] > [[UserModel defaultUser].mark floatValue]){
            
            if (yesNum < 2){
                
                [MBProgressHUD showError:@"米劵不足,请再选择一种支付方式"];
                
                return;
            }
            
            if (self.selectIndex == 1) {
                
                self.paySituation = 2;
                
            }else if(self.selectIndex == 2){

                self.paySituation = 3;
                
            }else{

                self.paySituation = 4;
                
            }
        }
    }
    
    switch (self.paySituation) {
        case 1: case 5://米劵支付 米子支付
        {
            [self popSecretView];//弹出密码输入框
            
        }
            break;
        case 2: case 3: case 4:
        {
            NSString *str = [NSString stringWithFormat:@"米券不足的部分将用米子或现金1:1补足,本次需要补足金额为:%.2f",[self.orderPrice floatValue] - [[UserModel defaultUser].mark floatValue]];
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self popSecretView];//弹出密码输入框
                
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alertVC addAction:ok];
            [alertVC addAction:cancel];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
            break;
        case 6://微信支付
        {
            [self postRepuest:nil paySituation:self.paySituation];
        }
            break;
        case 7://支付宝支付
        {
            [self postRepuest:nil paySituation:self.paySituation];
        }
            break;
            
        default:
            break;
    }
}

//支付请求
- (void)postRepuest:(NSNotification *)sender paySituation:(NSInteger )paySituation{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"orderId"] = self.order_id;
    dict[@"order_id"] =[RSAEncryptor encryptString:[NSString stringWithFormat:@"%@_%@_%@",self.order_sh,self.order_id,self.order_sn] publicKey:public_RSA];
    dict[@"version"] = @3;
    
//    dict[@"order_id"] = [NSString stringWithFormat:@"%@_%@_%@",self.order_sh,self.order_id,self.order_sn];
    
    switch (self.paySituation) {
        case 1://米劵支付
        {
 
            dict[@"is_rmb"] = @0;
            dict[@"is_mark"] = @3;
            dict[@"password"] = [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
            
        }
            break;
        case 2://米劵+米子
        {

            dict[@"is_rmb"] = @0;
            dict[@"is_mark"] = @6;
            dict[@"password"] = [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];

        }
            break;
        case 3://米劵+微信
        {
            dict[@"pay_type"] = @2;
            dict[@"is_rmb"] = @1;
            dict[@"is_mark"] = @3;
            dict[@"password"] = [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
            
        }
            break;
        case 4://米劵+支付宝
        {
            dict[@"pay_type"] = @1;
            dict[@"is_rmb"] = @1;
            dict[@"is_mark"] = @3;
            dict[@"password"] = [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
            
        }
            break;
        case 5://米子
        {
            dict[@"is_rmb"] = @0;
            dict[@"is_mark"] = @4;
            dict[@"password"] = [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
            
        }
            break;
        case 6://微信
        {
            dict[@"pay_type"] = @2;
            dict[@"is_rmb"] = @1;
            dict[@"is_mark"] = @0;
            
        }
            break;
        case 7://支付宝
        {
            dict[@"pay_type"] = @1;
            dict[@"is_rmb"] = @1;
            dict[@"is_mark"] = @0;

        }
            break;
            
        default:
            break;
    }
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/getPayType" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self dismiss];
        
        if ([responseObject[@"code"] integerValue] == 1){
            
            switch (self.paySituation) {//没有现金
                case 1: case 2: case 5:
                {
                    [MBProgressHUD showError:responseObject[@"message"]];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                    break;
                    
                case 3: case 6://带有微信
                {
                    [MBProgressHUD showError:responseObject[@"message"]];
                    
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

                }
                    break;
                    
                case 4: case 7://带有支付宝
                {
                    [[AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"][@"url"] fromScheme:@"univerAlipay" callback:^(NSDictionary *resultDic) {
                        
                        NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                        if (orderState==9000) {
                            self.hidesBottomBarWhenPushed = YES;
                            
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
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
                   
                }
                    break;
                    
                default:
                    break;
            }

        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription];
        [_loadV removeloadview];
        
    }];
    
}

- (void)popSecretView{
    
    //弹出密码输入框
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

}

- (void)WeChatPay:(NSString *)payType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"order_id"] = self.order_id;
    dict[@"paytype"] = payType;
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/payParam" paramDic:dict finish:^(id responseObject) {
        
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
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/payParam" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self dismiss];
        if ([responseObject[@"code"] integerValue] == 1){
            
            [ [AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"][@"url"] fromScheme:@"univerAlipay" callback:^(NSDictionary *resultDic) {
                
                NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                if (orderState==9000) {
                    self.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                        
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
}


//- (void)pay:(NSNotification *)sender{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"token"] = [UserModel defaultUser].token;
//    dict[@"uid"] = [UserModel defaultUser].uid;
//    dict[@"is_rmb"] = @0;
//    dict[@"is_mark"] = @3;
//    dict[@"orderId"] = self.order_id;
////    dict[@"pay_type"] = ;
////    dict[@"order_id"] =[RSAEncryptor encryptString:[NSString stringWithFormat:@"%@_%@_%@",self.order_sh,self.order_id,self.order_sn] publicKey:public_RSA];
////    
////    dict[@"password"] = [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
//    
//    dict[@"order_id"] = [NSString stringWithFormat:@"%@_%@_%@",self.order_sh,self.order_id,self.order_sn];
//    dict[@"password"] = [sender.userInfo objectForKey:@"password"];
//    
//    
//    [NetworkManager requestPOSTWithURLStr:@"shop/getPayType" paramDic:dict finish:^(id responseObject) {
//        
//        [_loadV removeloadview];
//        [self dismiss];
//        
//        if ([responseObject[@"code"] integerValue] == 1){
//            
//                [MBProgressHUD showError:responseObject[@"message"]];
//        }else{
//            
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//        
//    } enError:^(NSError *error) {
//        [MBProgressHUD showError:error.localizedDescription];
//        [_loadV removeloadview];
//        
//    }];
//
//}

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
- (GLOrderPayView *)contentView{
    
    if (!_contentView) {
        

    }
    
    return _contentView;
}

@end
