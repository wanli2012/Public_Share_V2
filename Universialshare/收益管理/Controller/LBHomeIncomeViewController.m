//
//  LBHomeIncomeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeIncomeViewController.h"
#import "LBHomeIncomeView.h"
#import "GLMerchant_IncomeCell.h"
#import "LBincomeHeaderFooterView.h"
#import "LBIncomeChooseHeaderFooterView.h"
#import "HWCalendar.h"

@interface LBHomeIncomeViewController ()<UITableViewDelegate,UITableViewDataSource,LBIncomeChooseHeaderdelegete,LBincomeHeaderdelegete,HWCalendarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong , nonatomic)LBHomeIncomeView *headview;
@property(nonatomic , strong) UIButton *backbutton;//返回

@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;
@property (assign, nonatomic)NSInteger timeBtIndex;//判断选择的按钮时哪一个

@property (nonatomic, assign)int page;//线上页数
@property (nonatomic, assign)int pageUnder;//线下页数
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *dataArrUnder;
@property (nonatomic ,strong)NodataView *nodataV;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (assign, nonatomic)BOOL refreshTypeUnder;//判断刷新状态 默认为no

@property (strong, nonatomic)UIButton *curentBt;
@property (strong, nonatomic)NSString *startStr;
@property (strong, nonatomic)NSString *endStr;
@property (strong, nonatomic)NSString *startStrUnder;
@property (strong, nonatomic)NSString *endStrUnder;
@property (strong, nonatomic)NSString *otype;//1线上2线下

@property (strong, nonatomic)NSString *onlineMoney;//线上总额
@property (strong, nonatomic)NSString *underlineMoney;//线下总额

@end
static NSString *ID = @"GLMerchant_IncomeCell";
static const CGFloat headerHeight = 0.0f;

@implementation LBHomeIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
     [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    _page = 1;
    _refreshType = NO;
    self.startStr = @"";
    self.endStr = @"";
    self.startStrUnder = @"";
    self.endStrUnder = @"";
    self.otype = @"1";
    self.pageUnder = 1;
    self.onlineMoney = @"营业总额: ¥0";
    self.underlineMoney = @"营业总额: ¥0";
    [self.tableview addSubview:self.headview];
    [self.tableview addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.backbutton];
    self.backbutton.hidden = YES;
    self.tableview.contentInset=UIEdgeInsetsMake(headerHeight, 0, 0, 0);
    [self.tableview setTableHeaderView:self.headview];
    
    [self.view addSubview:self.CalendarView];
    
    self.CalendarView.hidden = YES;
    
    [self.CalendarView addSubview:self.Calendar];
    
    __weak typeof(self) weakself = self;
    _Calendar.returnCancel = ^(){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakself.CalendarView.hidden = YES;
        });
    };
    
    
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
    [NetworkManager requestPOSTWithURLStr:@"user/dealerList" paramDic:@{@"page":[NSNumber numberWithInteger:_page] , @"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token,@"starttime":self.startStr,@"endtime":self.endStr,@"otype":self.otype} finish:^(id responseObject)
     {
         
         [_loadV removeloadview];
         [self.tableview.mj_header endRefreshing];
         [self.tableview.mj_footer endRefreshing];
         if ([responseObject[@"code"] integerValue]==1) {
             self.headview.alllebel.text = [NSString stringWithFormat:@"营业总额: ¥%@",responseObject[@"total_money"]];
             self.onlineMoney = self.headview.alllebel.text;
             if (_refreshType == NO) {
                 [self.dataArr removeAllObjects];
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataArr addObjectsFromArray:responseObject[@"data"]];
                 }
                 
                 [self.tableview reloadData];
             }else{
                 
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataArr addObjectsFromArray:responseObject[@"data"]];
                 }
                 
                 [self.tableview reloadData];
                 
             }
             
         }else if ([responseObject[@"code"] integerValue]==3){
             
             [MBProgressHUD showError:responseObject[@"message"]];
             
         }else{
             [MBProgressHUD showError:responseObject[@"message"]];
             
         }
     } enError:^(NSError *error) {
         [_loadV removeloadview];
         [self.tableview.mj_header endRefreshing];
         [self.tableview.mj_footer endRefreshing];
         [MBProgressHUD showError:error.localizedDescription];
         
     }];
    
    
}

