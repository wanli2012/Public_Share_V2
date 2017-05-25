//
//  GLMemberManagerController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMemberManagerController.h"
#import "GLMemberManagerCell.h"
#import "GLConsumerRecordController.h"

@interface GLMemberManagerController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic)UIButton *currentbutton;//当前按钮

@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)NSInteger pageone;//页数默认为1
@property (assign, nonatomic)NSInteger currentPage;//当前页数
@property (assign, nonatomic)NSInteger type;//1:锁定会员  2平台会员

@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (nonatomic, strong)NSMutableArray *models;//锁定会员数据
@property (nonatomic, strong)NSMutableArray *modelsone;//平台会员数据
@property (strong, nonatomic)NodataView *nodataV;
@end

static NSString *ID = @"GLMemberManagerCell";
@implementation GLMemberManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员管理";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.page = 1;
    self.pageone = 1;
    self.type = 1;
    self.currentbutton = self.leftBtn;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMemberManagerCell" bundle:nil] forCellReuseIdentifier:ID];

    [self.tableView addSubview:self.nodataV];
    [self initdatasorce];
    
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
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;

}
//初始化数据
-(void)initdatasorce{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/getTjUserList" paramDic:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid,@"page":[NSNumber numberWithInteger:self.currentPage],@"type":[NSNumber numberWithInteger:self.type]} finish:^(id responseObject)
     {
         
         [_loadV removeloadview];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         if ([responseObject[@"code"] integerValue]==1) {
             
             if (self.currentbutton == self.leftBtn) {
                
                 if (_refreshType == NO) {
                     [self.models removeAllObjects];
                     if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                         [self.models addObjectsFromArray:responseObject[@"data"]];
                     }
                     
                     [self.tableView reloadData];
                 }else{
                     
                     if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                         [self.models addObjectsFromArray:responseObject[@"data"]];
                     }
                     
                     [self.tableView reloadData];
                     
                 }
             }else{
             
                 if (_refreshType == NO) {
                     [self.modelsone removeAllObjects];
                     if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                         [self.modelsone addObjectsFromArray:responseObject[@"data"]];
                     }
                     
                     [self.tableView reloadData];
                 }else{
                     
                     if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                         [self.modelsone addObjectsFromArray:responseObject[@"data"]];
                     }
                     
                     [self.tableView reloadData];
                     
                 }
             }
             
         }else if ([responseObject[@"code"] integerValue]==3){
             
             [MBProgressHUD showError:responseObject[@"message"]];
             
         }else{
             [MBProgressHUD showError:responseObject[@"message"]];
             
             
         }
     } enError:^(NSError *error) {
         [_loadV removeloadview];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         [MBProgressHUD showError:error.localizedDescription];
         
     }];
    
    
}

//下拉刷新
-(void)loadNewData{
    
    if (self.currentbutton == self.leftBtn) {
        _refreshType = NO;
        _page=1;
        _currentPage = _page;
    }else{
        _refreshType = NO;
        _pageone=1;
        _currentPage = _pageone;
    }
    
    [self initdatasorce];
}
//上啦刷新
-(void)footerrefresh{
    if (self.currentbutton == self.leftBtn) {
        _refreshType = YES;
        _page++;
    }else{
        _refreshType = YES;
        _pageone++;
    }
    
    [self initdatasorce];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)typeChoose:(UIButton *)sender {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (sender == self.leftBtn) {
        self.currentbutton = self.leftBtn;
        self.type = 1;
        [self.leftBtn setTitleColor:YYSRGBColor(26, 183, 58, 1) forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (self.models.count <= 0) {
            _refreshType = NO;
            _page=1;
             _currentPage = _page;
            [self initdatasorce];
            return;
        }
    }else{
        self.currentbutton = self.rightBtn;
        self.type = 2;
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:YYSRGBColor(26, 183, 58, 1) forState:UIControlStateNormal];
        if (self.models.count <= 0) {
            _refreshType = NO;
            _pageone=1;
             _currentPage = _pageone;
            [self initdatasorce];
            return;
        }
    }
    
    [self.tableView reloadData];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentbutton == self.leftBtn?self.models.count:self.modelsone.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMemberManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = 0;
    
    if (self.type == 1) {
        
        cell.allMoenyLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"totalPrice"]];
        cell.bonusLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"goods_fl"]];
        cell.nameLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"truename"]];
        cell.phoneLb.text = [NSString stringWithFormat:@"%@",self.models[indexPath.row][@"phone"]];
        
    }else{
        cell.allMoenyLb.text = [NSString stringWithFormat:@"%@",self.modelsone[indexPath.row][@"totalPrice"]];
        cell.bonusLb.text = [NSString stringWithFormat:@"%@",self.modelsone[indexPath.row][@"goods_fl"]];
        cell.nameLb.text = [NSString stringWithFormat:@"%@",self.modelsone[indexPath.row][@"truename"]];
        cell.phoneLb.text = [NSString stringWithFormat:@"%@",self.modelsone[indexPath.row][@"phone"]];
    
    }
    
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    GLConsumerRecordController *consumerVC = [[GLConsumerRecordController alloc] init];
    [self.navigationController pushViewController:consumerVC animated:YES];
}







- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}

- (NSMutableArray *)modelsone{
    if (!_modelsone) {
        _modelsone = [NSMutableArray array];
        
    }
    return _modelsone;
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}
@end
