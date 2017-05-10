//
//  LBMineCenterWantToSignUpViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/9.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterWantToSignUpViewController.h"

@interface LBMineCenterWantToSignUpViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameft;

@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UIButton *submitBt;

@end

@implementation LBMineCenterWantToSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"我要报名";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
- (IBAction)tapgestureProvince:(UITapGestureRecognizer *)sender {
}

- (IBAction)tapgestureCity:(UITapGestureRecognizer *)sender {
}
- (IBAction)tapgestureArea:(UITapGestureRecognizer *)sender {
}

- (IBAction)tapgestureAgenceLevel:(UITapGestureRecognizer *)sender {
}

- (IBAction)submitEvent:(UIButton *)sender {
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.nameft && [string isEqualToString:@"\n"]) {
        [self.phonetf becomeFirstResponder];
        return NO;
    }
    return YES;

}

-(void)updateViewConstraints{

    [super updateViewConstraints];
    self.submitBt.layer.cornerRadius = 4;
    self.submitBt.clipsToBounds =YES;

}
@end
