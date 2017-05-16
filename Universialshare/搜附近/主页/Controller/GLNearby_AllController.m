//
//  GLNearby_AllController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_AllController.h"
#import "GLNearby_ClassifyHeaderView.h"
#import "GLNearby_classifyCell.h"
#import "GLNearby_SectionHeaderView.h"
#import "GLNearby_RecommendMerchatCell.h"

@interface GLNearby_AllController ()


@end

static NSString *ID = @"GLNearby_classifyCell";
static NSString *ID2 = @"GLNearby_RecommendMerchatCell";
@implementation GLNearby_AllController

- (void)viewDidLoad {
    [super viewDidLoad];

    GLNearby_ClassifyHeaderView *headerV = [[GLNearby_ClassifyHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    self.tableView.tableHeaderView = headerV;
    
    __weak typeof(self) weakSelf = self;
    
//    headerV.block = ^(NSString *typeID,CGFloat height){
//        NSLog(@"typeID = %@",typeID);
//        if (height != 0) {
//            weakSelf.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
//        }
//    };
    
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [self.tableView registerNib:[UINib nibWithNibName:ID2 bundle:nil] forCellReuseIdentifier:ID2];
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


@end
