//
//  LBProductManagementViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBProductManagementViewController.h"
#import "LBProductManagementTableViewCell.h"
#import "LBAddMineProductionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LBProductManagementViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,LBProductManagementDelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *addProductBt;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)NSMutableArray *editBoolArr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;
@property (strong, nonatomic)UIButton *editButton;//编辑

@end

@implementation LBProductManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"产品管理";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBProductManagementTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBProductManagementTableViewCell"];
    [self.tableview addSubview:self.nodataV];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerrefresh];
            // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];

    // 设置文字
    
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableview.mj_header = header;
    self.tableview.mj_footer = footer;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
    self.page = 1;
    [self initdatasource];
}

-(void)initdatasource{
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/getStoreGoodsList" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page]} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                 [self.dataarr addObjectsFromArray:responseObject[@"data"]];
                [self.editBoolArr removeAllObjects];
                if (self.editButton.selected == YES) {
                    for (int i = 0; i<self.dataarr.count; i++) {
                        [self.editBoolArr addObject:@YES];
                    }
                }else{
                    for (int i = 0; i<self.dataarr.count; i++) {
                        [self.editBoolArr addObject:@NO];
                    }
                }
            }
            
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
            
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
//商品管理
-(void)setStoreGoods:(NSInteger)index strid:(int)strid  buttonindex:(NSInteger)buttonindex status:(int)status row:(NSInteger)row{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/setStoreGoods" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"goods_id" :[NSNumber numberWithInteger:strid],@"status" :[NSNumber numberWithInteger:status]} finish:^(id responseObject) {
        [_loadV removeloadview];
       
        if ([responseObject[@"code"] integerValue]==1) {
            [MBProgressHUD showError:responseObject[@"message"]];
            
            if (buttonindex == 1) {
                //3未审核
                if (index == 3) {
                    NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:self.dataarr[row]];
                    mDict[@"sh_status"] = @"1";
                    [self.dataarr replaceObjectAtIndex:row withObject:mDict];

                }else if (index == 1){ //1 审核失败
                    [self.dataarr removeObjectAtIndex:row];
                    
                }else if (index == 2 && [self.dataarr[row][@"status"]integerValue] == 1){//2审核成功  1 上架
                    
                    NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:self.dataarr[row]];
                    mDict[@"status"] = @"2";
                    [self.dataarr replaceObjectAtIndex:row withObject:mDict];
                    
                }else if (index == 2 && [self.dataarr[row][@"status"]integerValue] == 2){//2审核成功  1 下架
                    
                    [self.dataarr removeObjectAtIndex:row];
                }
            }else{
                //3未审核
                if (index == 3) {
                    
                    
                }else if (index == 1){ //1 审核失败
                    
                    
                }else if (index == 2 && [self.dataarr[row][@"status"]integerValue] == 1){//2审核成功  1 上架
                    
                    [self.dataarr removeObjectAtIndex:row];

                }else if (index == 2 && [self.dataarr[row][@"status"]integerValue] == 2){//2审核成功  1 下架
                    
                }
            }
            
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableview reloadData];
            
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
    [self initdatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
     [self initdatasource];
}

