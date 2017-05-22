//
//  GLStoreProductCommentController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLStoreProductCommentController.h"
//#import "GLStoreProductCommentCell.h"
#import "LBStoreDetailreplaysTableViewCell.h"

@interface GLStoreProductCommentController ()
@property (nonatomic, strong)NSMutableArray *models;
@end

static NSString *ID = @"LBStoreDetailreplaysTableViewCell";
@implementation GLStoreProductCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    
}
- (void)comment{
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.estimatedRowHeight = 22;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    return self.tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LBStoreDetailreplaysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.delegate = self;
  
//    cell.model = self.models[indexPath.row];
    
   //        cell.starView.progress = [self.dataDic[@"com_data"][indexPath.row][@"mark"] integerValue];
//        cell.nameLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"user_name"]];
//        cell.contentLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"comment"]];
//        cell.timeLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"addtime"]];
//        [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"pic"]]] placeholderImage:[UIImage imageNamed:@"熊"] options:SDWebImageAllowInvalidSSLCertificates];
    
        return cell;

}

//- (NSMutableArray *)models{
//    if (!_models) {
//        _models = [NSMutableArray array];
//        
//        for (int i = 0; i < 8; i++) {
//            LBStoreDetailreplaysTableViewCell *model = [[GLStoreProductCommentModel alloc] init];
//            if (i < 4) {
//                model.index = 1;
//                model.reply = @"";
//            }else{
//                model.index = 2;
//                model.reply = @"对方是否舒服撒打发十多个发生嘎嘎嘎方是否舒服撒打发十多个发生嘎方是否舒服撒打发十多个发生嘎方是否舒服撒打发十多个发生嘎方是否舒服撒打发十多个发生嘎方是否舒服撒打发十多个发生嘎";
//            }
//            [_models addObject:model];
//        }
//    }
//    return _models;
//}

@end
