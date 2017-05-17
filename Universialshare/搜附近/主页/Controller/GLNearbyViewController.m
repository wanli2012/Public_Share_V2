//
//  GLNearbyViewController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.

#import "GLNearbyViewController.h"
#import "SlideTabBarView.h"
#import "GLCityChooseController.h"

@interface GLNearbyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;

@end

@implementation GLNearbyViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.searchView.layer.cornerRadius = 5.f;
    self.searchView.clipsToBounds = YES;
    SlideTabBarView *slide = [[SlideTabBarView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64) WithCount:4];
    [self.view addSubview:slide];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)cityChoose:(id)sender {
    GLCityChooseController *cityVC = [[GLCityChooseController alloc] init];
    __weak typeof(self) weakSelf = self;
    cityVC.block = ^(NSString *city){
        [weakSelf.cityBtn setTitle:city forState:UIControlStateNormal];
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


@end
