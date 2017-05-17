//
//  GLRecommendStoreController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendStoreController.h"
#import "GLRecommendStroe_RecordController.h"

@interface GLRecommendStoreController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@end

@implementation GLRecommendStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我要推店";
    
    self.firstView.layer.cornerRadius = 5.f;
    self.secondView.layer.cornerRadius = 5.f;
    self.thirdView.layer.cornerRadius = 5.f;
 
    self.ensureBtn.layer.cornerRadius = 5.f;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 44);
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [rightBtn setTitle:@"推荐记录" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [rightBtn addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = 600;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)record {
    self.hidesBottomBarWhenPushed = YES;
    GLRecommendStroe_RecordController *record = [[GLRecommendStroe_RecordController alloc] init];
    [self.navigationController pushViewController:record animated:YES];
}
- (IBAction)typeChoose:(id)sender {
    NSLog(@"类型选择");
}

- (IBAction)ensure:(id)sender {
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.nameTF && [string isEqualToString:@"\n"]) {
        [self.addressTF becomeFirstResponder];
        return NO;
    }else if (textField == self.addressTF && [string isEqualToString:@"\n"]) {
        [self.phoneNumTF becomeFirstResponder];
        return NO;
    }
    
    
    return YES;
    
}
@end
