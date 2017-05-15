//
//  LBProductManagementViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBProductManagementViewController.h"
#import "LBProductManagementTableViewCell.h"

@interface LBProductManagementViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *addProductBt;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@end

@implementation LBProductManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"区域查询";
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
}

//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
//    [self initdatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    // [self initdatasource];
}

//添加产品
- (IBAction)addProductEvent:(UIButton *)sender {
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (self.dataarr.count > 0) {
//        self.nodataV.hidden = YES;
//    }else{
//        self.nodataV.hidden = NO;
//    }
    self.nodataV.hidden = YES;
    return 10;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return 130;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBProductManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBProductManagementTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.addProductBt.layer.cornerRadius = 4;
    self.addProductBt.clipsToBounds = YES;


}

@end
