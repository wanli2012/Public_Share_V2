//
//  GLHourseDetailController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHourseDetailController.h"
#import "SDCycleScrollView.h"
#import "GLHourseDetailFirstCell.h"

#import "GLHourseDetailThirdCell.h"
#import "GLTwoButtonCell.h"
#import "GLImage_textDetailCell.h"
#import "GLHourseOptionCell.h"
#import "GLHourseChangeNumCell.h"

#import "GLEvaluateCell.h"
#import "GLConfirmOrderController.h"

#import "GLHourseOptionModel.h"
#import "GLShoppingCartController.h"

#import "GLGoodsDetailModel.h"
#import "GLShoppingCartController.h"

@interface GLHourseDetailController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,GLTwoButtonCellDelegate,GLHourseChangeNumCellDelegate>
{
    NSMutableArray *_visableCells;
    
    //status:??
    int _status;
    LoadWaitView * _loadV;
    NSInteger _sum;
    NSIndexPath *_indexPath;//加减cell的IndexPath
}

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)NSMutableArray *cellArr;

@property (nonatomic, strong)NSMutableArray *optionModels;

@property (nonatomic, strong)GLGoodsDetailModel *model;
@property (assign, nonatomic) NSInteger is_collection;//是否收藏
@property (weak, nonatomic) IBOutlet UIImageView *collectionimage;



@end
static NSString *firstCell = @"GLHourseDetailFirstCell";

static NSString *thirdCell = @"GLHourseDetailThirdCell";
static NSString *twoButtonCell = @"GLTwoButtonCell";
static NSString *image_textCell = @"GLImage_textDetailCell";
static NSString *bottomCell = @"GLBottomCell";
static NSString *evaluateCell = @"GLEvaluateCell";
static NSString *optionCell = @"GLHourseOptionCell";
static NSString *changeNumCell = @"GLHourseChangeNumCell";


@implementation GLHourseDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _status = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;

//    self.navigationItem.title = @"房子详情";
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 160)
                                                          delegate:self
                                                  placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    _cycleScrollView.localizationImageNamesGroup = @[PlaceHolderImage,
                                                     PlaceHolderImage,
                                                     PlaceHolderImage,
                                                     PlaceHolderImage,
                                                     PlaceHolderImage];
    
    _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
    
    _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    self.tableView.tableHeaderView = _cycleScrollView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.bounces = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHourseDetailFirstCell" bundle:nil] forCellReuseIdentifier:firstCell];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLHourseDetailThirdCell" bundle:nil] forCellReuseIdentifier:thirdCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLTwoButtonCell" bundle:nil] forCellReuseIdentifier:twoButtonCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLImage_textDetailCell" bundle:nil] forCellReuseIdentifier:image_textCell];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLEvaluateCell" bundle:nil] forCellReuseIdentifier:evaluateCell];
    [self.tableView registerClass:[GLHourseOptionCell class] forCellReuseIdentifier:optionCell];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLHourseChangeNumCell" bundle:nil] forCellReuseIdentifier:changeNumCell];

    _visableCells = [NSMutableArray array];
    
    //1:积分详情  2:商品详情
//    if (self.type == 1) {
//        self.addToCartBtn.hidden = YES;
//        self.settleBtn.hidden = YES;
//        self.exchangeBtn.hidden = NO;
//    }else{
//        self.addToCartBtn.hidden = NO;
//        self.settleBtn.hidden = NO;
//        self.exchangeBtn.hidden = YES;
//    }
    
    [self postRequest];
    
}
- (void)postRequest{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *dict;
    if ([UserModel defaultUser].loginstatus == YES) {
        dict =@{@"goods_id":self.goods_id,@"uid":[UserModel defaultUser].uid,@"token":[UserModel defaultUser].token};
    }else{
        dict =@{@"goods_id":self.goods_id};
    }

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/goodsDetail" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
//        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1){
             if (![responseObject[@"data"] isEqual:[NSNull null]]) {
           self.model = [GLGoodsDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
        }
        self.cycleScrollView.imageURLStringsGroup = responseObject[@"data"][@"details_banner"];
            
        if ([responseObject[@"data"][@"is_collection"]integerValue] == 0) {
            self.collectionimage.image = [UIImage imageNamed:@"collect_icon"];
        }else{
            self.collectionimage.image = [UIImage imageNamed:@"collect_select_icon"];
        }
        self.is_collection = [responseObject[@"data"][@"is_collection"] integerValue];

        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableView reloadData];
    }];
    
}
//跳到购物车
- (IBAction)goToCart:(id)sender {
    
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    GLShoppingCartController *cartVC = [[GLShoppingCartController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
    
}
//收藏
- (IBAction)collection:(id)sender {

    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    if (self.is_collection  == 0) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"GID"] = self.goods_id;
        dict[@"type"] = @(self.type);
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"shop/addMyCollect" paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == 1){
                self.collectionimage.image = [UIImage imageNamed:@"collect_select_icon"];
                self.is_collection = 1;
                [MBProgressHUD showSuccess:@"收藏成功"];
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
            [self.tableView reloadData];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];
        
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"GID"] = self.goods_id;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"shop/delMyCollect" paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == 1){
                self.collectionimage.image = [UIImage imageNamed:@"collect_icon"];
                self.is_collection = 0;
                if (self.is_notice == YES) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"GLMyCollectionController" object:nil];
                }
                
                [MBProgressHUD showSuccess:@"取消收藏成功"];
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
            [self.tableView reloadData];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];
    }
    
    
}

