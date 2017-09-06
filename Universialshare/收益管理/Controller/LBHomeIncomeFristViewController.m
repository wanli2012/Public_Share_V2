//
//  LBHomeIncomeFristViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeIncomeFristViewController.h"
#import "LBHomeIncomeView.h"
#import "GLMerchant_IncomeCell.h"
#import "LBincomeHeaderFooterView.h"
#import "LBIncomeChooseHeaderFooterView.h"
#import "HWCalendar.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LBApplicationLimitView.h"
#import "SelectUserTypeView.h"

@interface LBHomeIncomeFristViewController ()<UITableViewDelegate,UITableViewDataSource,LBincomeHeaderdelegete,HWCalendarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong , nonatomic)LBHomeIncomeView *headview;
@property(nonatomic , strong) UIButton *backbutton;//返回

@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;
@property (assign, nonatomic)NSInteger timeBtIndex;//判断选择的按钮时哪一个

@property (nonatomic, assign)int page;//线上页数
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)NodataView *nodataV;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no

@property (strong, nonatomic)UIButton *curentBt;
@property (strong, nonatomic)NSString *startStr;
@property (strong, nonatomic)NSString *endStr;
@property (strong, nonatomic)NSString *otype;//1线上2线下

@property (strong, nonatomic)NSString *onlineMoney;//线上总额
@property (assign, nonatomic)BOOL  showSearch;//是否展示搜索

@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)LBApplicationLimitView *loginView;
@property (strong, nonatomic)SelectUserTypeView *selectUserTypeView;
@property (nonatomic, copy)NSString *type;//限额类型

@end
static NSString *ID = @"GLMerchant_IncomeCell";
static NSString *searchID = @"LBincomeHeaderFooterView";
static const CGFloat headerHeight = 0.0f;

@implementation LBHomeIncomeFristViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];

    _page = 1;
    _refreshType = NO;
    self.startStr = @"";
    self.endStr = @"";
    self.otype = @"1";
    self.type = @"1";
    self.onlineMoney = @"营业总额: ¥0";
    [self.tableview addSubview:self.headview];
    [self.tableview addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    [self.view addSubview:self.backbutton];
    self.tableview.contentInset=UIEdgeInsetsMake(headerHeight, 0, 0, 0);
    [self.tableview setTableHeaderView:self.headview];
    
    //[self.view addSubview:self.CalendarView];
     [[UIApplication sharedApplication].keyWindow addSubview:self.CalendarView];
    
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSearchView:) name:@"LBHomeIncomeFristViewController" object:nil];
    UITapGestureRecognizer *maskvgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskviewgesture)];
    [self.maskView addGestureRecognizer:maskvgesture];
}

