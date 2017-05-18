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

#import "GLNearby_TradeOneModel.h"
#import "GLNearby_NearShopModel.h"

@interface GLNearby_EatController ()
{
//    BOOL _isAll;
    LoadWaitView *_loadV;
}
@property (nonatomic, strong)NSMutableArray *nearModels;
@property (nonatomic, strong)NSMutableArray *tradeTwoModels;

@end

static NSString *ID = @"GLNearby_classifyCell";
static NSString *ID2 = @"GLNearby_RecommendMerchatCell";
@implementation GLNearby_EatController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView registerNib:[UINib nibWithNibName:ID2 bundle:nil] forCellReuseIdentifier:ID2];
    [self postRequest];
}
- (void)postRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"trade_id"] = @1;
    dict[@"lng"] = @104.0841100000;
    dict[@"lat"] = @30.6568320000;
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/serachNearMain" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                for (NSDictionary *dic  in responseObject[@"data"][@"near_shop"]) {
                    GLNearby_NearShopModel *model = [GLNearby_NearShopModel mj_objectWithKeyValues:dic];
                    [self.nearModels addObject:model];
                }
                for (NSDictionary *dic  in responseObject[@"data"][@"two_trade_data"]) {
                    GLNearby_TradeOneModel *model = [GLNearby_TradeOneModel mj_objectWithKeyValues:dic];
                    [self.tradeTwoModels addObject:model];
                }
        
                GLNearby_ClassifyHeaderView *headerV = [[GLNearby_ClassifyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
                self.tableView.tableHeaderView = headerV;
                headerV.dataSource = self.tradeTwoModels;
                
                __weak typeof(self) weakSelf = self;
                
                headerV.block = ^(NSString *typeID,NSInteger count){
                    NSLog(@"typeID = %@",typeID);
                    
                    if ([typeID isEqualToString:@"全部"]) {
                        
                        if (count % 4 == 0) {
                            
                            weakSelf.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, count/4 * 30 + 10);
                        }else{
                            weakSelf.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (count/4 +1) * 30 + 10);
                        }
                    }
                    if([typeID isEqualToString:@"收起"]){
                        weakSelf.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
                    }
                    [weakSelf.tableView reloadData];
                    
                };

            }
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.description];
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
- (void)more:(NSInteger )index {
    self.viewController.hidesBottomBarWhenPushed = YES;
    GLNearby_MerchatListController *merchatVC = [[GLNearby_MerchatListController alloc] init];

    merchatVC.index = index;
  
    [self.viewController.navigationController pushViewController:merchatVC animated:YES];
    self.viewController.hidesBottomBarWhenPushed = NO;
    
}
#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
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
        headV.index = 0;
    }else{
        headV.titleLabel.text = @"附近商家";
        [headV.moreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        headV.index = 1;
    }
    [headV.moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    
    return headV;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GLNearby_RecommendMerchatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        cell.selectionStyle = 0;
        return cell;
    }else{
        
        GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = 0;
        cell.model = self.nearModels[indexPath.row];
        return cell;
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130 *autoSizeScaleY;
    }else{
        
        return 110 *autoSizeScaleY;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    
    self.hidesBottomBarWhenPushed = NO;
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
}
@end
