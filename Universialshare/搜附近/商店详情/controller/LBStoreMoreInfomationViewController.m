//
//  LBStoreMoreInfomationViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreMoreInfomationViewController.h"
#import "MXNavigationBarManager.h"
#import "SDCycleScrollView.h"
#import "LBStoreDetailHeaderView.h"
#import "LBStoreDetailNameTableViewCell.h"
#import "LBStoreDetailAdressTableViewCell.h"
#import "LBStoreDetailHotProductTableViewCell.h"
#import "LBStoreDetailreplaysTableViewCell.h"
#import "LBStoreDetailRecomendTableViewCell.h"
#import "LBStoreProductDetailInfoViewController.h"

static const CGFloat headerImageHeight = 150.0f;

@interface LBStoreMoreInfomationViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)UIButton *shareButton;

@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏

@end

@implementation LBStoreMoreInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"商店名称";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:0],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];

    [self.tableview registerNib:[UINib nibWithNibName:@"LBStoreDetailNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailNameTableViewCell"];

    [self.tableview registerNib:[UINib nibWithNibName:@"LBStoreDetailAdressTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailAdressTableViewCell"];

    [self.tableview registerNib:[UINib nibWithNibName:@"LBStoreDetailHotProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailHotProductTableViewCell"];

    [self.tableview registerNib:[UINib nibWithNibName:@"LBStoreDetailreplaysTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailreplaysTableViewCell"];

    [self.tableview registerNib:[UINib nibWithNibName:@"LBStoreDetailRecomendTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailRecomendTableViewCell"];

    [self.tableview addSubview:self.cycleScrollView];
    self.tableview.contentInset=UIEdgeInsetsMake(headerImageHeight, 0, 0, 0);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:self.shareButton];
    self.navigationItem.rightBarButtonItem=item;
    
     [self initBarManager];
}

- (void)initBarManager {
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:TABBARTITLE_COLOR];
    //[MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
    [MXNavigationBarManager setZeroAlphaOffset:-headerImageHeight];
    [MXNavigationBarManager setFullAlphaOffset:-headerImageHeight + 150];
    //[MXNavigationBarManager setFullAlphaBarStyle:UIStatusBarStyleLightContent];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [MXNavigationBarManager changeAlphaWithCurrentOffset:scrollView.contentOffset.y];
    if (scrollView.contentOffset.y <= 0) {
         [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:(scrollView.contentOffset.y+headerImageHeight)/headerImageHeight],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    }
   
    //获取偏移量
    CGPoint offset = scrollView.contentOffset;

    //判断是否改变
    if (offset.y < -headerImageHeight) {
        CGRect rect = self.cycleScrollView.frame;
        //我们只需要改变图片的y值和高度即可
        rect.origin.y = offset.y;
        rect.size.height =  -offset.y ;
        self.cycleScrollView.frame = rect;
        
    }
    
    if (scrollView.contentOffset.y > -64) {
        self.tableview.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    }else{
        self.tableview.contentInset=UIEdgeInsetsMake(headerImageHeight, 0, 0, 0);
    
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.HideNavagation == NO) {
        [MXNavigationBarManager reStoreToCustomNavigationBar:self];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = NO;
    self.HideNavagation = NO;
   
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return 3;
    }else if (section == 3){
        return 2;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 65;
        }else{
            return 65;
        }
        
    }else if (indexPath.section == 1){
        return 70;
        
    }else if (indexPath.section == 2){
        self.tableview.estimatedRowHeight = 70;
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
        
    }else if (indexPath.section == 3){
        return 80;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            LBStoreDetailNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailNameTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            LBStoreDetailAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailAdressTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }
        
    }else if (indexPath.section == 1){
        LBStoreDetailHotProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailHotProductTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
    
    }else if (indexPath.section == 2){
        LBStoreDetailreplaysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailreplaysTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
        
    }else if (indexPath.section == 3){
        LBStoreDetailRecomendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailRecomendTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
        
    }
    
    return [[UITableViewCell alloc]init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    return 40;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LBStoreDetailHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBStoreDetailHeaderView"];
    if (!headerview) {
        headerview = [[LBStoreDetailHeaderView alloc] initWithReuseIdentifier:@"LBStoreDetailHeaderView"];
        
    }
    
    if (section == 0){
        headerview.titleLb.hidden = YES;
        headerview.moreBt.hidden = YES;
    }else if (section == 1){
       headerview.titleLb.text = @"热卖商品";
       headerview.moreBt.hidden = YES;
       headerview.titleLb.hidden = NO;
    }else if (section == 2){
        headerview.titleLb.text = @"评论";
        [headerview.moreBt setTitle:@"查看更多" forState:UIControlStateNormal];
        headerview.moreBt.hidden = NO;
        headerview.titleLb.hidden = NO;
    }else if (section == 3){
        [headerview.moreBt setTitle:@"换一批" forState:UIControlStateNormal];
        headerview.titleLb.text = @"猜你喜欢";
        headerview.moreBt.hidden = NO;
        headerview.titleLb.hidden = NO;
    }
    
    return headerview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        self.HideNavagation = YES;
        self.hidesBottomBarWhenPushed = YES;
        LBStoreProductDetailInfoViewController *vc=[[LBStoreProductDetailInfoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}


//分享
-(void)shareStoreAdress{


}

-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -headerImageHeight, SCREEN_WIDTH, headerImageHeight)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
        
        _cycleScrollView.localizationImageNamesGroup = @[];
        
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    }
    
    return _cycleScrollView;
    
}

-(UIButton*)shareButton{

    if (!_shareButton) {
        _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_shareButton setImage:[UIImage imageNamed:@"mine_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareStoreAdress) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.backgroundColor = [UIColor clearColor];
        _shareButton.imageEdgeInsets = UIEdgeInsetsMake(5, 14, 5, 0);
    }
 
    return _shareButton;

}

@end
