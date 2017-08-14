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
    NSMutableArray *_numArr;
    NSInteger _yesSum;
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearingBtn;

@property (nonatomic, assign)BOOL isSelectedRightBtn;

@property (nonatomic, strong)NSMutableArray *selectArr;

@property (nonatomic, strong)UIButton *rightBtn;

@property (nonatomic, strong)NSMutableArray *dataSource;

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
                    [self.dataSource removeAllObjects];
                    [self.numArr removeAllObjects];
                    
                    for (NSDictionary *dic in responseObject[@"data"]) {
                        
                        GLShoppingCartModel *model = [GLShoppingCartModel mj_objectWithKeyValues:dic];
                        [self.models addObject:model];
                        
                        for (int i = 0; i < self.models.count; i ++) {
                            GLShoppingCartModel *model = self.models[i];
                            [self.dataSource addObject:model.goods_price];
                        }
                        
                        for (int  i = 0; i < self.models.count; i ++) {
                            BOOL isSelected = NO;
                            [self.selectArr addObject:@(isSelected)];
                            GLShoppingCartModel *model = self.models[i];
                            [self.numArr addObject:model.num];;
                        }
                    }
                    
                    [self.tableView reloadData];
                    
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
    if (_yesSum > 0) {
        
        NSMutableString *goods_idStrM = [NSMutableString string];
        NSMutableString *goods_numStrM = [NSMutableString string];
        NSMutableString *cart_idM = [NSMutableString string];
        NSMutableString *goods_specIdStrM = [NSMutableString string];
        BOOL a = NO;
        BOOL b = NO;
        for (int i = 0; i < _models.count; i ++) {
            if ([self.selectArr[i] boolValue]) {
                GLShoppingCartModel *model = _models[i];
                [goods_idStrM appendFormat:@"%@,",model.goods_id];
                [goods_numStrM appendFormat:@"%@,",model.num];
                [cart_idM appendFormat:@"%@,",model.cart_id];
                [goods_specIdStrM appendFormat:@"%@,",model.spec_id];
                
                if ([model.goods_type integerValue]== 1) {
                    a = YES;
                }else  {
                    b = YES;
                }
            }
        }
        
        [goods_idStrM deleteCharactersInRange:NSMakeRange([goods_idStrM length]-1, 1)];
        [goods_numStrM deleteCharactersInRange:NSMakeRange([goods_numStrM length]-1, 1)];
        [cart_idM deleteCharactersInRange:NSMakeRange([cart_idM length]-1, 1)];
        [goods_specIdStrM deleteCharactersInRange:NSMakeRange([goods_specIdStrM length]-1, 1)];
        
        if (a==YES && b == YES) {
            [MBProgressHUD showError:@"两种类型商品不能同时支付"];
            return;
        }
        self.hidesBottomBarWhenPushed = YES;
        GLConfirmOrderController *payVC = [[GLConfirmOrderController alloc] init];
        payVC.goods_id = goods_idStrM;
        payVC.goods_count = goods_numStrM;
        payVC.cart_id = cart_idM;
        payVC.goods_spec = goods_specIdStrM;
        [self.navigationController pushViewController:payVC animated:YES];
    }else{
        [MBProgressHUD showError:@"请选择商品"];
    }
}

//全选
- (IBAction)selectAll:(UIButton*)sender {
    
    if (self.models.count <= 0) {
        [MBProgressHUD showError:@"暂无商品"];
        return;
    }
    sender.selected = !sender.selected;
    _totalPrice = 0;
    _totalNum = 0;
    for (int i = 0; i< self.selectArr.count; i ++) {
        
        BOOL tempBool;
        
        if (self.seleteAllBtn.selected) {
            tempBool = YES;
            _yesSum = self.selectArr.count;
            _totalPrice += [self.dataSource[i] floatValue] * [_numArr[i] floatValue];
            _totalNum += [_numArr[i] integerValue];
        }else{
            tempBool = NO;
            _yesSum = 0;
        }
        
        [self.selectArr replaceObjectAtIndex:i withObject:@(tempBool)];
        
    }
    
    if(self.seleteAllBtn.selected){
        
        self.totalPriceLabel.text = [NSString stringWithFormat:@"合计:¥%.2f",_totalPrice];
        
    }else{
        
        self.totalPriceLabel.text = @"合计:¥ 0";
        _totalNum = 0;
        _totalPrice = 0;
        
    }
    [self updateTitleNum];
    [self.tableView reloadData];
    
}

//选中,取消选中
- (void)changeStatus:(NSInteger)index {
    
    BOOL isSelected = [self.selectArr[index] boolValue];

    isSelected = !isSelected;
    
    if (isSelected) {
         _yesSum += 1;
        _totalNum += [_numArr[index] integerValue];
        _totalPrice += [self.dataSource[index] floatValue] * [_numArr[index] floatValue];
    }else{
        _yesSum -= 1;
        _totalNum -= [_numArr[index] integerValue];
        _totalPrice -= [self.dataSource[index] floatValue]* [_numArr[index] floatValue];
    }

    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计:¥%.2f",_totalPrice];
    [self.selectArr replaceObjectAtIndex:index withObject:@(isSelected)];

    
    if (_yesSum == self.selectArr.count) {
        
        self.seleteAllBtn.selected = YES;
    }else{
        self.seleteAllBtn.selected = NO;

    }
    
    [self updateTitleNum];
    [self.tableView reloadData];

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
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    cell.model = self.models[indexPath.row];
    
    if ([self.selectArr[indexPath.row] boolValue] == NO) {

        [cell.selectedBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }else{

        [cell.selectedBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
       
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
            
            if ([self.selectArr[indexPath.row] boolValue] == YES) {
                _yesSum -= 1;
                if (_yesSum <= 0) {
                    _yesSum = 0;
                }
            }
            
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
                
                    [self.selectArr removeObjectAtIndex:indexPath.row];
                    [self.dataSource removeObjectAtIndex:indexPath.row];
                    [self.numArr removeObjectAtIndex:indexPath.row];
                    [self.models removeObjectAtIndex:indexPath.row];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    BOOL select = NO;
                    for (int i = 0; i < self.selectArr.count; i++) {
                        if ([self.selectArr[i]boolValue] == NO) {
                            select = YES;
                        }
                    }
                    if(select){
                        self.seleteAllBtn.selected = NO;
                    }else{
                        self.seleteAllBtn.selected = YES;
                    }
                    
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
    
     [self.seleteAllBtn horizontalCenterImageAndTitle:10];

}

- (NSMutableArray *)selectArr {
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (NSMutableArray *)numArr {
    if (_numArr == nil) {

        _numArr = [NSMutableArray array];
       
    }
    return _numArr;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
