//
//  GLRecommendStroe_RecordController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendStroe_RecordController.h"
#import "GLRecommendStore_RecordCell.h"

@interface GLRecommendStroe_RecordController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *ID = @"GLRecommendStore_RecordCell";
@implementation GLRecommendStroe_RecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLRecommendStore_RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = 0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
//    GLRecommendStore_RecordCell *consumerVC = [[GLRecommendStore_RecordCell alloc] init];
//    [self.navigationController pushViewController:consumerVC animated:YES];
}

@end