//积分兑换
- (IBAction)exchange:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLConfirmOrderController *confirmVC = [[GLConfirmOrderController alloc] init];
    confirmVC.goods_count = [NSString stringWithFormat:@"%lu",_sum];
    confirmVC.orderType = self.type;
    [self.navigationController pushViewController:confirmVC animated:YES];
}

//加入购物车
- (IBAction)addToCart:(id)sender {
    
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"goods_id"] = self.goods_id;
    dict[@"type"] = @(self.type);

    //取出 数量
    GLHourseChangeNumCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    _sum = [cell.sumLabel.text integerValue];
    dict[@"count"] = @(_sum);
  
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/addCart" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];

        if ([responseObject[@"code"] integerValue] == 1){

            [MBProgressHUD showSuccess:@"成功加入购物车"];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];
 
}

//去结算 订单确认
- (IBAction)confirmOrder:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    //取出 数量
    GLHourseChangeNumCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];

    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    GLConfirmOrderController *vc=[[GLConfirmOrderController alloc]init];
    vc.goods_id = self.goods_id;
    vc.goods_count = cell.sumLabel.text;
    vc.orderType = self.type; //订单类型
    [self.navigationController pushViewController:vc animated:YES];

}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObjectsFromArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
        _cellArr = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)cellArr{
    if (!_cellArr) {
        _cellArr = [NSMutableArray array];
        
    }
    return _cellArr;
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
#pragma UITableviewDelegate UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_status == 1) {
        
//        return self.dataSource.count + 2;
        return 3;
    }else{
//        return self.dataSource.count;
        return 3;
    }
}
- (NSMutableArray *)optionModels{
    if (!_optionModels) {
        _optionModels = [NSMutableArray array];
        NSArray *colorarr = [[NSArray alloc] initWithObjects:@"蓝色",@"红色",@"湖蓝色",@"咖啡色",@"咖啡色",@"咖啡色",@"咖啡色",@"咖啡色",@"咖啡色",@"咖啡色",nil];
        NSArray *sizearr = [[NSArray alloc] initWithObjects:@"蓝色",@"红色",@"湖蓝色",@"咖啡色",nil];
        
     NSArray *typeArr = [[NSArray alloc] initWithObjects:@"颜色",@"型号",nil];
        
        for (int i = 0; i<2; i++) {
            GLHourseOptionModel *model = [[GLHourseOptionModel alloc] init];
            if (i == 0) {
                model.titleNames = colorarr;
                
            }else{
                model.titleNames = sizearr;
            }
            model.typeName = typeArr[i];
            [_optionModels addObject:model];
        }
        
    }
    return _optionModels;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *GLcell;
    
    if (indexPath.row == 0) {
       
        GLHourseDetailFirstCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GLHourseDetailFirstCell"];
        cell.model = self.model;
        GLcell = cell;
      
    }else if(indexPath.row == 1){
        
        GLHourseChangeNumCell *cell = [self.tableView dequeueReusableCellWithIdentifier:changeNumCell];
        cell.indexPath = indexPath;
        _indexPath = indexPath;
        cell.delegate = self;
        GLcell = cell;
        

    }else{

        NSArray *arr = self.model.attr;
        GLHourseDetailThirdCell *cell = [[GLHourseDetailThirdCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) andDatasource:arr :@"商品参数" ];
        GLcell = cell;

    }
    
    [self.cellArr addObject:GLcell];
    GLcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return GLcell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    
        return self.tableView.rowHeight;
        
    }else if (indexPath.row == 1 ){

        return 90;
        
    }else if (indexPath.row ==2 ){
        
        NSArray *arr = self.model.attr;
        return [self jisuangaodu:arr];
        
    }else{
        return 100;
    }
    
}
- (float)jisuangaodu:(NSArray *)arr{
    float upX = 10;
    float upY = 40;

    for (int i = 0; i<arr.count; i++) {
        NSString *str = [arr objectAtIndex:i] ;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [str sizeWithAttributes:dic];
        
        if ( upX > (SCREEN_WIDTH-20 -size.width-35)) {
            
            upX = 10;
            upY += 30;
        }
        
        upX+= SCREEN_WIDTH * 0.4;
    
    }
    return upY + 30;
}
- (float)jisuanjincou:(NSArray *)arr{
    float upX = 10;
    float upY = 40;
    //    NSArray *arr = [[NSArray alloc] initWithObjects:@"级别",@"级别",@"级别",@"级别",nil];
    for (int i = 0; i<arr.count; i++) {
        NSString *str = [arr objectAtIndex:i] ;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [str sizeWithAttributes:dic];
        
        if ( upX > (SCREEN_WIDTH-20 -size.width-35)) {
            
            upX = 10;
            upY += 30;
        }
        
        upX+= size.width + 35;
    }
    return upY + 30;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    scrollView.bounces = (scrollView.contentOffset.y >= 0) ? YES : NO;

}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    
//}
- (void)changeNum:(NSInteger )tag indexPath:(NSIndexPath *)indexPath{
    GLHourseChangeNumCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    _sum = [cell.sumLabel.text intValue];
    
    if (tag == 20) {
        _sum -= 1;
        if (_sum < 0) {
            _sum = 0;
        }
    }else{
        _sum += 1;
    }
    cell.sumLabel.text = [NSString stringWithFormat:@"%ld",_sum];
    [self.tableView reloadData];
    
}
- (void)changeView:(NSInteger )tag{

    if (tag == 11) {
        _status = 1;
    }else{
        _status = 0;
    }
    
    
    [self.tableView reloadData];
    
}
@end
