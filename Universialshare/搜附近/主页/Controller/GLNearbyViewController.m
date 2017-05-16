//
//  GLNearbyViewController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.

#import "GLNearbyViewController.h"
#import "SlideTabBarView.h"


@interface GLNearbyViewController ()

@end

@implementation GLNearbyViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    SlideTabBarView *slide = [[SlideTabBarView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) WithCount:4];
    [self.view addSubview:slide];

}




@end
