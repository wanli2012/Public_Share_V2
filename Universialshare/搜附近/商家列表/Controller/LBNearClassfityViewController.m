//
//  LBNearClassfityViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBNearClassfityViewController.h"
#import "GLNearby_MerchatListCell.h"
#import "GLSet_MaskVeiw.h"
#import "GLHomeLiveChooseController.h"
#import "GLNearby_MerchatListModel.h"
#import "GLCityChooseController.h"
#import <MapKit/MapKit.h>
#import "LBStoreMoreInfomationViewController.h"
#import "GLNearby_NearShopModel.h"
#import "GLHomeLiveChooseController.h"
#import "UIButton+SetEdgeInsets.h"
#import "MXNavigationBarManager.h"

@interface LBNearClassfityViewController ()<UITableViewDataSource,UITableViewDelegate,GLNearby_MerchatListCellDelegate>
{
    GLSet_MaskVeiw *_maskV;
    UIView *_contentView;
    UIButton *_tmpBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *classifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *nearModels;
@property (nonatomic, strong)NSMutableArray *recModels;
@property (nonatomic, strong)NSMutableArray *tradeArr;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic,strong)NodataView *nodataV;

@property (nonatomic, strong)UIView  *maskV;//遮罩
@property (nonatomic, strong)GLHomeLiveChooseController *chooseVC2;//选择控制器
@property (nonatomic, strong)GLHomeLiveChooseController *chooseVC;//选择控制器

@end