-(void)initdatasourceOne{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/dealerList" paramDic:@{@"page":[NSNumber numberWithInteger:_pageUnder] , @"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token,@"starttime":self.startStrUnder,@"endtime":self.endStrUnder,@"otype":self.otype} finish:^(id responseObject)
     {
         
         [_loadV removeloadview];
         [self.tableview.mj_header endRefreshing];
         [self.tableview.mj_footer endRefreshing];
        
         if ([responseObject[@"code"] integerValue]==1) {
             self.headview.alllebel.text = [NSString stringWithFormat:@"营业总额: ¥%@",responseObject[@"total_money"]];
             self.underlineMoney = self.headview.alllebel.text;
             if (_refreshTypeUnder == NO) {
                 [self.dataArrUnder removeAllObjects];
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataArrUnder addObjectsFromArray:responseObject[@"data"]];
                 }
                 
                 [self.tableview reloadData];
             }else{
                 
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataArrUnder addObjectsFromArray:responseObject[@"data"]];
                 }
                 
                 [self.tableview reloadData];
                 
             }
             
         }else if ([responseObject[@"code"] integerValue]==3){
             
             [MBProgressHUD showError:responseObject[@"message"]];
             
         }else{
             [MBProgressHUD showError:responseObject[@"message"]];
             
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
    if ([self.otype isEqualToString:@"1"]) {
        _refreshType = NO;
        _page=1;
        
        [self initdatasource];
    }else{
        _refreshTypeUnder = NO;
        _pageUnder=1;
        
        [self initdatasourceOne];
    }
}
//上啦刷新
-(void)footerrefresh{
    
    if ([self.otype isEqualToString:@"1"]) {
        _refreshType = YES;
        _page++;
        
        [self initdatasource];
    }else{
        _refreshTypeUnder = YES;
        _pageUnder++;
        
        [self initdatasourceOne];
    }
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    if (self.tableview.contentOffset.y > 300) {
        self.backbutton.hidden = NO;
    }else{
        self.backbutton.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.backbutton.hidden = YES;

}

#pragma UITableviewDelegate UITableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.otype isEqualToString:@"1"]) {
        if (self.dataArr.count <= 0) {
            self.nodataV.hidden = YES;
        }else{
            self.nodataV.hidden = YES;
        }
        if (section == 1) {
            return 10;
        }
    }else{
        if (self.dataArrUnder.count <= 0) {
            self.nodataV.hidden = YES;
        }else{
            self.nodataV.hidden = YES;
        }
        if (section == 1) {
            return self.dataArrUnder.count;
        }
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMerchant_IncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return 100;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        LBincomeHeaderFooterView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBincomeHeaderFooterView"];
        if (!headerview) {
            headerview = [[LBincomeHeaderFooterView alloc] initWithReuseIdentifier:@"LBincomeHeaderFooterView"];
            
        }
        headerview.delegete = self;
        if ([self.otype isEqualToString:@"1"]) {
            if ([self.startStr isEqualToString:@""]) {
                [headerview.startBt setTitle:@"请选择开始时间" forState:UIControlStateNormal];
            }else{
                [headerview.startBt setTitle:self.startStr forState:UIControlStateNormal];
            }
            if ([self.endStr isEqualToString:@""]) {
                [headerview.endBt setTitle:@"请选择结束时间" forState:UIControlStateNormal];
            }else{
                [headerview.endBt setTitle:self.endStr forState:UIControlStateNormal];
            }
        }else{
            if ([self.startStrUnder isEqualToString:@""]) {
                [headerview.startBt setTitle:@"请选择开始时间" forState:UIControlStateNormal];
            }else{
                [headerview.startBt setTitle:self.startStrUnder forState:UIControlStateNormal];
            }
            if ([self.endStrUnder isEqualToString:@""]) {
                [headerview.endBt setTitle:@"请选择结束时间" forState:UIControlStateNormal];
            }else{
                [headerview.endBt setTitle:self.endStrUnder forState:UIControlStateNormal];
            }
        }
        return headerview;
    }else if (section == 1){
        LBIncomeChooseHeaderFooterView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBIncomeChooseHeaderFooterView"];
        if (!headerview) {
            headerview = [[LBIncomeChooseHeaderFooterView alloc] initWithReuseIdentifier:@"LBIncomeChooseHeaderFooterView"];
            
        }
        headerview.delegete = self;
        
        return headerview;
    
    }
    
    return nil;
    
}

