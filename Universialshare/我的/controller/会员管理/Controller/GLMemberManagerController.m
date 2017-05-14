//
//  GLMemberManagerController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMemberManagerController.h"
#import "GLMemberManagerCell.h"
#import "GLConsumerRecordController.h"

@interface GLMemberManagerController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (nonatomic, strong)NSMutableArray *models;
@end

static NSString *ID = @"GLMemberManagerCell";
@implementation GLMemberManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员管理";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMemberManagerCell" bundle:nil] forCellReuseIdentifier:ID];

    self.contentViewWidth.constant = SCREEN_WIDTH;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)typeChoose:(UIButton *)sender {
    if (sender == self.leftBtn) {
        [self.leftBtn setTitleColor:YYSRGBColor(26, 183, 58, 1) forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.models removeLastObject];
    }else{
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:YYSRGBColor(26, 183, 58, 1) forState:UIControlStateNormal];
        [self.models addObject:@"d"];
    }
    [self.tableView reloadData];
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMemberManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = 0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    GLConsumerRecordController *consumerVC = [[GLConsumerRecordController alloc] init];
    [self.navigationController pushViewController:consumerVC animated:YES];
}
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        for (int i = 0; i < 3; i ++) {
            [_models addObject:[NSString stringWithFormat:@"这是第%d个",i]];
        }
    }
    return _models;
}
@end
