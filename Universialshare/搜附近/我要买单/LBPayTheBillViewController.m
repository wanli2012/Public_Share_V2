//
//  LBPayTheBillViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/19.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBPayTheBillViewController.h"
#import "CommonMenuView.h"
#import "UIView+AdjustFrame.h"
#import "UIView+TYAlertView.h"

@interface LBPayTheBillViewController ()<UITextFieldDelegate>
{
    NSArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UIView *baseview;
@property (weak, nonatomic) IBOutlet UIButton *surebt;
@property (weak, nonatomic) IBOutlet UITextField *moneytf;
@property (weak, nonatomic) IBOutlet UITextField *methodTf;
@property (weak, nonatomic) IBOutlet UITextField *modelTf;
@property (weak, nonatomic) IBOutlet UITextField *infoTf;

@end

@implementation LBPayTheBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"支付";
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (IBAction)tapgestureMethod:(UITapGestureRecognizer *)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"请选择支付方式"];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"微信支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
          self.methodTf.text = action.title;
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"支付宝支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
          self.methodTf.text = action.title;
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"米子支付" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
           self.methodTf.text = action.title;
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {

    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (IBAction)tapgesturemodel:(UITapGestureRecognizer *)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"温馨提示" message:@"请选择奖金模式"];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"5%" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        self.modelTf.text = action.title;

    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"10%" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
          self.modelTf.text = action.title;
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"20%" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
          self.modelTf.text = action.title;
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
  
        
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
    
   
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.infoTf && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }
    return YES;

}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.surebt.layer.cornerRadius = 4;
    self.surebt.clipsToBounds = YES;
    
    self.baseview.layer.cornerRadius = 4;
    self.baseview.clipsToBounds = YES;

    self.contentH.constant = 510;
    self.contentW.constant = SCREEN_WIDTH;

}
@end
