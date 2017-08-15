//
//  GLShoppingCartController.m
//  PublicSharing
//
//  Created by 龚磊 on 2017/3/23.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLShoppingCartController.h"
#import "GLShoppingCell.h"
#import "GLConfirmOrderController.h"
#import "UIButton+SetEdgeInsets.h"

@interface GLShoppingCartController ()<UITableViewDelegate,UITableViewDataSource>
{
//    NSMutableArray *_numArr;
//    NSInteger _yesSum;
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearingBtn;

@property (nonatomic, assign)BOOL isSelectedRightBtn;

@property (nonatomic, strong)NSMutableArray *selectArr;

@property (nonatomic, strong)UIButton *rightBtn;

@property (nonatomic, assign)CGFloat totalPrice;

@property (nonatomic, assign)NSInteger totalNum;

@property (nonatomic, strong)NSMutableArray *models;
@property (weak, nonatomic) IBOutlet UILabel *navaTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrait;
@property (strong, nonatomic)NodataView *nodataV;
@property (weak, nonatomic) IBOutlet UIButton *seleteAllBtn;


@end

static NSString *ID = @"GLShoppingCell";
@implementation GLShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLShoppingCell" bundle:nil] forCellReuseIdentifier:ID];

     [self.clearingBtn addTarget:self action:@selector(clearingMore:) forControlEvents:UIControlEventTouchUpInside];
//    self.selectedNumLabel.text = [NSString stringWithFormat:@"已选中%ld件商品",_totalNum];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计:¥ %lu",(long)_totalPrice];
   
    [self.tableView addSubview:self.nodataV];
    
     [self.tableView.mj_header beginRefreshing];
     [self postRequest];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self postRequest];
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;

}

- (void)postRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    [NetworkManager requestPOSTWithURLStr:@"shop/myCartList" paramDic:dict finish:^(id responseObject) {
        
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                if ([responseObject[@"code"] integerValue] == 1){
                    
                    [self.models removeAllObjects];
                    
                    for (NSDictionary *dic in responseObject[@"data"]) {
                        
                        GLShoppingCartModel *model = [GLShoppingCartModel mj_objectWithKeyValues:dic];
                        model.isSelect = NO;
                        [self.models addObject:model];
                    }
                }else{
                     [MBProgressHUD showError:responseObject[@"message"]];
                }
                
            }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } enError:^(NSError *error) {
         [MBProgressHUD showError:@"请求数据失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}

//去结算
- (void)clearingMore:(UIButton *)sender{
    
    if (self.selectArr.count == 0) {
        [MBProgressHUD showError:@"还未选择商品"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLConfirmOrderController *orderVC = [[GLConfirmOrderController alloc] init];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *tempArr2 = [NSMutableArray array];
    NSMutableArray *tempArr3 = [NSMutableArray array];
    NSMutableArray *tempArr4 = [NSMutableArray array];
    
    for (int i = 0; i < self.selectArr.count; i ++) {
        GLShoppingCartModel *model = self.models[i];
        [tempArr addObject:model.goods_id];
        [tempArr2 addObject:model.num];
        [tempArr3 addObject:model.cart_id];
        [tempArr4 addObject:model.spec_id];
    }
    orderVC.goods_id = [tempArr componentsJoinedByString:@","];;
    orderVC.goods_count = [tempArr2 componentsJoinedByString:@","];
    orderVC.cart_id = [tempArr3 componentsJoinedByString:@","];
    orderVC.goods_spec = [tempArr4 componentsJoinedByString:@","];
    
    [self.navigationController pushViewController:orderVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

//全选
- (IBAction)selectAll:(UIButton*)sender {
    
    sender.selected = !sender.selected;
    float  num = 0;
    [self.selectArr removeAllObjects];
    
    if (sender.selected) {
        for (int i = 0; i < self.models.count; i++) {
            GLShoppingCartModel *model = self.models[i];
            model.isSelect = YES;
            num = num + [model.goods_price floatValue] * [model.num floatValue];
            [self.selectArr addObject:model];
        }
    }else{
        [self.selectArr removeAllObjects];
        
        if (self.models.count == 0) {
            return;
        }
        for (int i = 0; i < self.models.count; i++) {
            GLShoppingCartModel *model = self.models[i];
            model.isSelect = NO;
        }
        
    }
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
    [self.tableView reloadData];

    
}

//选中,取消选中
- (void)changeStatus:(NSInteger)index {
    
     [self.selectArr removeAllObjects];
    
    BOOL  b = NO;
    float  num = 0;
    
    for (int i = 0; i < self.models.count; i++) {
        GLShoppingCartModel *model = self.models[i];
        
        if (model.isSelect == NO) {
            b = YES;
            
        }else{
            num = num + [model.goods_price floatValue] * [model.num floatValue];
            [self.selectArr addObject:model];
        }
    }
    
    if (b == YES) {
        
        self.seleteAllBtn.selected = NO;
        
    }else{
        
        self.seleteAllBtn.selected = YES;
    }
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"总计:¥ %.2f",num];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)updateTitleNum {
    if (self.isMainVC == NO) {
        self.navaTitle.text = [NSString stringWithFormat:@"购物车"];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"购物车"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [self updateTitleNum];
    if (self.isMainVC == NO) {
      self.navigationController.navigationBar.hidden = YES;
        self.bottomConstrait.constant = 49;
    }else{
        self.navigationController.navigationBar.hidden = NO;
        self.bottomConstrait.constant = 0;
    }
}

#pragma  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.models.count <= 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.models.count == 0 ? 0:self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    cell.model = self.models.count == 0 ? nil:self.models[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLShoppingCartModel *model = self.models[indexPath.row];
    model.isSelect = !model.isSelect;
    
    [self changeStatus:indexPath.row];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该商品？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController removeFromParentViewController];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            GLShoppingCartModel *model = self.models[indexPath.row];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [UserModel defaultUser].token;
            dict[@"uid"] = [UserModel defaultUser].uid;
            dict[@"goods_id"] = model.goods_id;
            dict[@"cart_id"] = model.cart_id;
            
            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:@"shop/delCart" paramDic:dict finish:^(id responseObject) {
                
                [_loadV removeloadview];

                if ([responseObject[@"code"] integerValue] == 1){

                    [self.models removeObjectAtIndex:indexPath.row];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                }else{
                    [MBProgressHUD showError:responseObject[@"message"]];
                }
                
            } enError:^(NSError *error) {
                [_loadV removeloadview];
            }];

        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
}

- (NSMutableArray *)selectArr {
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}
@end
