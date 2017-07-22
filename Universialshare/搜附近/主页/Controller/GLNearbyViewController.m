//
//  GLNearbyViewController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.

#import "GLNearbyViewController.h"
#import "SlideTabBarView.h"
#import "GLNearby_TradeOneModel.h"
#import "GLNearby_SearchController.h"
#import "MXNavigationBarManager.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "LBPayTheBillViewController.h"

@interface GLNearbyViewController ()<UITextFieldDelegate>
{
//    LoadWaitView *_loadV;
    
}
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic, strong)NSMutableArray *models;
@property (weak, nonatomic) IBOutlet UITextField *searchTextF;
@property (nonatomic, assign) CLLocationCoordinate2D coors2; // 纬度
@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *longitude;
@property (strong , nonatomic)BMKReverseGeoCodeOption *option;//地址
@property (nonatomic, strong)SlideTabBarView *slideV;
@property (nonatomic, strong)UIView *placeHolderView;
@property (strong, nonatomic)LoadWaitView *loadV;

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
//扫码
- (IBAction)ScanButton:(UIButton *)sender {
    
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    
    style.animationImage = imgFullNet;
    
    
    [self openScanVCWithStyle:style];
    
}
- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    self.hidesBottomBarWhenPushed = YES;
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    __weak typeof(self) weakself = self;
    vc.retureCode = ^(NSString *codeStr){
       //跳转
        [weakself getStoreInfo:codeStr];//返回信息
        
    };
    [self.navigationController pushViewController:vc animated:YES];
     self.hidesBottomBarWhenPushed = NO;
}

-(void)getStoreInfo:(NSString*)str{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"shop_name"] = str;
    __weak typeof(self) weakself = self;
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"shop/getShopData" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
           weakself.hidesBottomBarWhenPushed = YES;
            LBPayTheBillViewController *vc=[[LBPayTheBillViewController alloc]init];
            vc.namestr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_name"]];
            vc.pic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"store_pic"]];
            vc.shop_uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_id"]];
            vc.surplusLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"surplusLimit"]];
            [weakself.navigationController pushViewController:vc animated:YES];
            weakself.hidesBottomBarWhenPushed = NO;
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];


}

- (void)postRequest {
    
    [NetworkManager requestPOSTWithURLStr:@"shop/getTradeId" paramDic:@{} finish:^(id responseObject) {
    
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                for (NSDictionary *dic  in responseObject[@"data"][@"trade"]) {
                    
                    GLNearby_TradeOneModel *model = [GLNearby_TradeOneModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
                [GLNearby_Model defaultUser].trades = self.models;
                [self.view addSubview:self.slideV];
            }
        }
        
    } enError:^(NSError *error) {

        [self.view addSubview:self.placeHolderView];
        [MBProgressHUD showError:error.description];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [MXNavigationBarManager reStoreToCustomNavigationBar:self];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
  
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
- (IBAction)search:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLNearby_SearchController *searchVC = [[GLNearby_SearchController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.coors2 = userLocation.location.coordinate;

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
#pragma UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    self.hidesBottomBarWhenPushed = YES;
//    GLNearby_SearchController *searchVC = [[GLNearby_SearchController alloc] init];
//    [self presentViewController:searchVC animated:NO completion:nil];
//    
//    return YES;
//}

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

- (SlideTabBarView *)slideV{
    if (!_slideV) {
        _slideV = [[SlideTabBarView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 49-64) WithCount:(int)self.models.count + 1];
    }
    return _slideV;
}
- (UIView *)placeHolderView{
    if (!_placeHolderView) {
        _placeHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 49-64)];
        CGFloat height = 105;
        CGFloat width = 170;
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(_placeHolderView.center.x - width/2, (_placeHolderView.yy_height - height) / 2 , width, height);
        imageV.image = [UIImage imageNamed:@"pic_nodata"];
        imageV.userInteractionEnabled = NO;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame) + 30, _placeHolderView.yy_width, 20)];
        label.text = @"点击重新加载";
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        
        [_placeHolderView addSubview:imageV];
        [_placeHolderView addSubview:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postRequest)];
        [_placeHolderView addGestureRecognizer:tap];
        
    }
    return _placeHolderView;
}

@end