//添加产品
- (IBAction)addProductEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed=YES;
    LBAddMineProductionViewController *vc=[[LBAddMineProductionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//编辑完成
-(void)edtingEventbutton:(UIButton*)button{
    button.selected = !button.selected;

    if (button.selected) {
        
        for (int i=0; i<self.editBoolArr.count; i++) {
            [self.editBoolArr replaceObjectAtIndex:i withObject:@YES];
        }
    }else{
        for (int i=0; i<self.editBoolArr.count; i++) {
            [self.editBoolArr replaceObjectAtIndex:i withObject:@NO];
        }
    
    }
    
    [self.tableview reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataarr.count > 0) {
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
    }

    return self.dataarr.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return 130;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBProductManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBProductManagementTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rowIndex = indexPath.row;
    cell.delegete = self;
    
    if ([self.dataarr[indexPath.row][@"type"]integerValue] == 1) {
        cell.modelLb.text = [NSString stringWithFormat:@"奖金: 20%%"];
    }else if ([self.dataarr[indexPath.row][@"type"]integerValue] == 2){
        cell.modelLb.text = [NSString stringWithFormat:@"奖金: 10%%"];
    }else if ([self.dataarr[indexPath.row][@"type"]integerValue] == 3){
        cell.modelLb.text = [NSString stringWithFormat:@"奖金: 5%%"];
    }else if([self.dataarr[indexPath.row][@"type"]integerValue] == [KThreePersent integerValue]){
        cell.modelLb.text = [NSString stringWithFormat:@"奖金: 3%%"];
    }
    
    if ([self.dataarr[indexPath.row][@"sh_status"]integerValue] == 3) {
        cell.imageT.image = [UIImage imageNamed:@"审核中"];
        cell.centerXconstant.constant = 0;
        cell.buttonOne.hidden = NO;
        cell.buttonTwo.hidden = YES;
        [cell.buttonOne setTitle:@"停止审核" forState:UIControlStateNormal];
    }else if ([self.dataarr[indexPath.row][@"sh_status"]integerValue] == 1){
        cell.centerXconstant.constant = 0;
        cell.buttonOne.hidden = NO;
        cell.buttonTwo.hidden = YES;
        cell.imageT.image = [UIImage imageNamed:@"审核失败"];
        [cell.buttonOne setTitle:@"删除" forState:UIControlStateNormal];
    }else if ([self.dataarr[indexPath.row][@"sh_status"]integerValue] == 2 && [self.dataarr[indexPath.row][@"status"]integerValue] == 1){
        cell.centerXconstant.constant = -50;
        cell.buttonOne.hidden = NO;
        cell.buttonTwo.hidden = NO;
        cell.imageT.image = [UIImage imageNamed:@"审核通过"];
        [cell.buttonOne setTitle:@"下架" forState:UIControlStateNormal];
        [cell.buttonTwo setTitle:@"删除" forState:UIControlStateNormal];
    }else if ([self.dataarr[indexPath.row][@"sh_status"]integerValue] == 2 && [self.dataarr[indexPath.row][@"status"]integerValue] == 2){
        cell.centerXconstant.constant = 0;
        cell.buttonOne.hidden = NO;
        cell.buttonTwo.hidden = YES;
        cell.imageT.image = [UIImage imageNamed:@"已下架"];
        [cell.buttonOne setTitle:@"删除" forState:UIControlStateNormal];
    }
    
    [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"thumb"]]] placeholderImage:[UIImage imageNamed:@"熊"] options:SDWebImageAllowInvalidSSLCertificates] ;

    cell.productNameLb.text = [NSString stringWithFormat:@"商品名称:%@",self.dataarr[indexPath.row][@"name"]];
    cell.numLb.text = [NSString stringWithFormat:@"商品数量:%@",self.dataarr[indexPath.row][@"num"]];
    cell.moneyLb.text = [NSString stringWithFormat:@"商品价格:¥%@",self.dataarr[indexPath.row][@"price"]];
    
    if ([_editBoolArr[indexPath.row]boolValue] == NO) {
        
        cell.editView.hidden = YES;
    }else{
    
        cell.editView.hidden = NO;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        if (alertView.tag == 10) {
            
            
        }
        
    }
    
}

#pragma mark --- LBProductManagementDelegete
-(void)LBProductManagementButtonOne:(NSInteger)index{

    
    //3未审核
    if ([self.dataarr[index][@"sh_status"]integerValue] == 3) {
        //4停止审核
       [self setStoreGoods:[self.dataarr[index][@"sh_status"]integerValue] strid:[self.dataarr[index][@"goods_id"]intValue] buttonindex:1 status:4 row:index];
        
    }else if ([self.dataarr[index][@"sh_status"]integerValue] == 1){ //1 审核失败
        
       [self setStoreGoods:[self.dataarr[index][@"sh_status"]integerValue] strid:[self.dataarr[index][@"goods_id"]intValue] buttonindex:1 status:1 row:index];
        
    }else if ([self.dataarr[index][@"sh_status"]integerValue] == 2 && [self.dataarr[index][@"status"]integerValue] == 1){//2审核成功  1 上架
        
        [self setStoreGoods:[self.dataarr[index][@"sh_status"]integerValue] strid:[self.dataarr[index][@"goods_id"]intValue] buttonindex:1 status:3 row:index];
        
        
    }else if ([self.dataarr[index][@"sh_status"]integerValue] == 2 && [self.dataarr[index][@"status"]integerValue] == 2){//2审核成功  1 下架
        
        [self setStoreGoods:[self.dataarr[index][@"sh_status"]integerValue] strid:[self.dataarr[index][@"goods_id"]intValue] buttonindex:1 status:1 row:index];
       
    }

}



-(void)LBProductManagementButtonTwo:(NSInteger)index{

    
    //3未审核
    if ([self.dataarr[index][@"sh_status"]integerValue] == 3) {
       
        
    }else if ([self.dataarr[index][@"sh_status"]integerValue] == 1){ //1 审核失败
        
        
    }else if ([self.dataarr[index][@"sh_status"]integerValue] == 2 && [self.dataarr[index][@"status"]integerValue] == 1){//2审核成功  1 上架
        
        [self setStoreGoods:[self.dataarr[index][@"sh_status"]integerValue] strid:[self.dataarr[index][@"goods_id"]intValue] buttonindex:2 status:1 row:index];
        
        
    }else if ([self.dataarr[index][@"sh_status"]integerValue] == 2 && [self.dataarr[index][@"status"]integerValue] == 2){//2审核成功  1 下架
        
        
    }


}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.addProductBt.layer.cornerRadius = 4;
    self.addProductBt.clipsToBounds = YES;


}

-(UIButton*)editButton{

    if (!_editButton) {
        _editButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"完成" forState:UIControlStateSelected];
        [_editButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(edtingEventbutton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _editButton;

}

-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    
    return _dataarr;
    
}

-(NSMutableArray *)editBoolArr{
    
    if (!_editBoolArr) {
        _editBoolArr=[NSMutableArray array];
    }
    
    return _editBoolArr;
    
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}


@end
