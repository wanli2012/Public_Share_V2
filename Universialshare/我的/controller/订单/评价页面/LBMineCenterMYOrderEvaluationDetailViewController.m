//
//  LBMineCenterMYOrderEvaluationDetailViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/7.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMYOrderEvaluationDetailViewController.h"
#import "LBMineCenterMYOrderEvaluationDetailTableViewCell.h"
#import "orderEvaluationModel.h"

@interface LBMineCenterMYOrderEvaluationDetailViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,LBMineCenterMYOrderEvaluationDetailDelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBMineCenterMYOrderEvaluationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"评价";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterMYOrderEvaluationDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterMYOrderEvaluationDetailTableViewCell"];
    
    [self initdatasorce];
}

-(void)initdatasorce{

    for (int i=0; i<self.arr.count; i++) {
        orderEvaluationModel *model = [[orderEvaluationModel alloc]init];
        model.isexpand = YES;
        model.imageurl = [NSString stringWithFormat:@"%@",self.arr[i][@"thumb"]];
        model.namelb = [NSString stringWithFormat:@"%@",self.arr[i][@"goods_name"]];
        model.order_goods_id = [NSString stringWithFormat:@"%@",self.arr[i][@"id"]];
        model.moneylb = [NSString stringWithFormat:@"%@",self.arr[i][@"goods_price"]];
        model.infolb = [NSString stringWithFormat:@"%@",self.arr[i][@"goods_info"]];
        model.sizelb = [NSString stringWithFormat:@"%@",self.arr[i][@"shop_name"]];
        
        [self.dataArr addObject:model];
    }
    [self.tableview reloadData];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    orderEvaluationModel *model = self.dataArr[indexPath.row];
    
    return model.isexpand == YES ? 350:110;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMineCenterMYOrderEvaluationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterMYOrderEvaluationDetailTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[cell.payBt setTitle:@"申请退款" forState:UIControlStateNormal];
    cell.index=indexPath.row;
    cell.delegete = self;
    orderEvaluationModel *model = self.dataArr[indexPath.row];
    cell.orderEvaluationModel = model;
    
    return cell;
    
}

#pragma mark ---- LBMineCenterMYOrderEvaluationDetailDelegete

-(void)tapgestureshowmoreinfo:(NSInteger)index{

    orderEvaluationModel *model = self.dataArr[index];
    model.isexpand = !model.isexpand;
    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
    
}

-(void)ishidekeyboard{
    [self.view endEditing:YES];
}

-(void)submitevaluationinfo:(NSInteger)index{
      [self.view endEditing:YES];
    orderEvaluationModel *model = self.dataArr[index];
    if (model.starValue == 0) {
        [MBProgressHUD showError:@"没有评分"];
        return;
    }
    if (model.conentlb.length <= 0) {
        [MBProgressHUD showError:@"请写点感受吧"];
        return;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"user/order_mark_list" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"mark" :[NSNumber numberWithFloat:model.starValue] , @"comment":model.conentlb,@"order_goods_id":model.order_goods_id} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            [MBProgressHUD showError:@"评论成功"];

        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
            
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    

}

-(NSMutableArray*)dataArr{

    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    
    return _dataArr;

}

@end