-(void)initdatasource{
    
    NSString *startTime = @"";
    NSString *endTime = @"";
    if (![self.startStr isEqualToString:@""] && ![self.endStr isEqualToString:@""]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *date1 = [dateFormatter dateFromString:self.startStr];
        NSDate *date2 = [dateFormatter dateFromString:self.endStr];
        //转成时间戳
        startTime = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
        endTime = [NSString stringWithFormat:@"%ld", (long)[date2 timeIntervalSince1970]];
        
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getProfitShopList" paramDic:@{@"page":[NSNumber numberWithInteger:_page] ,
                                                                               @"uid":[UserModel defaultUser].uid ,  @"token":[UserModel defaultUser].token,@"starttime":startTime,
                                                                               @"endtime":endTime,
                                                                               @"otype":self.otype} finish:^(id responseObject)
     {
         
         [_loadV removeloadview];
         [self.tableview.mj_header endRefreshing];
         [self.tableview.mj_footer endRefreshing];
         if ([responseObject[@"code"] integerValue]==1) {
             if ([responseObject[@"total_money"] integerValue] <= 10000) {
                 self.headview.alllebel.text = [NSString stringWithFormat:@"营业总额: ¥%.2f",[responseObject[@"total_money"] floatValue] ];
             }else{
                 self.headview.alllebel.text = [NSString stringWithFormat:@"营业总额: ¥%.2f万",[responseObject[@"total_money"] floatValue] / 10000];
             }
             self.onlineMoney = self.headview.alllebel.text;
             if (_refreshType == NO) {
                 [self.dataArr removeAllObjects];
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataArr addObjectsFromArray:responseObject[@"data"]];
                 }
                 
             }else{
                 
                 if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                     [self.dataArr addObjectsFromArray:responseObject[@"data"]];
                 }
                 
             }
             
         }else if ([responseObject[@"code"] integerValue]==3){
             if (_refreshType == NO) {
                 [self.dataArr removeAllObjects];
                 
             }
             [MBProgressHUD showError:responseObject[@"message"]];
             
         }else{
             [MBProgressHUD showError:responseObject[@"message"]];
             
         }
         [self.tableview reloadData];
     } enError:^(NSError *error) {
         [self.tableview reloadData];
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


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([[UserModel defaultUser].isapplication isEqualToString:@"1"]) {
        [self.backbutton setTitle:[NSString stringWithFormat:@"等待\n审核"] forState:UIControlStateNormal];
        self.backbutton.userInteractionEnabled = NO;
    }else{
        [self.backbutton setTitle:[NSString stringWithFormat:@"申请\n额度"] forState:UIControlStateNormal];
        self.backbutton.userInteractionEnabled = YES;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

#pragma UITableviewDelegate UITableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  
        if (self.dataArr.count <= 0) {
            self.nodataV.hidden = NO;
        }else{
            self.nodataV.hidden = YES;
        }
    
    
    return self.dataArr.count + 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( indexPath.row == 0) {
        LBincomeHeaderFooterView *cell = [tableView dequeueReusableCellWithIdentifier:searchID];
        if (!cell) {
            cell = [[LBincomeHeaderFooterView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegete = self;
        
        if (self.showSearch == YES) {
            cell.hidden = NO;
        }else{
           cell.hidden = YES;
        }
        return cell;
    }else{
        GLMerchant_IncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.iamgev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row-1][@"thumb"]]] placeholderImage:[UIImage imageNamed:@"planceholder"]];
        cell.namelb.text = [NSString stringWithFormat:@"商品名:%@",self.dataArr[indexPath.row-1][@"goods_name"]];
        cell.codelb.text = [NSString stringWithFormat:@"数量:%@",self.dataArr[indexPath.row-1][@"goods_num"]];
        cell.orderlb.text = [NSString stringWithFormat:@"让利模式:%@",self.dataArr[indexPath.row-1][@"rl_type"]];
        
        if ([self.dataArr[indexPath.row-1][@"rl_money"] integerValue] <= 10000) {
            cell.rlbael.text = [NSString stringWithFormat:@"让利额:¥%@",self.dataArr[indexPath.row-1][@"rl_money"]];
        }else{
            
            cell.rlbael.text = [NSString stringWithFormat:@"让利额: ¥%.2f万",[self.dataArr[indexPath.row-1][@"rl_money"] floatValue] / 10000];
        }
        if ([self.dataArr[indexPath.row-1][@"total_money"] integerValue] <= 10000) {
            cell.moneylb.text = [NSString stringWithFormat:@"价格:¥%@",self.dataArr[indexPath.row-1][@"total_money"]];
        }else{
            
            cell.moneylb.text = [NSString stringWithFormat:@"价格: ¥%.2f万",[self.dataArr[indexPath.row-1][@"total_money"] floatValue] / 10000];
        }
        return cell;
    }

    return [[UITableViewCell alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.showSearch == YES && indexPath.row == 0) {
        return 50;
    }else if (self.showSearch == NO && indexPath.row == 0){
        return 0;
    }
    return 100;
    
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
   
    NSDate *date1;
    NSDate *date2;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        date1 = [dateFormatter dateFromString:self.startStr];
        date2 = [dateFormatter dateFromString:self.endStr];
    
    if ([[NSString stringWithFormat:@"%d",[self compareOneDay:date1 withAnotherDay:date2]] isEqualToString:@"1"]) {
        //NSLog(@"date1 > date2");
        
        [MBProgressHUD showError:@"开始时间不对"];
        
    }else if ([[NSString stringWithFormat:@"%d",[self compareOneDay:date1 withAnotherDay:date2]] isEqualToString:@"-1"]){
        // NSLog(@"date1 < date2");
            [self initdatasource];
    }else{
        //NSLog(@"date1 = date2");
       [self initdatasource];
    }
    
    
}
//返回顶部
-(void)backHomeBtbtton{

    [self.view addSubview:self.maskView];
    [self.view addSubview:self.loginView];
}

#pragma mark - HWCalendarDelegate
- (void)calendar:(HWCalendar *)calendar didClickSureButtonWithDate:(NSString *)date
{
    
    
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.CalendarView.hidden = YES;
    });
    
        if (_timeBtIndex == 1) {
            
            [self.curentBt setTitle:date forState:UIControlStateNormal];
            self.startStr = date;
            
        }else if (_timeBtIndex == 2){
            
            [self.curentBt setTitle:date forState:UIControlStateNormal];
            self.endStr = date;
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

-(void)showSearchView:(NSNotification*)noti{

    NSDictionary *dic = noti.userInfo;
    BOOL b=[dic[@"show"]boolValue];
     self.showSearch = b;
    if (b == YES) {
         [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationRight];
    }else{
        self.startStr = @"";
        self.endStr = @"";
        self.refreshType =NO;
        self.page =1;
        [self initdatasource];
        [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationRight];
    }
   
}

//确认申请
-(void)sureapplication{
    
    if (self.loginView.phoneTf.text .length <= 0) {
        [MBProgressHUD showError:@"手机号异常"];
        return;
    }
    if (self.loginView.yzmTf.text .length <= 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    if (self.loginView.moneyTF.text .length <= 0) {
        [MBProgressHUD showError:@"请输入申请额度"];
        return;
    }
    
    if ([self.loginView.moneyTF.text  floatValue] <= [[UserModel defaultUser].allLimit floatValue]) {
        [MBProgressHUD showError:@"输入大于当前额度"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"yzm"] = self.loginView.yzmTf.text;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"userphone"] = [UserModel defaultUser].phone;
    dict[@"money"] = self.loginView.moneyTF.text;

    dict[@"type"] = self.type;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/applyMoreSaleMoney" paramDic:dict finish:^(id responseObject)
     {
         
         [_loadV removeloadview];
         
         if ([responseObject[@"code"] integerValue]==1) {
             [self maskviewgesture];
             [self.backbutton setTitle:[NSString stringWithFormat:@"等待\n审核"] forState:UIControlStateNormal];
             self.backbutton.userInteractionEnabled = NO;
             [UserModel defaultUser].isapplication = @"1";
             [usermodelachivar achive];
             [MBProgressHUD showError:responseObject[@"message"]];
    
         }else{
             
             [MBProgressHUD showError:responseObject[@"message"]];
         }
         
     } enError:^(NSError *error) {
         [_loadV removeloadview];
         [MBProgressHUD showError:error.localizedDescription];
     }];
    
}

//点击maskview
-(void)maskviewgesture{
    
    [self.selectUserTypeView removeFromSuperview];
    [self.maskView removeFromSuperview];
    [self.loginView removeFromSuperview];
    
}

//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.loginView.yzmbt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.loginView.yzmbt.userInteractionEnabled = YES;
                self.loginView.yzmbt.backgroundColor = TABBARTITLE_COLOR;
                self.loginView.yzmbt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loginView.yzmbt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.loginView.yzmbt.userInteractionEnabled = NO;
                self.loginView.yzmbt.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.loginView.yzmbt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (void)getcode:(UIButton *)sender {
    
    if (![predicateModel valiMobile:[UserModel defaultUser].phone]) {
        [MBProgressHUD showError:@"手机号格式不对"];
        return;
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"User/get_yzm" paramDic:@{@"phone":[UserModel defaultUser].phone} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
}

-(LBApplicationLimitView*)loginView{
    
    if (!_loginView) {
        _loginView = [[NSBundle mainBundle]loadNibNamed:@"LBApplicationLimitView" owner:self options:nil].firstObject;
        _loginView.frame = CGRectMake(20, (SCREEN_HEIGHT - 64 - 280)/2, SCREEN_WIDTH-40, 280);
        _loginView.alpha = 1;
        _loginView.layer.cornerRadius = 4;
        _loginView.clipsToBounds = YES;
        [_loginView.yzmbt addTarget:self action:@selector(getcode:) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.cancelBt addTarget:self action:@selector(maskviewgesture) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.sureBt addTarget:self action:@selector(sureapplication) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popTypeView)];
        [_loginView.typeView addGestureRecognizer:tap];
        _loginView.typeLabel.text = @"每日限额";
        _loginView.phoneTf.text = [NSString stringWithFormat:@"%@*****%@",[[UserModel defaultUser].phone substringToIndex:3],[[UserModel defaultUser].phone substringFromIndex:7]];
    }
    return _loginView;
    
}

//弹出限额类型选择View
- (void)popTypeView {
    
    [self.loginView addSubview:self.selectUserTypeView];
    
    __weak typeof(self) weakSelf = self;
    
    self.selectUserTypeView.block = ^(NSInteger index){
        
        if(index == 0){
            
            weakSelf.type = @"1";
            weakSelf.loginView.typeLabel.text = @"每日限额";
            
        }else{
            
            weakSelf.type = @"2";
            weakSelf.loginView.typeLabel.text = @"每单限额";
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.selectUserTypeView.height = 0;
            weakSelf.selectUserTypeView.tableView.height = 0;
            weakSelf.selectUserTypeView.alpha = 0;
        }];
    };
    
    if (self.selectUserTypeView.height == 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.selectUserTypeView.height = 80;
            weakSelf.selectUserTypeView.tableView.height = 80;
            weakSelf.selectUserTypeView.alpha = 1;
        }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.selectUserTypeView.height = 0;
            weakSelf.selectUserTypeView.tableView.height = 0;
            weakSelf.selectUserTypeView.alpha = 0;
        }];
    }
}

