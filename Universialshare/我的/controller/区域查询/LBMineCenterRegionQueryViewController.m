//
//  LBMineCenterRegionQueryViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterRegionQueryViewController.h"
#import "LBMineCenterRegionQueryTableViewCell.h"
#import "LBMineCenterWantToSignUpViewController.h"

@interface LBMineCenterRegionQueryViewController ()

@property (weak, nonatomic) IBOutlet UIButton *chechBt;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *signUpBt;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@end

@implementation LBMineCenterRegionQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"区域查询";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterRegionQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterRegionQueryTableViewCell"];
    
    //    [self.tableview registerClass:[LBWaitOrdersHeaderView class] forHeaderFooterViewReuseIdentifier:@"LBWaitOrdersHeaderView"];
    
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
    
   // [self initdatasource];
    
    
    
}

-(void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/gain_list" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page]} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
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
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
    
}

//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
   // [self initdatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
   // [self initdatasource];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.nodataV.hidden = YES;
    return 10;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 150;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMineCenterRegionQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterRegionQueryTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}




//选择省
- (IBAction)tapgestureProvince:(UITapGestureRecognizer *)sender {
    
}
//选择市
- (IBAction)tapgestureCity:(UITapGestureRecognizer *)sender {
}
//选择区
- (IBAction)tapgestureArea:(UITapGestureRecognizer *)sender {
}
//查询
- (IBAction)queryEvent:(UIButton *)sender {
}
//我要报名
- (IBAction)signUpEvent:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterWantToSignUpViewController *vc=[[LBMineCenterWantToSignUpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.chechBt.layer.cornerRadius = 4;
    self.chechBt.clipsToBounds = YES;
    
    self.signUpBt.layer.cornerRadius = 4;
    self.signUpBt.clipsToBounds = YES;
    
    self.baseview.layer.cornerRadius = 4;
    self.baseview.clipsToBounds = YES;
    
    self.headerImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);

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
