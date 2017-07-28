//
//  GLNearby_EatController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_EatController.h"
#import "GLNearby_ClassifyHeaderView.h"
#import "GLNearby_classifyCell.h"
#import "GLNearby_SectionHeaderView.h"
#import "GLNearby_RecommendMerchatCell.h"
#import "GLNearby_MerchatListController.h"
#import "GLNearbyViewController.h"
#import "LBStoreMoreInfomationViewController.h"
#import "MXNavigationBarManager.h"

#import "GLNearby_TradeOneModel.h"
#import "GLNearby_NearShopModel.h"

@interface GLNearby_EatController ()
{
    LoadWaitView *_loadV;
    NSString *_two_trade_id;
}
@property (nonatomic, strong)NSMutableArray *nearModels;
@property (nonatomic, strong)NSMutableArray *tradeTwoModels;
@property (nonatomic, strong)NSMutableArray *recommendModels;

@property (nonatomic, copy)NSString *city_id;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic, strong)GLNearby_ClassifyHeaderView *headerV;

@end

static NSString *ID = @"GLNearby_classifyCell";
static NSString *ID2 = @"GLNearby_RecommendMerchatCell";
@implementation GLNearby_EatController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView registerNib:[UINib nibWithNibName:ID2 bundle:nil] forCellReuseIdentifier:ID2];
    
    
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf updateData:YES];
        
    }];

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    [self updateData:YES];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//
//    [MXNavigationBarManager reStoreToCustomNavigationBar:self];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
}
- (void)updateData:(BOOL)status {
    if (status) {

        [self.nearModels removeAllObjects];
        [self.recommendModels removeAllObjects];
        [self.tradeTwoModels removeAllObjects];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    GLNearby_TradeOneModel *model = [GLNearby_Model defaultUser].trades[0];
    dict[@"trade_id"] = model.trade_id;
    dict[@"lng"] = [GLNearby_Model defaultUser].longitude;
    dict[@"lat"] = [GLNearby_Model defaultUser].latitude;

    _loadV = [LoadWaitView addloadview:[UIApplication sharedApplication].keyWindow.bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"shop/serachNearMain" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                self.city_id = responseObject[@"city_id"];
                [GLNearby_Model defaultUser].city_id = responseObject[@"city_id"];
                for (NSDictionary *dic  in responseObject[@"data"][@"near_shop"]) {
                    GLNearby_NearShopModel *model = [GLNearby_NearShopModel mj_objectWithKeyValues:dic];
                    [self.nearModels addObject:model];
                }
                for (NSDictionary *dic  in responseObject[@"data"][@"two_trade_data"]) {
                    GLNearby_TradeOneModel *model = [GLNearby_TradeOneModel mj_objectWithKeyValues:dic];
                    [self.tradeTwoModels addObject:model];
                }
                for (NSDictionary *dic in responseObject[@"data"][@"tj_shop"]) {
                    GLNearby_NearShopModel *model = [GLNearby_NearShopModel mj_objectWithKeyValues:dic];
                    [self.recommendModels addObject:model];
                }
                
                _headerV = [[GLNearby_ClassifyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
                self.tableView.tableHeaderView = _headerV;
                _headerV.dataSource = self.tradeTwoModels;
            __weak __typeof(self) weakSelf = self;
                _headerV.block = ^(NSString *typeID,NSInteger count){
                   
                    if ([typeID isEqualToString:@"全部"]) {
                        
                        if (count % 4 == 0) {
                            
                            weakSelf.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, count/4 * 30 + 10);
                            
                        }else{
                            
                            weakSelf.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (count/4 +1) * 30 + 10);
                        }
                    }else if([typeID isEqualToString:@"收起"]){
                        
                        weakSelf.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
                        
                    }else{
                        
                        for (int i = 0; i < self.tradeTwoModels.count; i ++) {
                            GLNearby_TradeOneModel *model = weakSelf.tradeTwoModels[i];
                            if ([typeID isEqualToString:model.trade_name]) {
                                _two_trade_id = model.trade_id;
                            }
                        }
                        
                        [weakSelf refreshRequest];
                    }
                    
                    [weakSelf.tableView reloadData];
                    
                };

            }
        }
        
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.description];
        [self.tableView reloadData];
    }];

}
- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}
- (void)refreshRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    GLNearby_TradeOneModel *model = [GLNearby_Model defaultUser].trades[0];
    dict[@"trade_id"] = model.trade_id;
    dict[@"trade_two_id"] = _two_trade_id;
    dict[@"lng"] = [GLNearby_Model defaultUser].longitude;
    dict[@"lat"] = [GLNearby_Model defaultUser].latitude;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"shop/serachNearMain" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                [self.nearModels removeAllObjects];
                [self.tradeTwoModels removeAllObjects];
                
                self.city_id = responseObject[@"city_id"];
                
                [GLNearby_Model defaultUser].city_id = responseObject[@"city_id"];
                for (NSDictionary *dic  in responseObject[@"data"][@"near_shop"]) {
                    GLNearby_NearShopModel *model = [GLNearby_NearShopModel mj_objectWithKeyValues:dic];
                    [self.nearModels addObject:model];
                }
                for (NSDictionary *dic  in responseObject[@"data"][@"two_trade_data"]) {
                    GLNearby_TradeOneModel *model = [GLNearby_TradeOneModel mj_objectWithKeyValues:dic];
                    [self.tradeTwoModels addObject:model];
                }
            }
        }
        
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.description];
        [self.tableView reloadData];
    }];
    
}
- (UIViewController *)viewController {
    for (UIView *view = self.view; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[GLNearbyViewController class]]) {
            return (GLNearbyViewController *)nextResponder;
        }
    }
    return nil;
}
- (void)more:(UIButton * )btn {
    self.viewController.hidesBottomBarWhenPushed = YES;
    
    GLNearby_MerchatListController *merchatVC = [[GLNearby_MerchatListController alloc] init];

    GLNearby_TradeOneModel *model = [GLNearby_Model defaultUser].trades[0];
    merchatVC.index = btn.tag;
    merchatVC.typeArr = self.tradeTwoModels;
    merchatVC.city_id = self.city_id;
    merchatVC.trade_id = model.trade_id;
    [self.viewController.navigationController pushViewController:merchatVC animated:YES];
    
    self.viewController.hidesBottomBarWhenPushed = NO;
    
}
#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if(self.recommendModels.count == 0){
            return 0;
        }else{
            
            return 1;
        }
    }else{
        
        return self.nearModels.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30 * autoSizeScaleY;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GLNearby_SectionHeaderView *headV = [[NSBundle mainBundle] loadNibNamed:@"GLNearby_SectionHeaderView" owner:nil options:nil].lastObject;
    
    if (section == 0) {
        headV.titleLabel.text = @"推荐商家";
        [headV.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        headV.imagev.image = [UIImage imageNamed:@"tjsj_icon"];
        headV.moreBtn.tag = 10;
    }else{
        headV.titleLabel.text = @"附近商家";
        [headV.moreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        headV.moreBtn.tag = 11;
        headV.imagev.image = [UIImage imageNamed:@"fjsj_icon"];
    }
    [headV.moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    
    return headV;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        GLNearby_RecommendMerchatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2 forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.models = self.recommendModels;
        return cell;
        
    }else{
        
        GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.model = self.nearModels[indexPath.row];
        return cell;
        
    }
    
     return [[UITableViewCell alloc]init];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (SCREEN_WIDTH / 3) + 26;
    }else{
        return 110 *autoSizeScaleY;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.viewController.hidesBottomBarWhenPushed = YES;
    
    LBStoreMoreInfomationViewController *store = [[LBStoreMoreInfomationViewController alloc] init];
    store.lat = [[GLNearby_Model defaultUser].latitude floatValue];
    store.lng = [[GLNearby_Model defaultUser].longitude floatValue];
    GLNearby_NearShopModel *model = self.nearModels[indexPath.row];
    store.storeId = model.shop_id;
    
    [self.viewController.navigationController pushViewController:store animated:YES];
    self.viewController.hidesBottomBarWhenPushed = NO;
}

- (NSMutableArray *)nearModels{
    if (!_nearModels) {
        _nearModels = [NSMutableArray array];
    }
    return _nearModels;
}
- (NSMutableArray *)tradeTwoModels{
    if (!_tradeTwoModels) {
        _tradeTwoModels = [NSMutableArray array];
    }
    return _tradeTwoModels;
}- (NSMutableArray *)recommendModels{
    if (!_recommendModels) {
        _recommendModels = [NSMutableArray array];
    }
    return _recommendModels;
}
@end
