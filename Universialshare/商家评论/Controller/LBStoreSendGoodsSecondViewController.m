//
//  LBStoreSendGoodsSecondViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreSendGoodsSecondViewController.h"
#import "LBStoreSendGoodsTableViewCell.h"
#import "UIView+TYAlertView.h"
#import "LBWaitOrdersModel.h"
#import "LBWaitOrdersHeaderView.h"
#import "LBSendGoodsProductModel.h"
#import "LBSendGoodsProductModel.h"

@interface LBStoreSendGoodsSecondViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@end
static NSString *ID = @"LBStoreSendGoodsTableViewCell";
@implementation LBStoreSendGoodsSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.tableview.tableFooterView = [UIView new];
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    
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
    
    [self initdatasource];
    
    
}

-(void)initdatasource{
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/arealySendOrder" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page]} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                for (int i = 0; i<[responseObject[@"data"] count]; i++) {
                    
                    LBWaitOrdersModel *ordersMdel=[[LBWaitOrdersModel alloc]init];
                    ordersMdel.creat_time = responseObject[@"data"][i][@"addtime"];
                    ordersMdel.order_id = responseObject[@"data"][i][@"order_id"];
                    ordersMdel.order_number = responseObject[@"data"][i][@"order_num"];
                    ordersMdel.order_type = responseObject[@"data"][i][@"order_type"];
                    ordersMdel.isExpanded = NO;
                    for (int j =0; j < [responseObject[@"data"][i][@"son"]count]; j++) {
                        LBSendGoodsProductModel   *listmodel = [LBSendGoodsProductModel mj_objectWithKeyValues:responseObject[@"data"][i][@"son"][j]];
                        [ordersMdel.dataArr addObject:listmodel];
                    }
                    [self.dataarr addObject:ordersMdel];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataarr.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    
    return self.dataarr.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    LBWaitOrdersModel *model = self.dataarr[section];
    return model.isExpanded ? model.dataArr.count : 0;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 100;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBStoreSendGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexpath = indexPath;
    LBWaitOrdersModel *model = self.dataarr[indexPath.section];
    cell.WaitOrdersListModel = model.dataArr[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 85;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LBWaitOrdersHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBWaitOrdersHeaderView"];
    
    if (!headerview) {
        headerview = [[LBWaitOrdersHeaderView alloc] initWithReuseIdentifier:@"LBWaitOrdersHeaderView"];
        
    }
    __weak typeof(self) weakself = self;
    LBWaitOrdersModel *sectionModel = self.dataarr[section];
    headerview.sectionModel = sectionModel;
    headerview.wuliuBt.hidden = YES;
    headerview.sureGetBt.hidden = YES;
    headerview.expandCallback = ^(BOOL isExpanded) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    return headerview;
    
}


-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    
    return _dataarr;
    
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}


@end
