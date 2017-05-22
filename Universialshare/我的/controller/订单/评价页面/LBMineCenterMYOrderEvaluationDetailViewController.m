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
#import "LBMyOrderlistHeaderFooterView.h"

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
        model.mark = [NSString stringWithFormat:@"%@",self.arr[i][@"mark"]];
        model.is_comment = [NSString stringWithFormat:@"%@",self.arr[i][@"is_comment"]];
        model.reply = [NSString stringWithFormat:@"%@",self.arr[i][@"reply"]];
        
        [self.dataArr addObject:model];
    }
    [self.tableview reloadData];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
     return self.dataArr.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    orderEvaluationModel *model = self.dataArr[indexPath.row];
    
    if ([model.is_comment integerValue] == 0) {
        return model.isexpand == YES ? 350:110;
    }else if ([model.is_comment integerValue] == 1 || [model.is_comment integerValue] == 2){
        if (model.isexpand == YES) {
            self.tableview.estimatedRowHeight = 180;
            self.tableview.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }else{
            return 110;
        }
    }
    return 0;
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 118;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LBMyOrderlistHeaderFooterView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBMyOrderlistHeaderFooterView"];
    
    if (!headerview) {
        headerview = [[LBMyOrderlistHeaderFooterView alloc] initWithReuseIdentifier:@"LBMyOrderlistHeaderFooterView"];
        
    }
    __weak typeof(self) weakself = self;
    
    
    return headerview;
}


#pragma mark ---- LBMineCenterMYOrderEvaluationDetailDelegete

-(void)tapgestureshowmoreinfo:(NSInteger)index{

    orderEvaluationModel *model = self.dataArr[index];
    model.isexpand = !model.isexpand;
    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableview reloadData];
    
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
