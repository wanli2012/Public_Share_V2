//
//  GLConsumerRecordController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLConsumerRecordController.h"
#import "GLConsumerRecordCell.h"

@interface GLConsumerRecordController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;

@end

static NSString *ID = @"GLConsumerRecordCell";
@implementation GLConsumerRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消费记录";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLConsumerRecordCell" bundle:nil] forCellReuseIdentifier:ID];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLConsumerRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = 0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
