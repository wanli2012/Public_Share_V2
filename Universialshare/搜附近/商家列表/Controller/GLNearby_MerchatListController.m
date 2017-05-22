//
//  GLNearby_MerchatListController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_MerchatListController.h"
#import "GLNearby_MerchatListCell.h"
#import "GLSet_MaskVeiw.h"
#import "GLHomeLiveChooseController.h"
#import "GLNearby_MerchatListModel.h"
#import "GLCityChooseController.h"
#import "GLNearby_TradeOneModel.h"

@interface GLNearby_MerchatListController ()<UITableViewDataSource,UITableViewDelegate>
{
    GLSet_MaskVeiw *_maskV;
    UIView *_contentView;
    GLHomeLiveChooseController *_chooseVC;
    
    UIButton *_tmpBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *classifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, assign)NSInteger page;

@end

static NSString *ID = @"GLNearby_MerchatListCell";
@implementation GLNearby_MerchatListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商家列表";

    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [self.sortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [self.sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
    
    [self.classifyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [self.classifyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
    
    [self.cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [self.cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
    
    self.sort = @"1";
    if (self.index == 11) {
        [self.cityBtn setTitle:@"距离" forState:UIControlStateNormal];
    }
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf updateData:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateData:NO];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    [self updateData:YES];
}
- (void)updateData:(BOOL)status {
    
    if (status) {
        
        _page = 1;
        [self.models removeAllObjects];
        
    }else{
        _page ++;
    }
    
//    GLNearby_TradeOneModel *model = [GLNearby_Model defaultUser].trades;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"trade_id"] = self.trade_id;
    dict[@"city_id"] = self.city_id;
    dict[@"limit"] = self.limit;
    dict[@"sort"] = self.sort;
    dict[@"page"] = @(self.page);
    dict[@"two_trade_id"] = self.two_trade_id;
    
    if (self.index == 11) {
        
        dict[@"lng"] = [GLNearby_Model defaultUser].longitude;
        dict[@"lat"] = [GLNearby_Model defaultUser].latitude;
    }
    NSLog(@"%@",dict);
    [NetworkManager requestPOSTWithURLStr:@"shop/getMoreNearRecShop" paramDic:dict finish:^(id responseObject) {
//        NSLog(@"responseObject= =%@",responseObject);
        [self endRefresh];
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                for (NSDictionary *dic  in responseObject[@"data"]) {
                    GLNearby_MerchatListModel *model = [GLNearby_MerchatListModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
                
            }
        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD showError:error.description];
    }];
    
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.topView convertRect:self.topView.bounds toView:window];
    
    _chooseVC = [[GLHomeLiveChooseController alloc] init];
    //    _chooseVC.view.frame = CGRectZero;
    
    _chooseVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, 0);
    _contentView = _chooseVC.view;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 4;
    _contentView.layer.masksToBounds = YES;
    
    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(rect), SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    _maskV.contentView = _contentView;
    _maskV.bgView.alpha = 0.1;
    
    [_maskV showViewWithContentView:_contentView];
    _maskV.alpha = 0;
    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_maskV removeFromSuperview];
}
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        _maskV.alpha = 0;
        
    }];
    [self.cityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.classifyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.sortBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.cityBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    self.classifyBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    self.sortBtn.imageView.transform = CGAffineTransformMakeRotation(0);

 
}