//限额选择View
-(SelectUserTypeView*)selectUserTypeView{
    
    if (!_selectUserTypeView) {
        
        _selectUserTypeView=[[NSBundle mainBundle] loadNibNamed:@"SelectUserTypeView" owner:self options:nil].firstObject;
        
        _selectUserTypeView.layer.cornerRadius = 10.f;
        _selectUserTypeView.clipsToBounds = YES;
        _selectUserTypeView.frame=CGRectMake(100, 150, SCREEN_WIDTH - 40 - 110, 0);
        _selectUserTypeView.dataSoure  = @[@"每日限额",@"每单限额"];
        
    }
    
    return _selectUserTypeView;
    
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];
        
    }
    return _maskView;
    
}

-(LBHomeIncomeView*)headview{
    
    if (!_headview) {
        _headview = [[LBHomeIncomeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    }
    return _headview;
}

-(UIButton*)backbutton{
    
    if (!_backbutton) {
        _backbutton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, SCREEN_HEIGHT - 150, 60, 60)];
        _backbutton.backgroundColor=YYSRGBColor(120,161,255, 0.8);
        _backbutton.titleLabel.font=[UIFont systemFontOfSize:13];
        [_backbutton addTarget:self action:@selector(backHomeBtbtton) forControlEvents:UIControlEventTouchUpInside];
        [_backbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backbutton.layer.cornerRadius =30;
        _backbutton.clipsToBounds =YES;
         _backbutton.titleLabel.numberOfLines = 0;
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

-(HWCalendar*)Calendar{
    
    if (!_Calendar) {
        _Calendar=[[HWCalendar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH , (SCREEN_WIDTH * 0.8)/7 * 9.5)];
        _Calendar.delegate = self;
        _Calendar.showTimePicker = YES;
        
    }
    return _Calendar;
}



@end
