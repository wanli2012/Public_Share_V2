//
//  GLMerchat_StoreController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_StoreController.h"
#import "GLMerchat_StoreCell.h"


@interface GLMerchat_StoreController ()<GLMerchat_StoreCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *addStoreBtn;

@end

static NSString *ID = @"GLMerchat_StoreCell";
@implementation GLMerchat_StoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchView.layer.cornerRadius = self.searchView.yy_height/2;
    self.searchView.clipsToBounds = YES;
    
    self.addStoreBtn.layer.cornerRadius = 5.f;
    self.searchView.clipsToBounds = YES;
    
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addStore:(id)sender {
}
#pragma UITableviewDelegate UITableviewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMerchat_StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
//
//    //    cell.nameLabel.text = _model.name;
//    //    cell.addressLabel.text = _model.address;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.estimatedRowHeight = 64;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
    
}

#pragma GLMerchat_StoreCellDelegate

- (void)cellClick:(NSInteger)index{
    if (index == 1) {
        
    }else{
        
    }
}

@end
