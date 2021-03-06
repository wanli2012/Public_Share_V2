//
//  GLConfirmOrderController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLConfirmOrderController.h"
#import "GLOrderDetailController.h"
#import "GLOrderPayView.h"
#import "GLSet_MaskVeiw.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LBMineCentermodifyAdressViewController.h"

#import "LBMineCenterPayPagesViewController.h"
#import "GLOrderGoodsCell.h"
#import "GLConfirmOrderModel.h"
#import "GLMine_RicePayController.h"

@interface GLConfirmOrderController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    int _sumNum;
    LoadWaitView * _loadV;
}

@property (nonatomic, strong)GLSet_MaskVeiw *maskV;
@property (nonatomic, strong)GLOrderPayView *payV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;

@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;//运费Label
@property (weak, nonatomic) IBOutlet UILabel *totalSumLabel;//实付总价

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray  *models;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

//收货人信息
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

//留言
@property (weak, nonatomic) IBOutlet UITextView *remarkTextV;

@property (nonatomic, copy)NSString *address_id;

@end

static NSString *ID = @"GLOrderGoodsCell";
@implementation GLConfirmOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    self.contentViewW.constant = SCREEN_WIDTH;
    self.contentViewH.constant = SCREEN_HEIGHT + 49;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAddress)];
    [self.addressView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(ensurePassword:) name:@"input_PasswordNotification" object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLOrderGoodsCell" bundle:nil] forCellReuseIdentifier:ID];
     [self postRequest];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)postRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    //请求地址
    [NetworkManager requestPOSTWithURLStr:@"Shop/address_list" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){

            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
        
                for (NSDictionary *dic in responseObject[@"data"]) {
                    if ([dic[@"is_default"] intValue] == 1) {
                        self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",dic[@"collect_name"]];
                        self.phoneLabel.text = [NSString stringWithFormat:@"tel:%@",dic[@"s_phone"]];
                        self.addressLabel.text = [NSString stringWithFormat:@"%@",dic[@"s_address"]];
                        self.address_id = [NSString stringWithFormat:@"%@",dic[@"address_id"]];
                    }
                }
            }
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
    
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"token"] = [UserModel defaultUser].token;
    dict1[@"uid"] = [UserModel defaultUser].uid;
    dict1[@"goods_id"] = self.goods_id;
    dict1[@"goods_count"] = self.goods_count;
    dict1[@"goods_spec"] = self.goods_spec;
  
    //请求商品信息
    [NetworkManager requestPOSTWithURLStr:@"Shop/placeOrderBefore" paramDic:dict1 finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            
            self.totalSumLabel.text = [NSString stringWithFormat:@"合计:¥%.2f",[responseObject[@"data"][@"all_realy_price"] floatValue] ];
            self.yunfeiLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"all_delivery"]];
            
            for (NSDictionary *dic in responseObject[@"data"][@"goods_list"]) {
                GLConfirmOrderModel *model = [GLConfirmOrderModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
            }
            self.tableViewHeight.constant = _models.count * 140 * autoSizeScaleY;
            self.contentViewH.constant = _models.count * 140 * autoSizeScaleY + 220;
            [self.tableView reloadData];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
    
}

- (void)changeAddress{
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineCentermodifyAdressViewController *modifyAD = [[LBMineCentermodifyAdressViewController alloc] init];
    modifyAD.block = ^(NSString *name,NSString *phone,NSString *address,NSString *addressid){
        self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",name];
        self.phoneLabel.text = [NSString stringWithFormat:@"电话号码:%@",phone];
        self.addressLabel.text = [NSString stringWithFormat:@"%@",address];
        self.address_id = addressid;
    };
    
    [self.navigationController pushViewController:modifyAD animated:YES];
}
- (void)dismiss {
    [_payV.passwordF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _payV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT *0.5);

    }completion:^(BOOL finished) {

        [_maskV removeFromSuperview];
    }];
}

- (void)ensurePassword:(NSNotification *)userInfo{
    [self dismiss];

}
  

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

//订单提交
- (IBAction)submitOrder:(UIButton *)sender {

    if (self.nameLabel.text.length <=0 ) {
        [MBProgressHUD showError:@"请填写收货信息"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"goods_id"] = self.goods_id;
    dict[@"goods_count"] = self.goods_count;
    dict[@"address_id"] = self.address_id;
    dict[@"remark"] = self.remarkTextV.text;
    dict[@"cart_id"] = self.cart_id;
    dict[@"goods_spec"] = self.goods_spec;
    dict[@"version"] = @"3";
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/placeOrderEnd" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 1){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCartNotification" object:nil];
            
            if ([responseObject[@"data"][@"order_type"] integerValue] == 2) {
                
                GLMine_RicePayController *riceVC = [[GLMine_RicePayController alloc] init];
                riceVC.orderPrice = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"total_price"]];
                riceVC.useableScore = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_integal"]];
                riceVC.order_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"order_id"]];
                riceVC.order_sn = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ordere_sn"]];
                riceVC.order_sh = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"order_sh"]];

                [self.navigationController pushViewController:riceVC animated:YES];
                
                return ;
            }
            
            self.hidesBottomBarWhenPushed = YES;
            LBMineCenterPayPagesViewController *payVC = [[LBMineCenterPayPagesViewController alloc] init];
            payVC.payType = [responseObject[@"data"][@"order_type"] integerValue];;
            payVC.orderPrice = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"total_price"]];
            payVC.useableScore = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_integal"]];
            payVC.order_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"order_id"]];
            payVC.order_sn = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ordere_sn"]];
            payVC.order_sh = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"order_sh"]];
            payVC.pushIndex = 1;
            
            [self.navigationController pushViewController:payVC animated:YES];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:@"请求失败"];
    }];
    
}

#pragma  UITableveiwdelegate UITableviewdatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GLOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(self.orderType == 1){
        cell.fanliLabel.hidden = YES;
    }else{
        cell.fanliLabel.hidden = NO;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120*autoSizeScaleY;
    
//    self.tableView.estimatedRowHeight = 44;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    return self.tableView.rowHeight;
    
}

#pragma mark uitextviewdelegete

-(void)textViewDidBeginEditing:(UITextView *)textView{

    if ([textView.text isEqualToString:@"这个买家什么也没留下!"]) {
        textView.text = @"";
    }

}

-(void)textViewDidEndEditing:(UITextView *)textView{

    NSString *string= [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (string.length <= 0) {
        textView.text = @"这个买家什么也没留下!";
    }

}

#pragma 懒加载
- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}
@end
