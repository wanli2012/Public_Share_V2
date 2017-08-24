//
//  LBIntegralMallViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBIntegralMallViewController.h"
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
#import "LBFrontView.h"
#import "GLAdModel.h"
#import "GLMine_AdController.h"

#import "LBStoreMoreInfomationViewController.h"//商家详情
#import "LBStoreProductDetailInfoViewController.h"//商品详情
#import "GLHomePageNoticeView.h"
#import "GLSet_MaskVeiw.h"


@interface LBIntegralMallViewController ()<UITableViewDelegate,UITableViewDataSource,GLIntegralMallTopCellDelegete,GLIntegralGoodsCellDelegate,LBFrontViewdelegete>
{
    LoadWaitView * _loadV;
    NSInteger _page;
    NSString *_htmlString;
    GLHomePageNoticeView *_contentView;
    GLSet_MaskVeiw *_maskV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *hotModels;
@property (nonatomic, strong)NSMutableArray *interestModels;
@property (nonatomic, strong)NSMutableArray *bannerArr;
@property (nonatomic, strong)LBFrontView *frontView;
@property (weak, nonatomic) IBOutlet UIView *navaBaseV;

@end


static NSString *topCellID = @"GLIntegralMallTopCell";
static NSString *goodsCellID = @"GLIntegralGoodsCell";
@implementation LBIntegralMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor purpleColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIntegralMallTopCell" bundle:nil] forCellReuseIdentifier:topCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIntegralGoodsCell" bundle:nil] forCellReuseIdentifier:goodsCellID];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest];
        
    }];

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    [self postRequest];//求情数据
    
    /**
     * 数组tableHeaderView
     */
    self.tableView.tableHeaderView = self.frontView;
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isShow"] isEqualToString:@"YES"]) {
//        //公告
//        [self initInterDataSorceinfomessage];
//    }
    
      [self initInterDataSorceinfomessage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y <= -20) {
        self.navaBaseV.hidden = YES;
        self.frontView.navabaseV.hidden = NO;
        self.navaBaseV.backgroundColor = YYSRGBColor(120, 161, 255, 0);
    }else{
        if (scrollView.contentOffset.y >= 0) {
             self.navaBaseV.backgroundColor = YYSRGBColor(120, 161, 255, (scrollView.contentOffset.y)/200 * autoSizeScaleX);
        }
        self.navaBaseV.hidden = NO;
        self.frontView.navabaseV.hidden = YES;
    }
    
}
- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)postRequest{

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"shop/main" paramDic:@{} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];

        if ([responseObject[@"code"] integerValue] == 1){
            if([responseObject[@"data"] count] != 0){
                
                [self.hotModels removeAllObjects];
                [self.interestModels removeAllObjects];
                
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

                if ([responseObject[@"data"][@"advert"] count] != 0) {
                    [self.bannerArr removeAllObjects];
                    for (NSDictionary *dic in responseObject[@"data"][@"advert"]) {
                        GLAdModel *model = [GLAdModel mj_objectWithKeyValues:dic];
                        [self.bannerArr addObject:model];
                    }
                }

                if (self.bannerArr.count > 0) {
                    
                    NSMutableArray *imageAr = [NSMutableArray array];
                    for (int i = 0; i < self.bannerArr.count; i ++) {
                        GLAdModel *model = self.bannerArr[i];
                        [imageAr addObject:model.thumb];
                    }
                    
                    [self.frontView reloadImage:imageAr];
                    
                }
            }
        }
     
        [self.tableView reloadData];
     
    } enError:^(NSError *error) {
       [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
        
    }];

}

#pragma mark ----- 点击轮播图查看详情
-(void)clickScrollViewImage:(NSInteger)index{

    if(self.self.bannerArr.count == 0){
        return;
    }
    
    GLAdModel *model = self.self.bannerArr[index];
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([model.type integerValue] == 1) {//内部广告
        
        if([model.jumptype integerValue] == 1){//跳转商户
            
            LBStoreMoreInfomationViewController *storeVC = [[LBStoreMoreInfomationViewController alloc] init];
            storeVC.storeId = model.jumpid;
            storeVC.lat = [[GLNearby_Model defaultUser].latitude floatValue];
            storeVC.lng = [[GLNearby_Model defaultUser].longitude floatValue];
            [self.navigationController pushViewController:storeVC animated:YES];
            
        }else if([model.jumptype integerValue] == 2){//跳转商品
            
            if ([model.goodstype integerValue] == 1) {//逛逛商品
                
                LBStoreProductDetailInfoViewController *storeVC = [[LBStoreProductDetailInfoViewController alloc] init];
                storeVC.goodId = model.jumpid;
                [self.navigationController pushViewController:storeVC animated:YES];
                
            }else{
                
                GLHourseDetailController *goodsVC = [[GLHourseDetailController alloc] init];
                goodsVC.goods_id = model.jumpid;
                [self.navigationController pushViewController:goodsVC animated:YES];
            }
            
        }
        
    }else if([model.type integerValue] == 2){//外部广告
        
        GLMine_AdController *adVC = [[GLMine_AdController alloc] init];
        adVC.url = model.url;
        [self.navigationController pushViewController:adVC animated:YES];
        
    }
    
    self.hidesBottomBarWhenPushed = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

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


#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.hotModels.count == 0?0:1;
    }else{
        
        return self.interestModels.count == 0?0:1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 65*autoSizeScaleX;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArr = self.interestModels;
        cell.delegate  = self;

        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 110 + (SCREEN_WIDTH - 40)/3;
    }else{
        NSInteger num = 0;
        if (self.interestModels.count % 2 == 0) {
            num = self.interestModels.count/2;
        }else{
            num = self.interestModels.count/2 + 1;
        }
        return ((SCREEN_WIDTH - 26)/2 + 50) * num + 10;
    }
}

#pragma mark -----GLIntegralGoodsCellDelegate
-(void)clickcheckDetail:(NSInteger)index{

    self.hidesBottomBarWhenPushed = YES;
        GLHourseDetailController *detailVC = [[GLHourseDetailController alloc] init];
        detailVC.navigationItem.title = @"米券兑换详情";
        GLMall_InterestModel *model = self.interestModels[index];
        detailVC.goods_id = model.goods_id;
        //    GLSubmitFirstController *submitVC = [[GLSubmitFirstController alloc] init];
        detailVC.type = 1;
        [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

#pragma mark ----公告

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
    [_contentView.cancelBt addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
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


-(NSMutableAttributedString*)setLabelAttribute:(NSString*)Atrrstr text:(NSString*)str{

    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange rangel = [[textColor string] rangeOfString:Atrrstr];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:rangel];

    return textColor;
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
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}
-(LBFrontView*)frontView{

    if (!_frontView) {
        _frontView = [[LBFrontView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200 * autoSizeScaleX)];
        _frontView.delegete = self;
    }
    
    return _frontView;

}


@end
