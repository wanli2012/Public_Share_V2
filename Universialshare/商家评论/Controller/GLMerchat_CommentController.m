//
//  GLMerchat_CommentController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/22.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_CommentController.h"
#import "GLMerchat_CommentModel.h"
#import "GLMerchat_CommentCell.h"

@interface GLMerchat_CommentController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *ID = @"GLMerchat_CommentCell";
@implementation GLMerchat_CommentController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
}
#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMerchat_CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
