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

#import "TYCyclePagerView.h"
#import "TYPageControl.h"
#import "TYCyclePagerViewCell.h"
#import "LBDisplayPageView.h"

@interface LBIntegralMallViewController ()<UITableViewDelegate,UITableViewDataSource,GLIntegralMallTopCellDelegete,TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
{
    LoadWaitView * _loadV;
    NSInteger _page;
    
    NSString *_htmlString;
    GLSet_MaskVeiw *_maskV;
    GLHomePageNoticeView *_contentView;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *hotModels;
@property (nonatomic, strong)NSMutableArray *interestModels;
@property (nonatomic, strong)NSMutableArray *bannerArr;

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) LBDisplayPageView *displayPageView;

@end


static NSString *topCellID = @"GLIntegralMallTopCell";
static NSString *goodsCellID = @"GLIntegralGoodsCell";
@implementation LBIntegralMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor purpleColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIntegralMallTopCell" bundle:nil] forCellReuseIdentifier:topCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIntegralGoodsCell" bundle:nil] forCellReuseIdentifier:goodsCellID];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isShow"] isEqualToString:@"YES"]) {
    
        //公告
        [self initInterDataSorceinfomessage];
    }

    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf postRequest];
        
    }];

    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [self postRequest];//求情数据
    /**
     * 数组tableHeaderView
     */
    [self.pagerView addSubview:self.displayPageView];
    self.tableView.tableHeaderView = self.pagerView;
    [_pagerView reloadData];//刷新
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {

    return self.bannerArr.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    
    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TYCyclePagerViewCell" forIndex:index];
    if ([self.bannerArr[index] hasPrefix:@"http:"] || [self.bannerArr[index] hasPrefix:@"https:"]) {
        [cell.imagev sd_setImageWithURL:[NSURL URLWithString:self.bannerArr[index]] placeholderImage:nil];
    }else{
        cell.imagev.image = [UIImage imageNamed:self.bannerArr[index]];
    }

    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame) * 0.8, CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 10;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {

     _displayPageView.labelCount.attributedText = [self setLabelAttribute:[NSString stringWithFormat:@"%ld/",(long)toIndex+1] text: [NSString stringWithFormat:@"%ld/%lu",(long)toIndex+1,(unsigned long)self.bannerArr.count]];

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
                if ([responseObject[@"data"][@"banner_url"] count] != 0) {
                    [self.bannerArr removeAllObjects];
                    for (NSDictionary *dic in responseObject[@"data"][@"banner_url"]) {
                        [self.bannerArr addObject:dic[@"image_url"]];
                    }
                }
                _pageControl.numberOfPages = self.bannerArr.count;
                 _displayPageView.labelCount.attributedText = [self setLabelAttribute:@"1/" text:[NSString stringWithFormat:@"1/%lu",(unsigned long)self.bannerArr.count]];
               [_pagerView reloadData];
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
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];

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
        return 60*autoSizeScaleY;
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
        
        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110 + (SCREEN_WIDTH - 40)/3;
    }else{
        
        return 110 * autoSizeScaleX;
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
        _bannerArr = [[NSMutableArray alloc] initWithArray:@[@"banner01.jpg",
                                                             @"banner02.jpg",
                                                             @"banner03.jpg"]];

    }
    
    return _bannerArr;
}

-(TYPageControl*)pageControl{

    if (!_pageControl) {
        _pageControl = [[TYPageControl alloc]init];
        _pageControl.frame = CGRectMake(0, 180*autoSizeScaleY - 26, SCREEN_WIDTH, 26);
        _pageControl.numberOfPages = self.bannerArr.count;
        _pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
        //    pageControl.pageIndicatorImage = [UIImage imageNamed:@"Dot"];
        //    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"DotSelected"];
        //    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];

    }
    
    return _pageControl;
}

-(TYCyclePagerView*)pagerView{
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc]init];
        _pagerView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 180*autoSizeScaleY);
        _pagerView.layer.borderWidth = 0;
        _pagerView.autoScrollInterval = 3.0;
        _pagerView.isInfiniteLoop = YES;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        [_pagerView registerNib:[UINib nibWithNibName:@"TYCyclePagerViewCell" bundle:nil] forCellWithReuseIdentifier:@"TYCyclePagerViewCell"];
    }
    
    return _pagerView;
}

-(LBDisplayPageView*)displayPageView{

    if (!_displayPageView) {
        _displayPageView = [[LBDisplayPageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.pagerView.frame) * 0.8 - 45, 180*autoSizeScaleY - 35, 30, 30)];
        _displayPageView.backgroundColor = YYSRGBColor(255, 255, 255, 0.5);
        _displayPageView.layer.cornerRadius = 15;
        _displayPageView.clipsToBounds = YES;
        _displayPageView.labelCount.attributedText = [self setLabelAttribute:@"1/" text:[NSString stringWithFormat:@"1/%lu",(unsigned long)self.bannerArr.count]];
    }

    return _displayPageView;
}

@end
