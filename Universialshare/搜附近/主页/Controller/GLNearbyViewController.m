//
//  GLNearbyViewController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearbyViewController.h"
#import "GLCityChooseController.h"
#import "GLNearby_ClassifyHeaderView.h"
#import "GLNearby_classifyCell.h"
#import "GLNearby_SectionHeaderView.h"
#import "GLNearby_RecommendMerchatCell.h"

@interface GLNearbyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cityChooseBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *eatBtn;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@property (nonatomic, strong)UIView *indicatorV;
@end

static NSString *ID = @"GLNearby_classifyCell";
static NSString *ID2 = @"GLNearby_RecommendMerchatCell";
@implementation GLNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchView.layer.cornerRadius = 5.f;
    self.searchView.clipsToBounds = YES;

    GLNearby_ClassifyHeaderView *headerV = [[GLNearby_ClassifyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    self.tableView.tableHeaderView = headerV;
    
    headerV.block = ^(NSString *typeID){
        NSLog(@"typeID = %@",typeID);
    };
    
    
    
    [self classifyChoose:self.eatBtn];
    [self setIndicator];
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView registerNib:[UINib nibWithNibName:ID2 bundle:nil] forCellReuseIdentifier:ID2];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

//指示器 (类型下面的小条)
- (void)setIndicator {
    
}
//选择分类
- (IBAction)classifyChoose:(UIButton *)sender {
    [self.eatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.liveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    if (sender == self.eatBtn) {
        NSLog(@"美食");
//        self.indicatorV.frame = CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }else if (sender == self.liveBtn){
        NSLog(@"酒店");
    }else if(sender == self.playBtn){
        NSLog(@"娱乐");
    }else{
        NSLog(@"全部");
    }
}
//城市选择
- (IBAction)cityChoose:(id)sender {
    GLCityChooseController *cityVC = [[GLCityChooseController alloc] init];
    __weak typeof(self) weakSelf = self;
    cityVC.block = ^(NSString *city){
        [weakSelf.cityChooseBtn setTitle:city forState:UIControlStateNormal];
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)more:(id)sender {
    NSLog(@"查看更多");
}
#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GLNearby_SectionHeaderView *headV = [[NSBundle mainBundle] loadNibNamed:@"GLNearby_SectionHeaderView" owner:nil options:nil].lastObject;

    if (section == 0) {
        headV.titleLabel.text = @"推荐商家";
        [headV.moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        headV.titleLabel.text = @"附近商家";
        [headV.moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return headV;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GLNearby_RecommendMerchatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        cell.selectionStyle = 0;
        return cell;
    }else{
        
        GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = 0;
        return cell;
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120 *autoSizeScaleY;
    }else{
        
        return 110 *autoSizeScaleY;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    
    self.hidesBottomBarWhenPushed = NO;
}

- (UIView *)indicatorV{
    if (!_indicatorV) {
        _indicatorV = [[UIView alloc] init];
    }
    return _indicatorV;
}

@end
