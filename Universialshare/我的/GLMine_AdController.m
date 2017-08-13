//
//  GLMine_AdController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_AdController.h"

@interface GLMine_AdController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GLMine_AdController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSURL *url = [NSURL URLWithString:self.url];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
    [self.webView loadRequest:request];//加载
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


@end
