//
//  LBIntegralMallViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBIntegralMallViewController.h"
#import "SDCycleScrollView.h"
#import "GLIntegralHeaderView.h"
#import "GLIntegralMallTopCell.h"
#import "GLIntegralGoodsCell.h"

#import "GLHourseDetailController.h"
#import "GLIntegraClassifyController.h"

#import "GLMallHotModel.h"
#import "GLMall_InterestModel.h"

//城市定位 选择
#import "GLCityChooseController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "GLIntegralMall_SearchController.h"
//公告
#import "GLHomePageNoticeView.h"
#import "GLSet_MaskVeiw.h"
#import "GLHomePageNoticeView.h"
#import "GLConfirmOrderController.h"

@interface LBIntegralMallViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,GLIntegralGoodsCellDelegate,GLIntegralMallTopCellDelegete>
{
    LoadWaitView * _loadV;
    NSInteger _page;
    
    NSString *_htmlString;
    GLSet_MaskVeiw *_maskV;
    GLHomePageNoticeView *_contentView;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@property (nonatomic, strong)NSMutableArray *hotModels;
@property (nonatomic, strong)NSMutableArray *interestModels;
@property (nonatomic, strong)NSMutableArray *bannerArr;

@property (weak, nonatomic) IBOutlet UIView *searchView;

//公告


@end


static NSString *topCellID = @"GLIntegralMallTopCell";
static NSString *goodsCellID = @"GLIntegralGoodsCell";
@implementation LBIntegralMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor purpleColor];
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180*autoSizeScaleY)
                                                          delegate:self
                                                  placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];//当一张都没有的时候的 占位图
    //每一张图的占位图
    _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
    
    _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
    _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    _cycleScrollView.localizationImageNamesGroup = @[@"banner01.jpg",
                                                     @"banner02.jpg",
                                                     @"banner03.jpg"];
    
    self.tableView.tableHeaderView = _cycleScrollView;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIntegralMallTopCell" bundle:nil] forCellReuseIdentifier:topCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIntegralGoodsCell" bundle:nil] forCellReuseIdentifier:goodsCellID];
    self.searchView.layer.cornerRadius = self.searchView.yy_height / 2;
    self.searchView.clipsToBounds = YES;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isShow"] isEqualToString:@"YES"]) {
    
        //公告
        [self initInterDataSorceinfomessage];
    }
    
    [self postRequest];
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest];
        
    }];

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
}
- (void)dismiss{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _maskV.transform = CGAffineTransformMakeScale(0.07, 0.07);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            _maskV.center = CGPointMake(SCREEN_WIDTH - 30,30);
        } completion:^(BOOL finished) {
            [_maskV removeFromSuperview];
        }];
    }];
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)postRequest{

    [self.hotModels removeAllObjects];
    [self.interestModels removeAllObjects];
    [self.bannerArr removeAllObjects];
//    
//    [NetworkManager requestPOSTWithURLStr:@"index/banner_list" paramDic:@{@"type":@"6"} finish:^(id responseObject) {
//
//        if ([responseObject[@"code"] integerValue] == 1){
//            NSMutableArray *arrM = [NSMutableArray array];
//            
//            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
//                
//                for (NSDictionary *dic  in responseObject[@"data"]) {
//                    
//                    UIImageView *imageV = [[UIImageView alloc] init];
//                    [imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"img_path"]] placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];
//                    
//                    if(imageV.image){
//                        
//                        [arrM addObject:dic[@"img_path"]];
//                    }
//                }
//                if (arrM.count  <= 0) {
//                    
//                    _cycleScrollView.imageURLStringsGroup = arrM;
//                }else{
//                    _cycleScrollView.localizationImageNamesGroup = @[@"banner01",
//                                                                     @"banner02",
//                                                                     @"banner03"];
//                }
//                
//            }else{
//                _cycleScrollView.localizationImageNamesGroup = @[@"banner01",
//                                                                 @"banner02",
//                                                                 @"banner03"];
//            }
//        }
//        [self.tableView reloadData];
//    } enError:^(NSError *error) {
//        [MBProgressHUD showError:error.description];
//        [self.tableView reloadData];
//    }];

    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/main" paramDic:@{} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];

        if ([responseObject[@"code"] integerValue] == 1){
            if([responseObject[@"data"] count] != 0){
                if([responseObject[@"data"][@"mall_tabe"] count]){
                    
                    for (NSDictionary *dic in responseObject[@"data"][@"mall_tabe"]) {
                        
                        GLMallHotModel *model = [GLMallHotModel mj_objectWithKeyValues:dic];
                        [_hotModels addObject:model];
                    }
                }
                if ([responseObject[@"data"][@"inte_list"] count]) {
                    
                    for (NSDictionary *dic in responseObject[@"data"][@"inte_list"]) {
                        GLMall_InterestModel *model = [GLMall_InterestModel mj_objectWithKeyValues:dic];
                        [_interestModels addObject:model];
                    }
                }
                if ([responseObject[@"data"][@"banner_url"] count] != 0) {
                    
                    for (NSDictionary *dic in responseObject[@"data"][@"banner_url"]) {
                        [self.bannerArr addObject:dic[@"image_url"]];
                    }
                }
                if (self.bannerArr.count > 0) {
                    
                    _cycleScrollView.imageURLStringsGroup = self.bannerArr;
                }else{
                    _cycleScrollView.localizationImageNamesGroup = @[@"banner01",
                                                                     @"banner02",
                                                                     @"banner03"];
                }
                
            }else{
                _cycleScrollView.localizationImageNamesGroup = @[@"banner01",
                                                                 @"banner02",
                                                                 @"banner03"];
                
            }
        }
     
        [self.tableView reloadData];
     
    } enError:^(NSError *error) {
       [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
        
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

}

-(void)initInterDataSorceinfomessage{
    
     [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isShow"];//展示过就不要展示了，重启App在调
    
    CGFloat contentViewH = SCREEN_HEIGHT / 2;
    CGFloat contentViewW = SCREEN_WIDTH - 40;
    CGFloat contentViewX = 20;
    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    _maskV.bgView.alpha = 0.3;
    
    _contentView = [[NSBundle mainBundle] loadNibNamed:@"GLHomePageNoticeView" owner:nil options:nil].lastObject;
    _contentView.contentViewW.constant = SCREEN_WIDTH - 40;
    _contentView.contentViewH.constant = SCREEN_HEIGHT / 2 - 30;
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    
    //设置webView
    _contentView.webView.scalesPageToFit = YES;
    _contentView.webView.autoresizesSubviews = NO;
    _contentView.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    _contentView.webView.scrollView.bounces = NO;
    
    NSURL *url = [NSURL URLWithString:NOTICE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
   
    [_contentView.webView loadRequest:request];
    [_maskV showViewWithContentView:_contentView];
    
    _contentView.frame = CGRectMake(contentViewX, (SCREEN_HEIGHT - contentViewH)/2, contentViewW, contentViewH);
    //缩放
    _contentView.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
    _contentView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        
        _contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _contentView.alpha = 1;
    }];
    
}

- (void)tapgestureTag:(UITapGestureRecognizer *)Tag {
   
    if (_hotModels.count <= 0) {
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
    detailVC.navigationItem.title = @"米券兑换详情";
    if (Tag.view.tag == 11) {
        if ((Tag.view.tag - 11) < _hotModels.count) {
            
            GLMallHotModel *model = self.hotModels[0];
            detailVC.goods_id = model.mall_id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }

    }else if (Tag.view.tag == 12){
        if ((Tag.view.tag - 11) < _hotModels.count) {
            
            GLMallHotModel *model = self.hotModels[1];
            detailVC.goods_id = model.mall_id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }

    }else if (Tag.view.tag == 13){
        if ((Tag.view.tag - 11) < _hotModels.count) {
            
            GLMallHotModel *model = self.hotModels[2];
            detailVC.goods_id = model.mall_id;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }else{
        
        GLIntegraClassifyController *classifyVC = [[GLIntegraClassifyController alloc] init];
        [self.navigationController pushViewController:classifyVC animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}
- (IBAction)search:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLIntegralMall_SearchController *search = [[GLIntegralMall_SearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//城市选择
- (IBAction)cityChoose:(id)sender {
    
//    JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
//    cityViewController.title = @"城市";
    GLCityChooseController *cityVC = [[GLCityChooseController alloc] init];
    __weak typeof(self) weakSelf = self;
    cityVC.block = ^(NSString *city,NSString *city_id){
        [weakSelf.cityBtn setTitle:city forState:UIControlStateNormal];
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

//立即抢购
- (void)buyNow:(int)index{
    self.hidesBottomBarWhenPushed = YES;
    
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }

    GLConfirmOrderController *vc=[[GLConfirmOrderController alloc]init];
    GLMall_InterestModel *model = self.interestModels[index];
    vc.goods_id = model.goods_id;
    vc.goods_count = @"1";
    vc.orderType = 2; //订单类型 2:积分商品
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}
#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        
        return self.interestModels.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40*autoSizeScaleY;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        GLIntegralHeaderView *headerVeiw = [[NSBundle mainBundle] loadNibNamed:@"GLIntegralHeaderView" owner:nil options:nil].lastObject;
        return headerVeiw;
    }else{
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0) {
        GLIntegralMallTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.hotModels.count == 3) {
            cell.models = self.hotModels;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
        }
        cell.delegete = self;
        
        return cell;
        
    }else{
        GLIntegralGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellID];
        cell.model = self.interestModels[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.index = (int)indexPath.row;
        cell.delegate = self;
        
        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 185 *autoSizeScaleY;
    }else{
        
        return 110 *autoSizeScaleY;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     self.hidesBottomBarWhenPushed = YES;
    if(indexPath.section != 0 ){
        
        GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
        detailVC.navigationItem.title = @"米券兑换详情";
        GLMall_InterestModel *model = self.interestModels[indexPath.row];
        detailVC.goods_id = model.goods_id;
        //    GLSubmitFirstController *submitVC = [[GLSubmitFirstController alloc] init];
        detailVC.type = 1;
        [self.navigationController pushViewController:detailVC animated:YES];
    }

     self.hidesBottomBarWhenPushed = NO;
}



- (NSMutableArray *)hotModels{
    if (!_hotModels) {
        _hotModels = [NSMutableArray array];
    }
    return _hotModels;
}
- (NSMutableArray *)interestModels{
    if (!_interestModels) {
        _interestModels = [NSMutableArray array];
    }
    return _interestModels;
}
- (NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [[NSMutableArray alloc] init];
    }
    return _bannerArr;
}


@end
