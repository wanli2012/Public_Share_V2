//
//  LBMineViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineViewController.h"
#import "MineCollectionHeaderV.h"
#import "LBMineCenterCollectionViewCell.h"
#import "UIButton+SetEdgeInsets.h"
#import "LBSetUpViewController.h"

#import "LBMineCenterReceivingGoodsViewController.h"
#import "LBMineCenterMyOrderViewController.h"

#import "GLMyHeartController.h"
#import "GLDirectDonationController.h"
#import "GLMine_MyBeansController.h"
#import "GLBuyBackController.h"
#import "GLDonationController.h"
#import "GLRecommendController.h"
#import "GLMine_InfoController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GLNoneOfDonationController.h"
#import "LBMineStoreOrderingViewController.h"
#import "LBMineCenterUsualUnderOrderViewController.h"
#import "LBSaleManPersonInfoViewController.h"
#import "LBBelowTheLineViewController.h"
#import "LBBaiduMapViewController.h"
#import "GLShoppingCartController.h"
#import <SDWebImage/UIButton+WebCache.h>

#import "GLMyCollectionController.h"
#import "GLIncomeManagerController.h"
#import "GLMemberManagerController.h"
#import "GLMerchat_StoreController.h"
#import "LBProductManagementViewController.h"
#import "GLRecommendStoreController.h"

#import "LBMerchantSubmissionFourViewController.h"
#import "LBRecommendedSalesmanViewController.h"
#import "GLMine_CompleteInfoView.h"

#import "GLAdModel.h"//广告数据模型
#import "GLMine_AdController.h"
#import "MineCollectionViewFlowLayout.h"

#import "LBHomeIncomeViewController.h"
#import "LBShowSaleManAndBusinessViewController.h"
#import "LBBelowTheLineViewController.h"
#import "GLMerchat_CommentController.h"

#import "LBImprovePersonalDataViewController.h"//完善资料  实名认证
#import "LBStoreMoreInfomationViewController.h"//逛逛 商家详情
#import "LBStoreProductDetailInfoViewController.h"//逛逛  逛逛商品详情
#import "GLHourseDetailController.h"//米劵商品

#import "LBMineSystemMessageViewController.h"

static CGFloat headViewH = 300;

@interface LBMineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,SDCycleScrollViewDelegate>{
    UIImageView *_imageviewLeft;
}
@property(nonatomic,strong)UICollectionView *collectionV;
@property(nonatomic,strong) MineCollectionHeaderV *headview;
@property(nonatomic,strong)NSArray *titlearr;
@property(nonatomic,strong)NSArray *imageArr;
@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)NSString *ordertype;//订单类型 默认为线上类型 1 为线上 2线下

@property (strong, nonatomic)NSMutableArray *CarouselArr;//轮播图图片

@property (nonatomic, strong)GLMine_CompleteInfoView *infoContentV;

@property (nonatomic, strong)UIView *maskV;

@property (strong, nonatomic)LoadWaitView *loadV;

@property (nonatomic, strong)NSMutableArray *adModels;
@property (weak, nonatomic) IBOutlet UIView *navaView;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@end

@implementation LBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self addMySelfPanGesture];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 注册表头
    [self.collectionV registerClass:[MineCollectionHeaderV class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MineCollectionHeaderV"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"LBMineCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBMineCenterCollectionViewCell"];
    
    [self.view insertSubview:self.collectionV atIndex:0];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMineCollection) name:@"refreshMine" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataSource) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    
    _ordertype = @"1";
    
}

