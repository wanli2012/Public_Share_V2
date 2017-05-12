//
//  LBShowSaleManAndBusinessViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBShowSaleManAndBusinessViewController.h"
#import "LBMySalesmanListViewController.h"
#import "LBMyBusinessListViewController.h"
#import "LBMySalesmanListDeatilViewController.h"
#import "LBMyBusinessListDetailViewController.h"
#import "LBSaleManPersonInfoViewController.h"
#import "LBViewProtocolViewController.h"
#import <MapKit/MapKit.h>
#import "LBMySalesmanListAuditViewController.h"
#import "LBMySalesmanListFaildViewController.h"
#import "LBMySalesmanListView.h"

@interface LBShowSaleManAndBusinessViewController ()
@property (weak, nonatomic) IBOutlet UIView *navigationV;
@property (weak, nonatomic) IBOutlet UIView *buttonv;
@property (weak, nonatomic) IBOutlet UIButton *saleBt;
@property (weak, nonatomic) IBOutlet UIButton *businessBt;
@property (weak, nonatomic) IBOutlet UIButton *shenheZBt;

@property (strong, nonatomic)LBMySalesmanListAuditViewController *AuditVc;
@property (strong, nonatomic)LBMySalesmanListViewController *scuessVc;
@property (strong, nonatomic)LBMySalesmanListFaildViewController *faildVc;
@property (nonatomic, strong)UIViewController *currentViewController;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIView *lineView;

@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)NSString *usertype;
@property (strong, nonatomic)LBMySalesmanListView *mySalesmanListView;

@end

@implementation LBShowSaleManAndBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    //    self.navigationItem.title = @"商家列表";
      self.automaticallyAdjustsScrollViewInsets = NO;
     [self.buttonv addSubview:self.lineView];
    
    _AuditVc=[[LBMySalesmanListAuditViewController alloc]init];
    _scuessVc=[[LBMySalesmanListViewController alloc]init];
    _faildVc=[[LBMySalesmanListFaildViewController alloc]init];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT-114)];
    [self.view addSubview:_contentView];
    
    [self addChildViewController:_AuditVc];
    [self addChildViewController:_scuessVc];
    [self addChildViewController:_faildVc];
    
    self.currentViewController = _faildVc;
    [self fitFrameForChildViewController:_faildVc];
    [self.contentView addSubview:_faildVc.view];
    
    __weak typeof(self) weakself = self;
    _scuessVc.returnpushvc = ^(NSDictionary *dic){
    
        if ([dic[@"saleman_type"] integerValue] == 8) {
//            weakself.hidesBottomBarWhenPushed = YES;
//            LBMyBusinessListViewController *vc=[[LBMyBusinessListViewController alloc]init];
//            vc.HideNavB = YES;
//            [weakself.navigationController pushViewController:vc animated:YES];
//            weakself.hidesBottomBarWhenPushed = NO;
        }else {
            weakself.hidesBottomBarWhenPushed = YES;
            LBMySalesmanListDeatilViewController *vc=[[LBMySalesmanListDeatilViewController alloc]init];
            vc.dic = dic;
            [weakself.navigationController pushViewController:vc animated:YES];
            weakself.hidesBottomBarWhenPushed = NO;
        }
    };
}

- (IBAction)salemanEvent:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(0, 48, SCREEN_WIDTH / 3, 1);
        [self.saleBt setTitleColor:YYSRGBColor(44, 153, 46, 1) forState:UIControlStateNormal];
        [self.businessBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.shenheZBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
    
    [self transitionFromVC:self.currentViewController toviewController:_faildVc];
    [self fitFrameForChildViewController:_faildVc];
}


- (IBAction)businessEvent:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(SCREEN_WIDTH/3 , 48, SCREEN_WIDTH / 3, 1);
        [self.businessBt setTitleColor:YYSRGBColor(44, 153, 46, 1) forState:UIControlStateNormal];
        [self.saleBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.shenheZBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
    
    [self transitionFromVC:self.currentViewController toviewController:_scuessVc];
    [self fitFrameForChildViewController:_scuessVc];
    
}

- (IBAction)shenhezhong:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(SCREEN_WIDTH/3 * 2, 48, SCREEN_WIDTH / 3, 1);
        [self.saleBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.businessBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.shenheZBt setTitleColor:YYSRGBColor(44, 153, 46, 1) forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
    
    [self transitionFromVC:self.currentViewController toviewController:_AuditVc];
    [self fitFrameForChildViewController:_AuditVc];
    
}
//帅选
- (IBAction)shaixuanEvent:(UIButton *)sender {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [self.maskView addSubview:self.mySalesmanListView];
    
}
//移除maskview
-(void)maskviewgesture{
 
    [self.mySalesmanListView removeFromSuperview];
    [self.maskView removeFromSuperview];

}
//选择推广员
-(void)salegesture{
    [self.mySalesmanListView removeFromSuperview];
    [self.maskView removeFromSuperview];
    self.titleLb.text = @"推广员";
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"filterExtensionCategories" object:nil userInfo:@{@"indexVc":@1}];

}
//选择高级推广员
-(void)supersalegesture{
    [self.mySalesmanListView removeFromSuperview];
    [self.maskView removeFromSuperview];
    self.titleLb.text = @"高级推广员";
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"filterExtensionCategories" object:nil userInfo:@{@"indexVc":@2}];

}
//选择商户
-(void)storegesture{
    [self.mySalesmanListView removeFromSuperview];
    [self.maskView removeFromSuperview];
   self.titleLb.text = @"商户";
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"filterExtensionCategories" object:nil userInfo:@{@"indexVc":@3}];

}

- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}

- (void)transitionFromVC:(UIViewController *)viewController toviewController:(UIViewController *)toViewController {
    
    if ([toViewController isEqual:self.currentViewController]) {
        return;
    }
    [self transitionFromViewController:viewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:^(BOOL finished) {
        [viewController willMoveToParentViewController:nil];
        [toViewController willMoveToParentViewController:self];
        self.currentViewController = toViewController;
    }];
    
    
    
}

-(UIView*)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH / 3, 1)];
        _lineView.backgroundColor = YYSRGBColor(44, 153, 46, 1);
    }
    
    return _lineView;
    
}

-(LBMySalesmanListView*)mySalesmanListView{
    
    if (!_mySalesmanListView) {
        _mySalesmanListView=[[NSBundle mainBundle]loadNibNamed:@"LBMySalesmanListView" owner:self options:nil].firstObject;
        _mySalesmanListView.frame=CGRectMake(SCREEN_WIDTH - 140, 64, 130, 180);
        _mySalesmanListView.alpha=1;
        UITapGestureRecognizer *salegesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(salegesture)];
        [_mySalesmanListView.saleview addGestureRecognizer:salegesture];
        UITapGestureRecognizer *supersalegesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(supersalegesture)];
        [_mySalesmanListView.superView addGestureRecognizer:supersalegesture];
        UITapGestureRecognizer *storegesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(storegesture)];
        [_mySalesmanListView.storeView addGestureRecognizer:storegesture];
        
    }
    
    return _mySalesmanListView;
    
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0f]];
        UITapGestureRecognizer *maskvgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskviewgesture)];
        [_maskView addGestureRecognizer:maskvgesture];
    }
    return _maskView;
    
}

@end
