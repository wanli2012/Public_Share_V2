//
//  GLMerchat_StoreController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_StoreController.h"
#import "GLMerchat_StoreCell.h"
#import "GLAddStoreController.h"


@interface GLMerchat_StoreController ()<GLMerchat_StoreCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *addStoreBtn;

@end

static NSString *ID = @"GLMerchat_StoreCell";
@implementation GLMerchat_StoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)addStore:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLAddStoreController *addVC = [[GLAddStoreController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
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
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.estimatedRowHeight = 64;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
    
}

#pragma GLMerchat_StoreCellDelegate

- (void)cellClick:(NSInteger)index indexPath:(NSIndexPath *)indexPath{
    if (index == 1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"暂停营业" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                    UITextField *login = alertController.textFields.firstObject;
//                    UITextField *password = alertController.textFields.lastObject;
           NSLog(@"暂停营业");
        
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入密码";
            textField.secureTextEntry = YES;
        }];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //                    UITextField *login = alertController.textFields.firstObject;
            //                    UITextField *password = alertController.textFields.lastObject;
            NSLog(@"修改密码");
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入原密码";
            textField.secureTextEntry = YES;
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入新密码";
            textField.secureTextEntry = YES;
        }];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

@end