-(void)refreshMineCollection{
    
    [self.collectionV reloadData];
    [self.headview.tableview reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     self.navigationController.navigationBar.hidden = YES;
    [self refreshDataSource];
    
    if (self.adModels.count<=0) {
        [self getdatasorce];
    }
    
}

-(void)pushToInfoVC{
    
    if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser] || [[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        self.hidesBottomBarWhenPushed=YES;
        GLMine_InfoController *infoVC = [[GLMine_InfoController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else{
        self.hidesBottomBarWhenPushed=YES;
        LBSaleManPersonInfoViewController *infoVC = [[LBSaleManPersonInfoViewController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer] || [[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser] || [[UserModel defaultUser].usrtype isEqualToString:ONESALER] || [[UserModel defaultUser].usrtype isEqualToString:TWOSALER] || [[UserModel defaultUser].usrtype isEqualToString:THREESALER]) {
        return self.titlearr.count ;
    }else {
        return self.titlearr.count - 1;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"LBMineCenterCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    
    cell.imagev.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.titile.text = [NSString stringWithFormat:@"%@",self.titlearr[indexPath.row]];
   
    return cell;
    
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH)/3, ((SCREEN_WIDTH)/3));

}

//选择cell时
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        [self MerchantJump:indexPath.item];
    }else if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
         [self RegularMemberJump:indexPath.item];
    }
    else{
        [self PromoterJump:indexPath.item];
    }
}


-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (!_headview) {
        _headview = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                       withReuseIdentifier:@"MineCollectionHeaderV"
                                                              forIndexPath:indexPath];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToInfoVC)];
        [_headview.headimage addGestureRecognizer:tap];
        [_headview.backimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[UserModel defaultUser].headPic]] placeholderImage:[UIImage imageNamed:@"背景渲染图片"]];
        [_headview.headimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[UserModel defaultUser].headPic]]];
        
        if (!_headview.headimage.image) {
            
            _headview.headimage.image = [UIImage imageNamed:@"dtx_icon"];
        }
        
        
    }
    
    
    _headview.namelebel.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].truename];
    _headview.IDlebel.text = [NSString stringWithFormat:@"%@",[UserModel defaultUser].name];
    
    if (_headview.namelebel.text.length <= 0 || [_headview.namelebel.text rangeOfString:@"null"].location != NSNotFound) {
        _headview.namelebel.text = @"用户名";
    }

    if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
        _headview.identitylebel.text = @"会员";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]){
        _headview.identitylebel.text  = @"商家";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:ONESALER]){
        _headview.identitylebel.text  = @"大区创客";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:TWOSALER]){
        _headview.identitylebel.text  = @"城市创客";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:THREESALER]){
        _headview.identitylebel.text  = @"创客";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:PROVINCE]){
        _headview.identitylebel.text  = @"省级服务中心";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:CITY]){
        _headview.identitylebel.text  = @"市级服务中心";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:DISTRICT]){
        _headview.identitylebel.text  = @"区级服务中心";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:PROVINCE_INDUSTRY]){
        _headview.identitylebel.text  = @"省级行业服务中心";
    }else if ([[UserModel defaultUser].usrtype isEqualToString:CITY_INDUSTRY]){
        _headview.identitylebel.text  = @"市级行业服务中心";
    }

    
    return _headview;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

#pragma mark --- 不同身份之间的逻辑跳转

