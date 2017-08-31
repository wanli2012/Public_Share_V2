//
//  GLNearby_SearchController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_SearchController.h"
#import "GLNearby_classifyCell.h"
#import "LBStoreMoreInfomationViewController.h"
#import "MSSAutoresizeLabelFlow.h"
#import "projiectmodel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface GLNearby_SearchController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    LoadWaitView *_loadV;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

//@property (nonatomic,strong)NSMutableArray *models;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,strong)NodataView *nodataV;

@property (nonatomic, strong)NSMutableArray *nearModels;

@property (nonatomic, strong)NSMutableArray *reCoderArr;
@property (nonatomic, strong)NSMutableArray *fmdbArr;

@property(nonatomic,strong)MSSAutoresizeLabelFlow *secondView;

@property (nonatomic,strong) projiectmodel      *projiectmodel;//综合项目本地保存

@end

static NSString *ID = @"GLNearby_classifyCell";
@implementation GLNearby_SearchController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.searchView.layer.cornerRadius = 5.f;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
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
    [self getFmdbDatasoruce];
    [self.view addSubview:_secondView];
    self.tableView.hidden = YES;
    
    // 舰艇搜索框
    [[self.searchTF rac_textSignal]subscribeNext:^(id x) {
        if ([x isEqualToString:@""]) {
            self.tableView.hidden = YES;
            self.secondView.hidden = NO;
            [self.nearModels removeAllObjects];
        }
    }];
    
    
}

-(void)getFmdbDatasoruce{

    self.fmdbArr = nil;
    self.reCoderArr = nil;
    _secondView = nil;
    //获取本地搜索记录
    _projiectmodel = [projiectmodel greateTableOfFMWithTableName:@"projiectmodel"];
    
    if ([_projiectmodel isDataInTheTable]) {
        self.fmdbArr = [NSMutableArray arrayWithArray:[_projiectmodel queryAllDataOfFMDB]];
        for (int i = 0; i < [[_projiectmodel queryAllDataOfFMDB]count]; i++) {
            [self.reCoderArr addObject:[_projiectmodel queryAllDataOfFMDB][i][@"recoder"]];
        }
    }else{
        [self.reCoderArr removeAllObjects];
        self.fmdbArr = [NSMutableArray array];
    }
    
    _secondView = [[MSSAutoresizeLabelFlow alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT - 70) titles:self.reCoderArr selectedHandler:^(NSUInteger index, NSString *title) {
        
        self.searchTF.text = [NSString stringWithFormat:@"%@",self.reCoderArr[index]];
        [self updateData:YES];
        [self.view endEditing:YES];
        
    }];
}

- (void)updateData:(BOOL)status {
    if (status) {
        
        self.page = 1;
        [self.nearModels removeAllObjects];
        
    }else{
        _page ++;
        
    }
    
    if (self.searchTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入关键字"];
        [self endRefresh];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"lng"] = [GLNearby_Model defaultUser].longitude;
    dict[@"lat"] = [GLNearby_Model defaultUser].latitude;
    dict[@"page"] = [NSString stringWithFormat:@"%zd",_page];
    dict[@"content"] = self.searchTF.text;
    
   _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"Shop/searchNearShopByContent" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        [self endRefresh];
        if ([responseObject[@"code"] integerValue]==1) {
            

            
            BOOL isSava = YES;//是否保存
            for (int i = 0; i < self.fmdbArr.count; i++) {
                if ([self.fmdbArr[i][@"recoder"] isEqualToString:self.searchTF.text]) {
                    isSava = NO;
                }
            }
            
            if (isSava == YES) {//保存记录
                [_projiectmodel deleteAllDataOfFMDB];
                _projiectmodel = [projiectmodel greateTableOfFMWithTableName:@"projiectmodel"];
                [self.fmdbArr insertObject:@{@"recoder":self.searchTF.text} atIndex:0];
                if (self.fmdbArr.count > 10) {
                    [self.fmdbArr  removeObjectsInRange:NSMakeRange(10, self.fmdbArr.count)];
                }
                [_projiectmodel insertOfFMWithDataArray:self.fmdbArr];
            }
            
            self.tableView.hidden = NO;
            self.secondView.hidden = YES;
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                for (NSDictionary *dic  in responseObject[@"data"][@"shop_data"]) {
                    GLNearby_NearShopModel *model = [GLNearby_NearShopModel mj_objectWithKeyValues:dic];
                    [self.nearModels addObject:model];
                }
                
                [self.tableView reloadData];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableView reloadData];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
        [self.tableView reloadData];
    }];
    
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114-49);
    }
    return _nodataV;
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.searchTF becomeFirstResponder];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.searchTF resignFirstResponder];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}

- (IBAction)cancel:(id)sender {

    [self.navigationController popViewControllerAnimated:NO];
}

#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    [self updateData:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self updateData:YES];
    [self.view endEditing:YES];
    return YES;
}
#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.nearModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.nearModels[indexPath.row];
    cell.selectionStyle = 0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 125;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    LBStoreMoreInfomationViewController *store = [[LBStoreMoreInfomationViewController alloc] init];
    store.lat = [[GLNearby_Model defaultUser].latitude floatValue];
    store.lng = [[GLNearby_Model defaultUser].longitude floatValue];
    GLNearby_NearShopModel *model = self.nearModels[indexPath.row];
    store.storeId = model.shop_id;
    
    [self.navigationController pushViewController:store animated:YES];
}

#pragma 懒加载
- (NSMutableArray *)nearModels{
    if (!_nearModels) {
        _nearModels = [NSMutableArray array];
    }
    return _nearModels;
}

- (NSMutableArray *)reCoderArr{
    if (!_reCoderArr) {
        _reCoderArr = [NSMutableArray array];
    }
    return _reCoderArr;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}
@end
