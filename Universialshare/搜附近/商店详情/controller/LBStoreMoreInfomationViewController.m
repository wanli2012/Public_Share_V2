//
//  LBStoreMoreInfomationViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBStoreMoreInfomationViewController.h"
#import "MXNavigationBarManager.h"

static NSString *const kMXCellIdentifer = @"kMXCellIdentifer";
static const CGFloat headerImageHeight = 260.0f;

@interface LBStoreMoreInfomationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation LBStoreMoreInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.tableview registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kMXCellIdentifer];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerImageHeight)];
    headerImageView.image = [UIImage imageNamed:@"熊"];
    self.tableview.tableHeaderView = headerImageView;
    
    [self initBarManager];

}
- (void)initBarManager {
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:TABBARTITLE_COLOR];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
    [MXNavigationBarManager setZeroAlphaOffset:0];
    [MXNavigationBarManager setFullAlphaOffset:200];
    [MXNavigationBarManager setFullAlphaBarStyle:UIStatusBarStyleLightContent];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [MXNavigationBarManager changeAlphaWithCurrentOffset:scrollView.contentOffset.y];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MXNavigationBarManager reStoreToCustomNavigationBar:self];
    

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMXCellIdentifer forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    return cell;
}






@end