//选择
- (IBAction)choose:(UIButton *)sender {
    
    if (_maskV.alpha == 0) {
        sender.selected = NO;
    }
    
    _maskV.alpha = 1;
    
    [self.cityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.classifyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.sortBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    self.cityBtn.selected = NO;
    self.classifyBtn.selected = NO;
    self.sortBtn.selected = NO;
    sender.selected = YES;
    
    self.cityBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    self.classifyBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    self.sortBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    __weak __typeof(self)weakSelf = self;
    switch (sender.tag) {
        case 10:
        {
            if (self.index == 10) {
                self.hidesBottomBarWhenPushed = YES;
                GLCityChooseController *cityVC = [[GLCityChooseController alloc] init];
        
                cityVC.block = ^(NSString *city,NSString *city_id){
                    [weakSelf.cityBtn setTitle:city forState:UIControlStateNormal];
                    [GLNearby_Model defaultUser].city_id = city_id;
                    [weakSelf updateData:YES];
                    [weakSelf dismiss];
                };
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cityVC animated:YES];
//                self.hidesBottomBarWhenPushed = NO;

            }else{
                _chooseVC.dataSource = @[@"1Km",@"3Km",@"10Km",@"全城"];
                _chooseVC.block = ^(NSString *value){
                    [weakSelf.cityBtn setTitle:value forState:UIControlStateNormal];
                    if ([value isEqualToString:@"1Km"]) {
                        
                        weakSelf.limit = @"1";
                    }else if ([value isEqualToString:@"3Km"]){
                         weakSelf.limit = @"3";
                    }else if ([value isEqualToString:@"10Km"]){
                        weakSelf.limit = @"10";
                    }else{
                        weakSelf.limit = @"";
                    }
                    [weakSelf updateData:YES];
                    [weakSelf dismiss];
                };

            }
         
        }
            break;
        case 11:
        {
            NSMutableArray *tempArr = [NSMutableArray array];
            NSMutableArray *two_trade_idArr = [NSMutableArray array];
            for (int i = 0; i < self.typeArr.count; i ++) {
                GLNearby_TradeOneModel *model = self.typeArr[i];
                [tempArr addObject:model.trade_name];
                [two_trade_idArr addObject:model.trade_id];
            }
            [tempArr addObject:@"不限"];
            [two_trade_idArr addObject:@""];
            _chooseVC.dataSource = tempArr;
            _chooseVC.block = ^(NSString *value){
                [weakSelf.classifyBtn setTitle:value forState:UIControlStateNormal];
                for (int i = 0; i < self.typeArr.count; i ++) {
                    if ([value isEqualToString:tempArr[i]]) {
                        weakSelf.two_trade_id = two_trade_idArr[i];
                    }
                   
                }
                if ([value isEqualToString:@"不限"]) {
                    weakSelf.two_trade_id = @"";
                }
                [weakSelf updateData:YES];
                [weakSelf dismiss];
            };
        }
            break;
        case 12:
        {
            _chooseVC.dataSource = @[@"智能排序",@"好评优先",@"离我最近"];
            _chooseVC.block = ^(NSString *value){
                [weakSelf.sortBtn setTitle:value forState:UIControlStateNormal];
                if ([value isEqualToString:@"智能排序"]) {
                    
                    weakSelf.sort = @"1";
                }else if ([value isEqualToString:@"好评优先"]){
                    weakSelf.sort = @"2";
                }else if ([value isEqualToString:@"离我最近"]){
                    weakSelf.sort = @"3";
                }

                [weakSelf updateData:YES];
                [weakSelf dismiss];
            };
        }
            break;
            
        default:
            break;
    }
    
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
                        if (_chooseVC.dataSource.count < 8) {
                _chooseVC.view.yy_height = _chooseVC.dataSource.count * 44;
            }else{
                _chooseVC.view.yy_height = SCREEN_HEIGHT * 0.5;
            }

        }];

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            
            _chooseVC.view.yy_height = 0;
            
        } completion:^(BOOL finished) {
            
            _maskV.alpha = 0;
        }];

    }
    
    [_chooseVC.tableView reloadData];
}
#pragma UITableviewDelegate UITableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLNearby_MerchatListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (self.models.count != 0) {
        
        cell.model = self.models[indexPath.row];
    }
    cell.selectionStyle = 0;
    cell.distanceLabel.hidden = YES;
    if ([self.sort integerValue] == 3) {
        cell.distanceLabel.hidden = NO;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}


- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
@end
