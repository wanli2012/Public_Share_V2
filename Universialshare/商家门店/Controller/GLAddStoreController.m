//
//  GLAddStoreController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLAddStoreController.h"

@interface GLAddStoreController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV3;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@end

@implementation GLAddStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新增门店";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    self.nameView.layer.cornerRadius = 5.f;
    self.nameView.layer.borderWidth = 1;
    self.nameView.layer.borderColor = YYSRGBColor(184, 184, 185, 0.3).CGColor;
    self.nameView.clipsToBounds = YES;
    
    self.addressView.layer.cornerRadius = 5.f;
    self.addressView.layer.borderWidth = 1;
    self.addressView.layer.borderColor = YYSRGBColor(184, 184, 185, 0.3).CGColor;
    self.addressView.clipsToBounds = YES;
    
    self.phoneView.layer.cornerRadius = 5.f;
    self.phoneView.layer.borderWidth = 1;
    self.phoneView.layer.borderColor = YYSRGBColor(184, 184, 185, 0.3).CGColor;
    self.phoneView.clipsToBounds = YES;
    
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.clipsToBounds = YES;
    
    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = SCREEN_HEIGHT - 74;

}
- (IBAction)uploadPic:(UITapGestureRecognizer *)sender {
    NSLog(@"上传图片");
}

//提交
- (IBAction)submit:(id)sender {
    NSLog(@"提交");
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
}

@end
