//
//  GLIncomeManagerController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIncomeManagerController.h"
#import "GLIncomeManagerCell.h"
#import "GLIncomeManagerModel.h"
#import "HWCalendar.h"

@interface GLIncomeManagerController ()<UITableViewDelegate,UITableViewDataSource,HWCalendarDelegate>
{
    GLIncomeManagerModel *_model;
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeTwoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeOneBtnWidth;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (assign, nonatomic)NSInteger timeBtIndex;//判断选择的按钮时哪一个
@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;

@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic ,strong)NodataView *nodataV;
@end

static NSString *ID = @"GLIncomeManagerCell";
@implementation GLIncomeManagerController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"收益管理";
    
    self.queryBtn.layer.cornerRadius = 5.f;
    self.queryBtn.clipsToBounds = YES;
    self.timeOneBtn.layer.borderWidth = 1;
    self.timeOneBtn.layer.borderColor = YYSRGBColor(184, 184, 184, 0.3).CGColor;
    self.timeTwoBtn.layer.borderWidth = 1;
    self.timeTwoBtn.layer.borderColor = YYSRGBColor(184, 184, 184, 0.3).CGColor;
    self.timeOneBtnWidth.constant = 85 * autoSizeScaleX;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIncomeManagerCell" bundle:nil] forCellReuseIdentifier:ID];
    _model = [[GLIncomeManagerModel alloc] init];
    _model.shop_name = @"你哈也的你大爷街";
    _model.shop_address = @"天府三街中百大道天府三街中百街中";
    
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
        
        [weakSelf updateData:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateData:NO];
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    [self updateData:YES];
}

//选择日期
- (IBAction)timeChoose:(id)sender {
    
    if (sender == self.timeOneBtn) {
        _timeBtIndex = 1;
    }else{
        _timeBtIndex = 2;
    }
    self.CalendarView.hidden = NO;
    [_Calendar show];

}

- (void)endRefresh {
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    
}

- (void)updateData:(BOOL)status {
    
    if (status) {
        
        _page = 1;
        [self.models removeAllObjects];
        
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"page"] = [NSString stringWithFormat:@"%d",_page];
    
    NSString *startTime = @"";
    NSString *endTime = @"";
    if (![self.timeOneBtn.titleLabel.text isEqualToString:@"起始日期"] && ![self.timeTwoBtn.titleLabel.text isEqualToString:@"截止日期"]) {
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *date1 = [dateFormatter dateFromString:self.timeOneBtn.titleLabel.text];
        NSDate *date2 = [dateFormatter dateFromString:self.timeTwoBtn.titleLabel.text];
        //转成时间戳
        startTime = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
        endTime = [NSString stringWithFormat:@"%ld", (long)[date2 timeIntervalSince1970]];
        
    }

    dict[@"starttime"] = startTime;
    dict[@"endtime"] = endTime;
    
//    NSLog(@"dict = %@",dict);
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"user/getProfitList" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        //        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLIncomeManagerModel *model = [GLIncomeManagerModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
            }

            
        }else if([responseObject[@"code"] integerValue] == 3){
            
            [MBProgressHUD showError:@"已经没有更多数据了"];
        }
        
        if (self.models.count <= 0 ) {
            self.nodataV.hidden = NO;
        }else{
            self.nodataV.hidden = YES;
        }

        self.totalLabel.text =[NSString stringWithFormat:@"%@",responseObject[@"total_money"]];
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [self endRefresh];
        [_loadV removeloadview];
        self.nodataV.hidden = NO;
        [MBProgressHUD showError:error.localizedDescription];
    }];
}
//查询
- (IBAction)queryRequest:(id)sender {
    if ([self.timeOneBtn.titleLabel.text isEqualToString:@"起始日期"]) {
        [MBProgressHUD showError:@"还没有选择起始日期"];
        return;
    }
    if([self.timeTwoBtn.titleLabel.text isEqualToString:@"截止日期"]){
        [MBProgressHUD showError:@"还没有选择截止日期"];
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *date1 = [dateFormatter dateFromString:self.timeOneBtn.titleLabel.text];
    NSDate *date2 = [dateFormatter dateFromString:self.timeTwoBtn.titleLabel.text];
    if ([[NSString stringWithFormat:@"%d",[self compareOneDay:date1 withAnotherDay:date2]] isEqualToString:@"1"]) {
        
        NSLog(@"date1 > date2");
        
    }else if ([[NSString stringWithFormat:@"%d",[self compareOneDay:date1 withAnotherDay:date2]] isEqualToString:@"-1"]){
        
        NSLog(@"date1 < date2");
        
        [self updateData:YES];

    }else{
        
        NSLog(@"date1 = date2");
    }

}



#pragma UITableviewDelegate UITableviewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLIncomeManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
//    cell.nameLabel.text = _model.shop_name;
//    cell.addressLabel.text = _model.shop_address;
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        
    self.tableView.estimatedRowHeight = 64;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
   
    return self.tableView.rowHeight;
    
}
#pragma mark - HWCalendarDelegate
- (void)calendar:(HWCalendar *)calendar didClickSureButtonWithDate:(NSString *)date
{
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.CalendarView.hidden = YES;
    });
    
    if (_timeBtIndex == 1) {
        
        [self.timeOneBtn setTitle:date forState:UIControlStateNormal];
        
    }else if (_timeBtIndex == 2){
        
        [self.timeTwoBtn setTitle:date forState:UIControlStateNormal];
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

-(HWCalendar*)Calendar{
    
    if (!_Calendar) {
        _Calendar=[[HWCalendar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH , (SCREEN_WIDTH * 0.8)/7 * 9.5)];
        _Calendar.delegate = self;
        _Calendar.showTimePicker = YES;
    }
    return _Calendar;
}

-(UIView*)CalendarView{
    
    if (!_CalendarView) {
        _CalendarView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _CalendarView.backgroundColor=YYSRGBColor(0, 0, 0, 0.2);
    }
    return _CalendarView;
}
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
