//
//  GLIncomeManagerController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIncomeManagerController.h"
#import "GLIncomeManagerCell.h"
#import "GLIncomeManagerModel.h"

@interface GLIncomeManagerController ()<UITableViewDelegate,UITableViewDataSource>
{
    GLIncomeManagerModel *_model;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *ID = @"GLIncomeManagerCell";
@implementation GLIncomeManagerController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.tableView.estimatedRowHeight = 64;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLIncomeManagerCell" bundle:nil] forCellReuseIdentifier:ID];
    _model = [[GLIncomeManagerModel alloc] init];
    _model.name = @"你哈也的你大爷街中百大道天府三街中百街中百大道天府三街中百街中百大道天府三街中百街中百大道天府三街中百街中百大道天府三街中百街中百大道天府三街中百也的你大";
    _model.address = @"天府三街中百大道天府三街中百街中百大道天府三街中百街中百大道天府三街中百街中百大道天府三街中百";

    [self.tableView reloadData];
}

#pragma UITableviewDelegate UITableviewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLIncomeManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.nameLabel.text = _model.name;
    cell.addressLabel.text = _model.address;
    return cell;
}
@end