static NSString *ID = @"GLNearby_MerchatListCell";
@implementation LBNearClassfityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家列表";
    [self.tableView addSubview:self.nodataV];

    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [self.sortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [self.sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
    
    [self.classifyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [self.classifyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
    
    [self.cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [self.cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
    
    self.sort = @"1";

        [self.cityBtn setTitle:@"城市" forState:UIControlStateNormal];
   
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
    if (self.index == 10) {
            [self getAallClassify];//获取全部分类
    }

    [self.tableView.mj_header beginRefreshing];
}

-(void)getAallClassify{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [NetworkManager requestPOSTWithURLStr:@"user/getShopTrade" paramDic:dict finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                [self.tradeArr addObjectsFromArray:responseObject[@"data"]];
                [self.tradeArr insertObject:@"全部" atIndex:0];
            }
        }
        
    } enError:^(NSError *error) {
        
        [MBProgressHUD showError:@"数据加载失败"];
        
    }];
    
}

- (void)updateData:(BOOL)status {
    
    if (status) {
        
        _page = 1;
        [self.recModels removeAllObjects];
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"page"] = @(self.page);
    dict[@"trade_id"] = self.trade_id;
    dict[@"two_trade_id"] = self.two_trade_id;
    dict[@"sort"] = self.sort;
    dict[@"city_id"] = self.city_id;
        
        [NetworkManager requestPOSTWithURLStr:@"shop/getShopDataNew" paramDic:dict finish:^(id responseObject) {
            [self endRefresh];
            if ([responseObject[@"code"] integerValue] == 1){
                if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                    
                    for (NSDictionary *dic  in responseObject[@"data"]) {
                        GLNearby_MerchatListModel *model = [GLNearby_MerchatListModel mj_objectWithKeyValues:dic];
                        [self.recModels addObject:model];
                    }
                }
            }
        
            [self.tableView reloadData];
            
        } enError:^(NSError *error) {
            [self endRefresh];
             [self.tableView reloadData];
            [MBProgressHUD showError:@"数据加载失败"];
        }];
    
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    }
    return _nodataV;
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MXNavigationBarManager reStoreToCustomNavigationBar:self];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    
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
    _maskV.bgView.alpha = 0.1;
    
    [_maskV showViewWithContentView:_contentView];
    _maskV.alpha = 0;
    
    //    self.tabBarController.tabBar.hidden = YES;
    if ([GLNearby_Model defaultUser].city != nil) {
        
        [self.cityBtn setTitle:[GLNearby_Model defaultUser].city forState:UIControlStateNormal];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_maskV removeFromSuperview];
}
- (void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.chooseVC.view.height = 0;
        self.chooseVC2.view.height = 0;
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
//点击地图导航
- (void)mapTo:(NSInteger)index{
    
    GLNearby_MerchatListModel *model = self.nearModels[index];
    
    CGFloat lat = [model.lat floatValue ];
    CGFloat lng = [model.lng floatValue ];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])// -- 使用 canOpenURL 判断需要在info.plist 的 LSApplicationQueriesSchemes 添加 baidumap 。
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"baidumap://map/geocoder?location=%f,%f&coord_type=bd09ll&src=webapp.rgeo.yourCompanyName.yourAppName",lat,lng]]];
    }else{
        //使用自带地图导航
        
        CLLocationCoordinate2D destCoordinate;
        // 将数据传到反地址编码模型
        destCoordinate = CLLocationCoordinate2DMake(lat,lng);
        
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destCoordinate addressDictionary:nil]];
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    }
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
    
    [sender setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
    
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
            
            _chooseVC.view.width = SCREEN_WIDTH;
            _chooseVC2.view.height = 0;
                self.hidesBottomBarWhenPushed = YES;
                GLCityChooseController *cityVC = [[GLCityChooseController alloc] init];
                
                cityVC.block = ^(NSString *city,NSString *city_id){
                    
                    [weakSelf.cityBtn setTitle:city forState:UIControlStateNormal];
                     [weakSelf.cityBtn horizontalCenterTitleAndImage:5];
                    if ([weakSelf.cityBtn.titleLabel.text isEqualToString:@"城市"]) {
                        
                        weakSelf.cityBtn.imageView.image = [UIImage imageNamed:@"下选三角形"];
                    }else{
                        weakSelf.cityBtn.imageView.image = [UIImage imageNamed:@""];
                    }
                    
                    weakSelf.city_id = city_id;
                    
                    [weakSelf updateData:YES];
                    [weakSelf dismiss];
                };
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cityVC animated:YES];
                //                self.hidesBottomBarWhenPushed = NO;

        }
            break;
        case 11:
        {
            
            if (self.index == 10) {
                [self showClassifyTrade];
            }else{
                 [self showTwoTrande];
            }
            
        }
            break;
        case 12:
        {
            
            _chooseVC.view.width = SCREEN_WIDTH;
            _chooseVC2.view.height = 0;

          _chooseVC.dataSource = @[@"智能排序",@"好评优先"];
        
            _chooseVC.block = ^(NSString *value,NSInteger index){
                [weakSelf.sortBtn setTitle:value forState:UIControlStateNormal];
                 [weakSelf.sortBtn horizontalCenterTitleAndImage:5];
                if ([value isEqualToString:@"智能排序"]) {
                    
                    weakSelf.sort = @"1";
                }else if ([value isEqualToString:@"好评优先"]){
                    weakSelf.sort = @"2";
                }
                
                if ([weakSelf.sortBtn.titleLabel.text isEqualToString:@"排序"]) {
                    
                    weakSelf.sortBtn.imageView.image = [UIImage imageNamed:@"下选三角形"];
                }else{
                    weakSelf.sortBtn.imageView.image = [UIImage imageNamed:@""];
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

-(void)showClassifyTrade{

    __weak __typeof(self)weakSelf = self;
    _chooseVC.dataSource = self.tradeArr;
    _chooseVC.view.width = SCREEN_WIDTH / 2 - 40;
    _chooseVC.isSelect = YES;
    _chooseVC.block = ^(NSString *value,NSInteger indexF){
        if (indexF == 0) {
            weakSelf.trade_id = @"";
            weakSelf.two_trade_id = @"";
            [weakSelf updateData:YES];
            [weakSelf dismiss];
            return ;
        }
        weakSelf.trade_id = weakSelf.tradeArr[indexF][@"trade_id"];
        //二级选项
        weakSelf.chooseVC2.view.frame = CGRectMake(weakSelf.chooseVC.view.width ,0, SCREEN_WIDTH-weakSelf.chooseVC.view.width, 0);
        [weakSelf.maskV addSubview:weakSelf.chooseVC2.view];
        
        weakSelf.chooseVC2.dataSource = weakSelf.tradeArr[indexF][@"son"];
        
        weakSelf.chooseVC2.block = ^(NSString *value,NSInteger index){
            [weakSelf.classifyBtn setTitle:value forState:UIControlStateNormal];
             [weakSelf.classifyBtn horizontalCenterTitleAndImage:5];
            weakSelf.two_trade_id = weakSelf.tradeArr[indexF][@"son"][index][@"trade_id"];
            [weakSelf dismiss];
            [weakSelf updateData:YES];
        };
        
        [UIView animateWithDuration:0.3 animations:^{
            if (weakSelf.chooseVC2.dataSource.count < 8) {
                weakSelf.chooseVC2.view.height = _chooseVC2.dataSource.count * 44;
            }else{
                weakSelf.chooseVC2.view.height = SCREEN_HEIGHT * 0.5;
            }
            
        }];
        
        [weakSelf.chooseVC2.tableView reloadData];
    };
    
    [weakSelf.chooseVC.tableView reloadData];

}

-(void)showTwoTrande{
    __weak __typeof(self)weakSelf = self;
    _chooseVC.view.width = SCREEN_WIDTH;
    _chooseVC2.view.height = 0;
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.typeArr];
    [arr insertObject:@"全部" atIndex:0];
    _chooseVC.dataSource = arr;
    
    _chooseVC.block = ^(NSString *value,NSInteger index){
        [weakSelf.classifyBtn setTitle:value forState:UIControlStateNormal];
         [weakSelf.classifyBtn horizontalCenterTitleAndImage:5];
        if (index == 0) {
            weakSelf.two_trade_id = @"";
            [weakSelf updateData:YES];
            [weakSelf dismiss];
            return ;
        }
        
        weakSelf.trade_id = weakSelf.typeArr[index][@"trade_id"];
        [weakSelf updateData:YES];
        [weakSelf dismiss];
    };

}
#pragma UITableviewDelegate UITableviewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.recModels.count <= 0 ) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
   
    return self.recModels.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLNearby_MerchatListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
   
        
    if (self.recModels.count != 0) {
        cell.model = self.recModels[indexPath.row];
    }
    cell.distanceLabel.hidden = YES;
    cell.selectionStyle = 0;
    cell.delegate = self;
    cell.index = indexPath.row;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    LBStoreMoreInfomationViewController *storeVC = [[LBStoreMoreInfomationViewController alloc] init];
    
    GLNearby_NearShopModel *model;
    
    if (self.index == 10) {
        model = self.recModels[indexPath.row];
    }else{
        model = self.nearModels[indexPath.row];
    }
    
    storeVC.lat = [model.lat floatValue];
    storeVC.lng = [model.lng floatValue];
    storeVC.storeId = model.shop_id;
    
    [self.navigationController pushViewController:storeVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 115;
    
}


- (NSMutableArray *)nearModels{
    if (!_nearModels) {
        _nearModels = [NSMutableArray array];
    }
    return _nearModels;
}
- (NSMutableArray *)recModels{
    if (!_recModels) {
        _recModels = [NSMutableArray array];
    }
    return _recModels;
}
- (NSMutableArray *)tradeArr{
    if (!_tradeArr) {
        _tradeArr = [NSMutableArray array];
    }
    return _tradeArr;
}


- (GLHomeLiveChooseController *)chooseVC2{
    if (!_chooseVC2) {
        _chooseVC2 = [[GLHomeLiveChooseController alloc] init];
        
    }
    return _chooseVC2;
}




@end
