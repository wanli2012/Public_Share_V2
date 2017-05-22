//
//  GLNearbyViewController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.

#import "GLNearbyViewController.h"
#import "SlideTabBarView.h"
//#import "GLCityChooseController.h"
#import "GLNearby_TradeOneModel.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface GLNearbyViewController ()
{
    LoadWaitView *_loadV;
    
}
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic, strong)NSMutableArray *models;

//@property (strong, nonatomic)NodataView *nodataV;
@property (nonatomic, assign) CLLocationCoordinate2D coors2; // 纬度
@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *longitude;

@property (strong , nonatomic)BMKReverseGeoCodeOption *option;//地址

//@property (assign , nonatomic)BOOL locationB;//判断是否定位 默认为NO
//@property (assign, nonatomic)NSInteger page;//页数默认为0
//@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@end

@implementation GLNearbyViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.searchView.layer.cornerRadius = self.searchView.yy_height / 2;
    
    //定位
    [_mapView viewWillAppear];
    _mapView.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
    _mapView.zoomLevel=20;//地图级别
    [self.locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
}
- (void)postRequest {
    
//  _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.];
    [NetworkManager requestPOSTWithURLStr:@"shop/getTradeId" paramDic:@{} finish:^(id responseObject) {
//        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
//                NSLog(@"responseObject = %@",responseObject);
                for (NSDictionary *dic  in responseObject[@"data"][@"trade"]) {
                    GLNearby_TradeOneModel *model = [GLNearby_TradeOneModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
                [GLNearby_Model defaultUser].trades = self.models;
                SlideTabBarView *slideV = [[SlideTabBarView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 49-64) WithCount:4];
                [self.view addSubview:slideV];
               
            }
        }
        
    } enError:^(NSError *error) {
//        [_loadV removeloadview];
        [MBProgressHUD showError:error.description];
    }];
    
}

//- (IBAction)cityChoose:(id)sender {
//    
//    GLCityChooseController *cityVC = [[GLCityChooseController alloc] init];
//    __weak typeof(self) weakSelf = self;
//    cityVC.block = ^(NSString *city){
//        [weakSelf.cityBtn setTitle:city forState:UIControlStateNormal];
//    };
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:cityVC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
//}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
  

}
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //[_mapView updateLocationData:userLocation];
    
    self.coors2 = userLocation.location.coordinate;
//    self.locationB=YES;

    
    
    [GLNearby_Model defaultUser].latitude = [NSString stringWithFormat:@"%f",self.coors2.latitude];
    [GLNearby_Model defaultUser].longitude = [NSString stringWithFormat:@"%f",self.coors2.longitude];
    
    //加载数据

    [self postRequest];
    // 将数据传到反地址编码模型
    self.option.reverseGeoPoint = CLLocationCoordinate2DMake( userLocation.location.coordinate.latitude,  userLocation.location.coordinate.longitude);
    
    // 调用反地址编码方法，让其在代理方法中输出
    [self.geoCode reverseGeoCode:self.option];
    [_locService stopUserLocationService];
    
}
#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        
//        self.address.text = [NSString stringWithFormat:@"%@", result.address];
//        CLLocationDegrees latitude;
//        CLLocationDegrees longitude;
        
//        NSLog(@"位置结果是：%@ - %@", result.address, result.addressDetail.city);
//        NSLog(@"经纬度为：%f,%f 的位置结果是：%@", result.location.latitude,result.location.longitude, result.address);
        
        [self.cityBtn setTitle:result.addressDetail.city forState:UIControlStateNormal];
        
        // 定位一次成功后就关闭定位
        [_locService stopUserLocationService];
        
    }else{
        //NSLog(@"%@", @"找不到相对应的位置");
    }
    
}
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
#pragma mark geoCode的Get方法，实现延时加载
- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode)
    {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}

- (BMKReverseGeoCodeOption *)option
{
    if (!_option)
    {
        _option = [[BMKReverseGeoCodeOption alloc] init];
    }
    return _option;
}
- (BMKLocationService *)locService
{
    if (!_locService)
    {
        _locService = [[BMKLocationService alloc] init];
        _locService.desiredAccuracy = 10.f;
    }
    return _locService;
}
@end
