//
//  BasetabbarViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "BasetabbarViewController.h"
#import "GLHomePageController.h"
#import "LBIntegralMallViewController.h"
#import "LBMineViewController.h"
#import "BaseNavigationViewController.h"

#import "GLLoginController.h"

#import "LBImprovePersonalDataViewController.h"
#import "LBMineStoreOrderingViewController.h"
#import "LBMyBusinessListViewController.h"

#import "GLNearbyViewController.h"
#import "GLMerchat_StoreController.h"
#import "GLMerchat_CommentController.h"
#import "LBHomeIncomeViewController.h"
#import "GLShoppingCartController.h"

@interface BasetabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation BasetabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.delegate=self;
    [self addViewControllers];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(refreshInterface) name:@"refreshInterface" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(exitLogin) name:@"exitLogin" object:nil];
    
}
//完善资料退出跳转登录
-(void)exitLogin{
        
        GLLoginController *loginVC = [[GLLoginController alloc] init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)addViewControllers {

    //米劵商城
    LBIntegralMallViewController *IntegralMallvc = [[LBIntegralMallViewController alloc] init];
    BaseNavigationViewController *IntegralMallnav = [[BaseNavigationViewController alloc] initWithRootViewController:IntegralMallvc];
    IntegralMallvc.tabBarItem = [self barTitle:@"米券商城" image:@"public_welfare_consumption_normal" selectImage:@"public_welfare_consumption_select"];
    
    //我的
    LBMineViewController *minevc = [[LBMineViewController alloc] init];
    BaseNavigationViewController *minenav = [[BaseNavigationViewController alloc] initWithRootViewController:minevc];
    minevc.tabBarItem = [self barTitle:@"我的" image:@"wd_icon" selectImage:@"wd_selected_icon"];
    
    //搜附近
    GLNearbyViewController *nearbyVC = [[GLNearbyViewController alloc] init];
    BaseNavigationViewController *nearbyNav = [[BaseNavigationViewController alloc] initWithRootViewController:nearbyVC];
    nearbyNav.tabBarItem = [self barTitle:@"逛逛" image:@"sfj_icon" selectImage:@"sfj_selected_icon"];
    
    //搜附近
    GLShoppingCartController *ShoppingVC = [[GLShoppingCartController alloc] init];
    BaseNavigationViewController *ShoppingNav = [[BaseNavigationViewController alloc] initWithRootViewController:ShoppingVC];
    ShoppingNav.tabBarItem = [self barTitle:@"购物车" image:@"购物车未点中" selectImage:@"购物车点中"];
    
    
    self.viewControllers = @[IntegralMallnav,nearbyNav,ShoppingNav, minenav];
    
    self.selectedIndex=0;
    
}

- (UITabBarItem *)barTitle:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    UITabBarItem *item = [[UITabBarItem alloc] init];
    
    item.title = title;
    item.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : TABBARTITLE_COLOR} forState:UIControlStateSelected];
    item.titlePositionAdjustment = UIOffsetMake(0, -4);
    return item;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:3] || viewController == [tabBarController.viewControllers objectAtIndex:2]) {
       
        if ([UserModel defaultUser].loginstatus == YES) {
//实名认证
            
//            if (![[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
//                if ([[UserModel defaultUser].rzstatus isEqualToString:@"0"] || [[UserModel defaultUser].rzstatus isEqualToString:@"3"]) {
//                    
//                    LBImprovePersonalDataViewController *infoVC = [[LBImprovePersonalDataViewController alloc] init];
//                    infoVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                    [self presentViewController:infoVC animated:YES completion:nil];
//                    return NO;
//                }
//            }
            
            return YES;
        }
        GLLoginController *loginVC = [[GLLoginController alloc] init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
        
    }
    
    return YES;
}
//刷新界面
-(void)refreshInterface{
    
    [self.viewControllers reverseObjectEnumerator];
    
    [self addViewControllers];

}

- (void)pushToHome{
    
     self.selectedIndex = 0;
}

@end