-(void)RegularMemberJump:(NSInteger)item{

    switch (item) {
        case 0:
        {
            self.hidesBottomBarWhenPushed=YES;
            LBMineCenterReceivingGoodsViewController *vc=[[LBMineCenterReceivingGoodsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 1:
        {
            self.hidesBottomBarWhenPushed=YES;
            LBMineCenterMyOrderViewController *vc=[[LBMineCenterMyOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 2:
        {
            LBMineCenterUsualUnderOrderViewController *vc=[[LBMineCenterUsualUnderOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 3:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLMyHeartController *vc=[[GLMyHeartController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 4:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLRecommendStoreController *vc1=[[GLRecommendStoreController alloc]init];
            [self.navigationController pushViewController:vc1 animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 5:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLMine_MyBeansController *vc=[[GLMine_MyBeansController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 6:
        {
            if ([[UserModel defaultUser].rzstatus isEqualToString:@"2"]) {
                
                self.hidesBottomBarWhenPushed=YES;
                GLBuyBackController *vc=[[GLBuyBackController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                
            }else if ([[UserModel defaultUser].rzstatus isEqualToString:@"1"]) {
                [MBProgressHUD showError:@"审核中"];
            }else{
                [self.view addSubview:self.maskV];
                [self.maskV addSubview:self.infoContentV];
                self.infoContentV.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
                [UIView animateWithDuration:0.2 animations:^{
                    
                    self.infoContentV.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
                }];
                
            }
        }
            break;
        case 7:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLMyCollectionController *vc=[[GLMyCollectionController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 8:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLRecommendController *vc=[[GLRecommendController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 9:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLDonationController *vc=[[GLDonationController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
      
        default:
            break;
    }
}

-(void)MerchantJump:(NSInteger)item{
    switch (item) {
        case 0://待收货
        {
            self.hidesBottomBarWhenPushed=YES;
            LBMineCenterReceivingGoodsViewController *vc=[[LBMineCenterReceivingGoodsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 1://线上订单
        {
            self.hidesBottomBarWhenPushed=YES;
            LBMineCenterMyOrderViewController *vc=[[LBMineCenterMyOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 2://线下订单
        {
            LBMineCenterUsualUnderOrderViewController *vc=[[LBMineCenterUsualUnderOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 3://我的米分
        {
            self.hidesBottomBarWhenPushed=YES;
            GLMyHeartController *vc=[[GLMyHeartController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 4://收益管理
        {
            self.hidesBottomBarWhenPushed=YES;
            LBHomeIncomeViewController *vc1=[[LBHomeIncomeViewController alloc]init];
            [self.navigationController pushViewController:vc1 animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 5://我的米柜
        {
            self.hidesBottomBarWhenPushed=YES;
            GLMine_MyBeansController *vc=[[GLMine_MyBeansController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 6://会员管理
        {
            self.hidesBottomBarWhenPushed=YES;
            GLMemberManagerController *vc=[[GLMemberManagerController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            
        }
            break;
        case 7://商品管理
        {
            self.hidesBottomBarWhenPushed=YES;
            LBProductManagementViewController *vc=[[LBProductManagementViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 8://门店管理
        {

                self.hidesBottomBarWhenPushed=YES;
                GLMerchat_StoreController *vc=[[GLMerchat_StoreController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                
        
            
        }
            break;
        case 9://我要下单
        {
            if ([[UserModel defaultUser].rzstatus isEqualToString:@"2"]) {
                
                self.hidesBottomBarWhenPushed=YES;
                LBBelowTheLineViewController *vc=[[LBBelowTheLineViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                
            }else if ([[UserModel defaultUser].rzstatus isEqualToString:@"1"]) {
                [MBProgressHUD showError:@"审核中"];
            }else{
                self.hidesBottomBarWhenPushed=YES;
                LBImprovePersonalDataViewController *vc=[[LBImprovePersonalDataViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
            
        }
            break;
        case 10:   {//商品列表
            self.hidesBottomBarWhenPushed=YES;
            GLMerchat_CommentController *vc=[[GLMerchat_CommentController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;

        }
            break;
        case 11://推荐
        {
            self.hidesBottomBarWhenPushed=YES;
            GLRecommendController *vc=[[GLRecommendController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
            
        case 12:{//兑换
        
            if ([[UserModel defaultUser].rzstatus isEqualToString:@"2"]) {
                
                self.hidesBottomBarWhenPushed=YES;
                GLBuyBackController *vc=[[GLBuyBackController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                
            }else if ([[UserModel defaultUser].rzstatus isEqualToString:@"1"]) {
                [MBProgressHUD showError:@"审核中"];
            }else{
                self.hidesBottomBarWhenPushed=YES;
                LBImprovePersonalDataViewController *vc=[[LBImprovePersonalDataViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
        }
            break;
            
        case 13://收藏
        {
            self.hidesBottomBarWhenPushed=YES;
            GLMyCollectionController *vc=[[GLMyCollectionController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 14://转赠
        {
            
            self.hidesBottomBarWhenPushed=YES;
            GLDonationController *vc=[[GLDonationController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
            
        default:
            break;
    }
}

-(void)PromoterJump:(NSInteger)item{
    
    switch (item) {
        case 0:
        {
            self.hidesBottomBarWhenPushed=YES;
            LBMineCenterReceivingGoodsViewController *vc=[[LBMineCenterReceivingGoodsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 1:
        {
            self.hidesBottomBarWhenPushed=YES;
            LBMineCenterMyOrderViewController *vc=[[LBMineCenterMyOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 2:
        {
            LBMineCenterUsualUnderOrderViewController *vc=[[LBMineCenterUsualUnderOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 3:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLMyHeartController *vc=[[GLMyHeartController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 4:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLIncomeManagerController *vc1=[[GLIncomeManagerController alloc]init];
            [self.navigationController pushViewController:vc1 animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 5:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLMine_MyBeansController *vc=[[GLMine_MyBeansController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 6://开通商户
        {
                self.hidesBottomBarWhenPushed=YES;
                LBMerchantSubmissionFourViewController *vc=[[LBMerchantSubmissionFourViewController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                self.hidesBottomBarWhenPushed=NO;
                
        }
            break;
        case 7://开通创客
        {
            if ([[UserModel defaultUser].usrtype isEqualToString:THREESALER]) {
                [MBProgressHUD showError:@"您暂无权限访问"];
            }else{
                
                self.hidesBottomBarWhenPushed=YES;
                LBRecommendedSalesmanViewController *vc=[[LBRecommendedSalesmanViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
            }
        }
            break;
            
        case 8:
        {
            self.hidesBottomBarWhenPushed=YES;
            LBShowSaleManAndBusinessViewController *vc=[[LBShowSaleManAndBusinessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
            
        case 9://兑换
        {
            if ([[UserModel defaultUser].rzstatus isEqualToString:@"2"]) {
                
                self.hidesBottomBarWhenPushed=YES;
                GLBuyBackController *vc=[[GLBuyBackController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                
            }else if ([[UserModel defaultUser].rzstatus isEqualToString:@"1"]) {
                [MBProgressHUD showError:@"审核中"];
            }else{
                
                self.hidesBottomBarWhenPushed=YES;
                LBImprovePersonalDataViewController *vc=[[LBImprovePersonalDataViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed=NO;
                
            }

        }
            break;
        case 10:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLMyCollectionController *vc=[[GLMyCollectionController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 11:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLRecommendController *vc=[[GLRecommendController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
        case 12:
        {
            self.hidesBottomBarWhenPushed=YES;
            GLDonationController *vc=[[GLDonationController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark ---- button
//设置
- (IBAction)setupevent:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    LBSetUpViewController *vc=[[LBSetUpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
   
    /*
    self.hidesBottomBarWhenPushed=YES;
    LBMineCenterMYOrderEvaluationDetailViewController *vc=[[LBMineCenterMYOrderEvaluationDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
     */
}

//消息
- (IBAction)messagebutton:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    LBMineSystemMessageViewController *vc=[[LBMineSystemMessageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
}

#pragma mark 懒加载

-(UICollectionView *)collectionV{

    if (!_collectionV) {
        
         MineCollectionViewFlowLayout *flowLayout=[[MineCollectionViewFlowLayout alloc] init];
         //[flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 10, 0)];
        [flowLayout setHeaderReferenceSize:CGSizeMake(SCREEN_WIDTH,headViewH  + (90 * autoSizeScaleX - 90)*autoSizeScaleX)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumInteritemSpacing:0.0];
        [flowLayout setMinimumLineSpacing:0.0];
        
        _collectionV =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50)collectionViewLayout:flowLayout];
        _collectionV.backgroundColor = [UIColor whiteColor];
        _collectionV.alwaysBounceVertical = YES;
        _collectionV.showsVerticalScrollIndicator = NO;
        //设置代理
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
    }
    return _collectionV;
}

-(NSArray*)titlearr{

    if (!_titlearr) {
        if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
            _titlearr=[NSArray arrayWithObjects:@"待收货",@"线上订单",@"线下订单",@"我的米分",@"收益管理",@"我的米柜",@"会员管理",@"商品管理",@"门店管理",@"我要下单",@"商品列表",@"推荐",@"兑换",@"收藏",@"转赠", nil];
        }else if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
           _titlearr=[NSArray arrayWithObjects:@"待收货",@"线上订单",@"线下订单",@"我的米分",@"我要推店",@"我的米柜",@"兑换",@"收藏",@"推荐",@"转赠", nil];
        }
        else{
           _titlearr=[NSArray arrayWithObjects:@"待收货",@"线上订单",@"线下订单",@"我的米分",@"收益管理",@"我的米柜",@"开通商家",@"开通创客",@"创客列表",@"兑换",@"收藏",@"推荐",@"转赠", nil];
        }
    }
    return _titlearr;

}

-(NSArray*)imageArr{

    if (!_imageArr) {
        
        if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
            _imageArr=[NSArray arrayWithObjects:@"待收货",@"线上订单",@"线下订单",@"我的米分",@"收益管理",@"我的米柜",@"会员管理",@"商品管理",@"门店管理",@"我要下单",@"商品列表",@"推荐",@"兑换",@"收藏",@"互赠", nil];
        }else if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
            _imageArr=[NSArray arrayWithObjects:@"待收货",@"线上订单",@"线下订单",@"我的米分",@"我要推店",@"我的米柜",@"兑换",@"收藏",@"推荐", @"互赠",nil];
        }
        else {
            _imageArr=[NSArray arrayWithObjects:@"待收货",@"线上订单",@"线下订单",@"我的米分",@"收益管理",@"我的米柜",@"开通商家",@"开通创客",@"创客列表",@"兑换",@"收藏",@"推荐", @"互赠",nil];
        }
    }
    return _imageArr;
}

//点击maskview
-(void)maskviewgesture{
    
   
}
#pragma mark - scrolleViewDelegete

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y <= 0) {

        self.navaView.backgroundColor = YYSRGBColor(120, 161, 255, 0);
    }else{

        self.navaView.backgroundColor = YYSRGBColor(120, 161, 255, (scrollView.contentOffset.y)/64);
    
    }
}
-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
        
    }
    return _maskView;
}
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
//刷新数据
-(void)refreshDataSource{

    [NetworkManager requestPOSTWithURLStr:@"user/refresh" paramDic:@{@"token":[UserModel defaultUser].token,@"uid":[UserModel defaultUser].uid} finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == 1) {
            
            [UserModel defaultUser].mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mark"]];
            [UserModel defaultUser].loveNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"loveNum"]];
            [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"common"]];
            [UserModel defaultUser].djs_bean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"taxes"]];
            [UserModel defaultUser].giveMeMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"give_me_bean"]];
            [UserModel defaultUser].lastFanLiTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lasttime"]];
            [UserModel defaultUser].recommendMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"tjtc"]];
            [UserModel defaultUser].truename = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"truename"]];
            [UserModel defaultUser].shop_address = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_address"]];
            [UserModel defaultUser].shop_type = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_type"]];
            [UserModel defaultUser].idcard = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"idcard"]];
            [UserModel defaultUser].headPic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pic"]];
            [UserModel defaultUser].AudiThrough = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"status"]];
            [UserModel defaultUser].t_one = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_one"]];
            [UserModel defaultUser].t_two = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_two"]];
            [UserModel defaultUser].t_three = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_three"]];
            
            [UserModel defaultUser].allLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"allLimit"]];
            [UserModel defaultUser].isapplication = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"isapplication"]];
            [UserModel defaultUser].surplusLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"surplusLimit"]];
            [UserModel defaultUser].shop_phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_phone"]];
            
            [UserModel defaultUser].back = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"back"]];
            
            [UserModel defaultUser].bonus_log = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"bonus_log"]];
            [UserModel defaultUser].log = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"log"]];
            [UserModel defaultUser].order_line = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"order_line"]];
            [UserModel defaultUser].system_message = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"system_message"]];
            [UserModel defaultUser].give = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"msg_no"][@"give"]];
            
            [UserModel defaultUser].pre_phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pre_phone"]];
            [UserModel defaultUser].single = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"single"]];
            
            if ([[UserModel defaultUser].idcard rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].idcard = @"";
            }
            if ([[UserModel defaultUser].shop_type rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].shop_type = @"";
            }
            if ([[UserModel defaultUser].shop_address rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].shop_address = @"";
            }
            if ([[UserModel defaultUser].truename rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].truename = @"";
            }
            if ([[UserModel defaultUser].single rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].single = @"0.00";
            }
            
            [usermodelachivar achive];
            
            [self.headview.headimage sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].headPic]];
            
            if (!self.headview.headimage.image) {
                
                self.headview.headimage.image = [UIImage imageNamed:@"dtx_icon"];
            }
            
        }else{
            
        }
        
        if ([[UserModel defaultUser].back integerValue] == 0 && [[UserModel defaultUser].bonus_log integerValue] == 0 && [[UserModel defaultUser].log integerValue] == 0 && [[UserModel defaultUser].order_line integerValue] == 0 && [[UserModel defaultUser].system_message integerValue] == 0 && [[UserModel defaultUser].give integerValue] == 0) {
            self.signImageV.hidden = YES;
        }else{
            self.signImageV.hidden = NO;
        }
        
        [self.headview.tableview reloadData];
    } enError:^(NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark 点击图片代理
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    if(self.adModels.count == 0){
        return;
    }
    
    GLAdModel *model = self.adModels[index];
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([model.type integerValue] == 1) {//内部广告
        if([model.jumptype integerValue] == 1){//跳转商户
            
            LBStoreMoreInfomationViewController *storeVC = [[LBStoreMoreInfomationViewController alloc] init];
            storeVC.storeId = model.jumpid;
            storeVC.lat = [[GLNearby_Model defaultUser].latitude floatValue];
            storeVC.lng = [[GLNearby_Model defaultUser].longitude floatValue];
            [self.navigationController pushViewController:storeVC animated:YES];
            
        }else{//跳转商品

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

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    
}

//获取广告数据
-(void)getdatasorce{
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/advert" paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {

                [self.adModels removeAllObjects];
                
                self.CarouselArr = responseObject[@"data"];
                NSMutableArray *imageArr=[NSMutableArray array];
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLAdModel *model = [GLAdModel mj_objectWithKeyValues:dic];
                    [self.adModels addObject:model];
                }
                
                for ( int i = 0; i < self.adModels.count; i ++) {
                    GLAdModel *model = self.adModels[i];
                    [imageArr addObject:model.thumb];
                }
                
                self.headview.cycleScrollView.delegate = self;
                self.headview.cycleScrollView.imageURLStringsGroup = imageArr;

            }
            
        }else{
            
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}

- (void)maskViewTap {
    
    [self.infoContentV removeFromSuperview];
    [self.maskV removeFromSuperview];
}
//会员不全信息
- (void)addQtIDandOilCardID{
    
    if (self.infoContentV.qtIDTextF.text.length == 0) {
        [MBProgressHUD showError:@"请输入身份证号"];
        return;
    }
    if (self.infoContentV.oilCardTextF.text.length == 0) {
        [MBProgressHUD showError:@"请输入真实姓名"];
        return;
    }
    
    if(![predicateModel validateIdentityCard:self.infoContentV.qtIDTextF.text]){
        [MBProgressHUD showError:@"输入的身份证不合法"];
        return;
    }
    
    if (self.infoContentV.paySecretTf.text.length == 0) {
        [MBProgressHUD showError:@"请输入交易密码"];
        return;
    }
    if (self.infoContentV.paySecretTf.text.length != 6) {
        [MBProgressHUD showError:@"请输入6位交易密码"];
        return;
    }
    
    if (self.infoContentV.ensureSecretTf.text.length == 0) {
        [MBProgressHUD showError:@"请确认交易密码"];
        return;
    }
    
    if (![self.infoContentV.ensureSecretTf.text isEqualToString:self.infoContentV.paySecretTf.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }

    NSString *encryptsecret = [RSAEncryptor encryptString:self.infoContentV.ensureSecretTf.text publicKey:public_RSA];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"truename"] = self.infoContentV.oilCardTextF.text;
    dict[@"idcard"] = self.infoContentV.qtIDTextF.text;
    dict[@"twopwd"] = encryptsecret;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"user/bqUserInfo" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            [self maskViewTap];
            [UserModel defaultUser].idcard = self.infoContentV.qtIDTextF.text;
            [UserModel defaultUser].truename = self.infoContentV.oilCardTextF.text;
            [UserModel defaultUser].rzstatus = @"2";
            [usermodelachivar achive];
            
            self.hidesBottomBarWhenPushed=YES;
            GLBuyBackController *vc=[[GLBuyBackController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
    
        }
        
        [MBProgressHUD showError:responseObject[@"message"]];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

    
}

- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.infoContentV.qtIDTextF && [string isEqualToString:@"\n"]) {
        [self.infoContentV.oilCardTextF becomeFirstResponder];
        return NO;
        
    }else if (textField == self.infoContentV.oilCardTextF && [string isEqualToString:@"\n"]){
        
        [self.infoContentV.paySecretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.infoContentV.paySecretTf && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
    
}

-(NSMutableArray*)CarouselArr{

    if (!_CarouselArr) {
        _CarouselArr=[NSMutableArray array];
    }

    return _CarouselArr;
}

- (GLMine_CompleteInfoView *)infoContentV{
    if (!_infoContentV) {
        _infoContentV = [[NSBundle mainBundle] loadNibNamed:@"GLMine_CompleteInfoView" owner:nil options:nil].lastObject;
        
        _infoContentV.layer.cornerRadius = 5.f;
        
        _infoContentV.frame = CGRectMake(20, (SCREEN_HEIGHT - 250)/2, SCREEN_WIDTH - 40, 250);
        
        [_infoContentV.cancelBtn addTarget:self action:@selector(maskViewTap) forControlEvents:UIControlEventTouchUpInside];
        
        [_infoContentV.okBtn addTarget:self action:@selector(addQtIDandOilCardID) forControlEvents:UIControlEventTouchUpInside];
        
        _infoContentV.oilCardTextF.delegate = self;
        _infoContentV.qtIDTextF.delegate = self;
        _infoContentV.paySecretTf.delegate = self;
        _infoContentV.ensureSecretTf.delegate = self;
        
    }
    return _infoContentV;
}
- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskV.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        
        UITapGestureRecognizer *maskViewTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
        [_maskV addGestureRecognizer:maskViewTap];
    }
    return _maskV;
}
- (NSMutableArray *)adModels{
    if (!_adModels) {
        _adModels = [NSMutableArray array];
    }
    return _adModels;
}
@end