#pragma mark ----- LBIncomeChooseHeaderdelegete
//点击线上
-(void)clickonlinebutton{
    self.otype = @"1";
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    if (self.dataArr.count <= 0) {
        [self initdatasource];
 
    }else{
        [self.tableview reloadData];
    }
    self.headview.alllebel.text = self.onlineMoney;
}
//点击线下
-(void)clickunderlinebutton{
    self.otype = @"2";
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
    
    if (self.dataArrUnder.count <= 0) {
        [self initdatasourceOne];
    }else{
        [self.tableview reloadData];
    }
    self.headview.alllebel.text = self.underlineMoney;
    
}
#pragma mark ----- LBincomeHeaderdelegete
//选择开始时间
-(void)clickstartTimebutton:(UIButton *)buton{
    _timeBtIndex = 1;
    self.curentBt = buton;
    self.CalendarView.hidden = NO;
    [_Calendar show];
}
//选择结束时间
-(void)clickendTimebutton:(UIButton *)buton{
    _timeBtIndex = 2;
    self.curentBt = buton;
    self.CalendarView.hidden = NO;
    [_Calendar show];
}
//搜索
-(void)clickSearchbutton:(UIButton *)button otherbutton:(UIButton *)button1{

    if ([self.startStr isEqualToString:@""]) {
        [MBProgressHUD showError:@"还没有选择起始日期"];
        return;
    }
    if([self.endStr isEqualToString:@""]){
        [MBProgressHUD showError:@"还没有选择截止日期"];
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *date1 = [dateFormatter dateFromString:self.startStr];
    NSDate *date2 = [dateFormatter dateFromString:self.endStr];
    if ([[NSString stringWithFormat:@"%d",[self compareOneDay:date1 withAnotherDay:date2]] isEqualToString:@"1"]) {
        //NSLog(@"date1 > date2");
        
        [MBProgressHUD showError:@"开始时间过大"];
        
    }else if ([[NSString stringWithFormat:@"%d",[self compareOneDay:date1 withAnotherDay:date2]] isEqualToString:@"-1"]){
       // NSLog(@"date1 < date2");
        
        [self initdatasource];
        
    }else{
        //NSLog(@"date1 = date2");
        [MBProgressHUD showError:@"选择的时间相等"];
    }
    

}
//返回顶部
-(void)backHomeBtbtton{
   [self.tableview setContentOffset:CGPointMake(0, -headerHeight) animated:YES];

}

#pragma mark - HWCalendarDelegate
- (void)calendar:(HWCalendar *)calendar didClickSureButtonWithDate:(NSString *)date
{
    

    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.CalendarView.hidden = YES;
    });
    
    if ([self.otype isEqualToString:@"1"]) {
        if (_timeBtIndex == 1) {
            
            [self.curentBt setTitle:date forState:UIControlStateNormal];
            self.startStr = date;
            
        }else if (_timeBtIndex == 2){
            
            [self.curentBt setTitle:date forState:UIControlStateNormal];
            self.endStr = date;
        }
    }else{
        if (_timeBtIndex == 1) {
            
            [self.curentBt setTitle:date forState:UIControlStateNormal];
            self.startStrUnder = date;
            
        }else if (_timeBtIndex == 2){
            
            [self.curentBt setTitle:date forState:UIControlStateNormal];
            self.endStrUnder = date;
        }
    }
}

#pragma mark - 时间比较大小
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //oneDay > anotherDay
        return 1;
    }
    else if (result == NSOrderedAscending){
        //oneDay < anotherDay
        return -1;
    }
    //oneDay = anotherDay
    return 0;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y > 300) {
        self.backbutton.hidden = NO;
    }else{
        self.backbutton.hidden = YES;
    }
    
}

-(LBHomeIncomeView*)headview{

    if (!_headview) {
        _headview = [[LBHomeIncomeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    }
    return _headview;
}

-(UIButton*)backbutton{
    
    if (!_backbutton) {
        _backbutton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 100, 30, 30)];
        _backbutton.backgroundColor=[UIColor clearColor];
        [_backbutton setImage:[UIImage imageNamed:@"backtop_icon"] forState:UIControlStateNormal];
        _backbutton.titleLabel.font=[UIFont systemFontOfSize:12];
        [_backbutton addTarget:self action:@selector(backHomeBtbtton) forControlEvents:UIControlEventTouchUpInside];
        [_backbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _backbutton.layer.cornerRadius =15;
        _backbutton.clipsToBounds =YES;
    }
    
    return _backbutton;
    
}
-(UIView*)CalendarView{
    
    if (!_CalendarView) {
        _CalendarView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _CalendarView.backgroundColor=YYSRGBColor(0, 0, 0, 0.2);
    }
    return _CalendarView;
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_HEIGHT-264);
    }
    return _nodataV;
    
}

-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray*)dataArrUnder{
    if (!_dataArrUnder) {
        _dataArrUnder = [NSMutableArray array];
    }
    return _dataArrUnder;
}

-(HWCalendar*)Calendar{
    
    if (!_Calendar) {
        _Calendar=[[HWCalendar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH , (SCREEN_WIDTH * 0.8)/7 * 9.5)];
        _Calendar.delegate = self;
        _Calendar.showTimePicker = YES;
        
    }
    return _Calendar;
}
@end
