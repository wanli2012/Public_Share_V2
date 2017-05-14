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
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeTwoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeOneBtnWidth;

@property (assign, nonatomic)NSInteger timeBtIndex;//判断选择的按钮时哪一个
@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;

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
    _model.name = @"你哈也的你大爷街";
    _model.address = @"天府三街中百大道天府三街中百街中";
    
    [self.view addSubview:self.CalendarView];
    
    self.CalendarView.hidden = YES;
    
    [self.CalendarView addSubview:self.Calendar];
    
    __weak typeof(self) weakself = self;
    _Calendar.returnCancel = ^(){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakself.CalendarView.hidden = YES;
        });
    };
    

    [self.tableView reloadData];
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
    }else{
        NSLog(@"date1 = date2");
    }

}



#pragma UITableviewDelegate UITableviewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLIncomeManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.nameLabel.text = _model.name;
    cell.addressLabel.text = _model.address;
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

@end
