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

@interface LBMineCenterPayPagesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView *_loadV;
    GLSet_MaskVeiw *_maskV;
    GLOrderPayView *_contentView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *sureBt;

@property (strong, nonatomic)  NSArray *dataarr;
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

    if (self.payType == 1) {
        self.orderMTitleLb.text = @"订单金额:";
        self.orderType.text = @"消费订单";
    }else{
        self.orderMTitleLb.text = @"订单米券:";
        self.orderType.text = @"米券订单";
    }
    for (int i=0; i<_dataarr.count; i++) {
        
        [self.selectB addObject:@NO];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRepuest:) name:@"input_PasswordNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Alipaysucess) name:@"Alipaysucess" object:nil];
    
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
    
    if(indexPath.row == 0){//米子
        if (self.payType == 1) {
            
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
    
    if ((self.payType == 1 || self.payType == 2)  && self.selectIndex == 0) {
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
    
         if (self.selectIndex == 1){
            //支付宝支付
            [self alipayAndWeChatPay:@"1"];
        }else{
            //微信支付
            //[self alipayAndWeChatPay:@"2"];
            
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
            
            self.hidesBottomBarWhenPushed = YES;
            
            [MBProgressHUD showSuccess:responseObject[@"message"]];
            
            if(self.pushIndex == 1){
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            self.hidesBottomBarWhenPushed = NO;
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
         [self dismiss];
    } enError:^(NSError *error) {
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
            
            [MBProgressHUD showSuccess:responseObject[@"message"]];
            self.hidesBottomBarWhenPushed = YES;
            
            if(self.pushIndex == 1){
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            self.hidesBottomBarWhenPushed = NO;
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];

}

- (void)alipayAndWeChatPay:(NSString *)payType{
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
        
        //米劵支付(积分)
        [self integralPay:sender];
        
    }else{
        
        if (self.selectIndex == 0) {
            
            //米子支付
            [self ricePay:sender];
            
        }
    }
  
}

-(NSArray*)dataarr{

    if (!_dataarr) {
   
        if (self.payType == 1) {
            _dataarr = [NSArray arrayWithObjects:@{@"image":@"余额",@"title":@"米子支付"},@{@"image":@"支付宝",@"title":@"支付宝支付"},@{@"image":@"微信",@"title":@"微信支付"}, nil];
        }else if (self.payType == 2){
        
           _dataarr=[NSArray arrayWithObjects:@{@"image":@"支付积分",@"title":@"米券支付"}, nil];
        }
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
