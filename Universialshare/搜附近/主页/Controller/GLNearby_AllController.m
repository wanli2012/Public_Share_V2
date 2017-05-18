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
#import "GLNearbyViewController.h"
#import "GLNearby_MerchatListController.h"

#import "GLNearby_NearShopModel.h"

@interface GLNearby_AllController ()
{
    LoadWaitView *_loadV;
}

@end

static NSString *ID = @"GLNearby_classifyCell";


@implementation GLNearby_AllController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];

}
- (void)postRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"lng"] = @104.0841100000;
    dict[@"lat"] = @30.6568320000;
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];

    [NetworkManager requestPOSTWithURLStr:@"shop/serachNearMain" paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
                for (NSDictionary *dic  in responseObject[@"data"]) {
                    
                }
                
            }
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.description];
    }];
    
}
- (UIViewController *)viewController {
    for (UIView *view = self.view; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[GLNearbyViewController class]]) {
            return (GLNearbyViewController *)nextResponder;
        }
    }
    return nil;
}
- (void)more:(NSInteger )index {
    
    self.viewController.hidesBottomBarWhenPushed = YES;
    GLNearby_MerchatListController *merchatVC = [[GLNearby_MerchatListController alloc] init];
    if (index == 0) {
        
    }else{
  
    }
    [self.viewController.navigationController pushViewController:merchatVC animated:YES];
    self.viewController.hidesBottomBarWhenPushed = NO;
    
}
#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 8;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLNearby_classifyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = 0;
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        return 110 *autoSizeScaleY;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    
    self.hidesBottomBarWhenPushed = NO;
}


@end
