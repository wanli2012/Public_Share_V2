//
//  GLAddStoreController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLAddStoreController.h"
#import "LBMineCenterChooseAreaViewController.h"
#import "editorMaskPresentationController.h"
#import "LBBaiduMapViewController.h"

@interface GLAddStoreController ()<UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
     BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;
@property (weak, nonatomic) IBOutlet UITextField *licenseTF;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *legalPersonNameTF;
@property (weak, nonatomic) IBOutlet UITextField *legalPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *ensurePwdTF;

@property (weak, nonatomic) IBOutlet UIImageView *IDImageV;
@property (weak, nonatomic) IBOutlet UIImageView *IDImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV3;

@property (weak, nonatomic) IBOutlet UIImageView *licenseImageV;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (strong, nonatomic)NSString *adressID;
@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

//地图
@property (nonatomic, copy)NSString *latStr;
@property (nonatomic, copy)NSString *longStr;

@end

@implementation GLAddStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新增门店";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    
//    self.nameView.layer.cornerRadius = 5.f;
//    self.nameView.layer.borderWidth = 1;
//    self.nameView.layer.borderColor = YYSRGBColor(184, 184, 185, 0.3).CGColor;
//    self.nameView.clipsToBounds = YES;
//    
//    self.addressView.layer.cornerRadius = 5.f;
//    self.addressView.layer.borderWidth = 1;
//    self.addressView.layer.borderColor = YYSRGBColor(184, 184, 185, 0.3).CGColor;
//    self.addressView.clipsToBounds = YES;
//    
//    self.phoneView.layer.cornerRadius = 5.f;
//    self.phoneView.layer.borderWidth = 1;
//    self.phoneView.layer.borderColor = YYSRGBColor(184, 184, 185, 0.3).CGColor;
//    self.phoneView.clipsToBounds = YES;
//    
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.clipsToBounds = YES;
    
    self.contentViewWidth.constant = SCREEN_WIDTH;
//    self.contentViewHeight.constant = 1110;

}
- (IBAction)uploadPic:(UITapGestureRecognizer *)sender {
    NSLog(@"上传图片");
}

//提交
- (IBAction)submit:(id)sender {
    
    if (self.phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }

    if (self.codeTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    if (self.shopNameTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入店名"];
        return;
    }
    
    if (self.legalPhoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }
    if (self.cityLabel.text.length <=0 ) {
        [MBProgressHUD showError:@"请选择省市区"];
        return;
    }
    if (self.mapAddressLabel.text.length <=0 ) {
        [MBProgressHUD showError:@"请地图选址"];
        return;
    }
    if (self.legalPersonNameTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入法人姓名"];
        return;
    }
    if (self.legalPhoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入法人号码"];
        return;
    }
    if (self.passwordTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if (self.ensurePwdTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请确认密码"];
        return;
    }

    
    NSLog(@"提交");
}

//省市区选择
- (IBAction)locationChoose:(id)sender {
    
    LBMineCenterChooseAreaViewController *vc=[[LBMineCenterChooseAreaViewController alloc]init];
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
    __weak typeof(self) weakself = self;
    vc.returnreslut = ^(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid){
        weakself.adressID = strid;
        weakself.cityLabel.text = str;
        weakself.provinceStrId = provinceid;
        weakself.cityStrId = cityd;
        weakself.countryStrId = areaid;
    };
}
- (IBAction)mapAddressChoose:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBBaiduMapViewController *mapVC = [[LBBaiduMapViewController alloc] init];
    mapVC.returePositon = ^(NSString *strposition,NSString *pro,NSString *city,NSString *area,CLLocationCoordinate2D coors){
        //        self.adress = strposition;
        //        self.sprovince = pro;
        //        self.scity =city;
        //        self.saera = area;
        self.latStr = [NSString stringWithFormat:@"%f",coors.latitude];
        self.longStr = [NSString stringWithFormat:@"%f",coors.longitude];
        self.mapAddressLabel.text = [NSString stringWithFormat:@"%@",strposition];
    };
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (IBAction)pictureProcessing:(UITapGestureRecognizer *)sender {
    NSLog(@"图片点击了");
    if (sender.view == self.IDImageV) {
        
    }else if(sender.view == self.IDImageV2){
        
    }else if(sender.view == self.signImageV){
        
    }else if(sender.view == self.picImageV){
        
    }else if(sender.view == self.picImageV2){
        
    }else if(sender.view == self.picImageV3){
        
    }else if(sender.view == self.licenseImageV){
        
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTF && [string isEqualToString:@"\n"]) {
        [self.codeTF becomeFirstResponder];
        return NO;
    }else if (textField == self.codeTF && [string isEqualToString:@"\n"]) {
        [self.shopNameTF becomeFirstResponder];
        return NO;
    }else if (textField == self.shopNameTF && [string isEqualToString:@"\n"]) {
        [self.licenseTF becomeFirstResponder];
        return NO;
        
    }else if (textField == self.licenseTF && [string isEqualToString:@"\n"]){
        [self.detailAddressTF becomeFirstResponder];
        return NO;
    }
    else if (textField == self.detailAddressTF && [string isEqualToString:@"\n"]){
        [self.legalPersonNameTF becomeFirstResponder];
        return NO;
    }else if (textField == self.legalPersonNameTF && [string isEqualToString:@"\n"]){
        
        [self.legalPhoneTF becomeFirstResponder];
        return NO;
    }else if (textField == self.legalPhoneTF && [string isEqualToString:@"\n"]){
        
       [self.passwordTF becomeFirstResponder];
        return NO;
    }else if (textField == self.passwordTF && [string isEqualToString:@"\n"]){
        
        [self.ensurePwdTF becomeFirstResponder];
        return NO;
    }else if (textField == self.ensurePwdTF && [string isEqualToString:@"\n"]){
        
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[editorMaskPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}

//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _ishidecotr=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _ishidecotr=NO;
    return self;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
    
}
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (_ishidecotr==YES) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame=CGRectMake(-SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
        toView.layer.cornerRadius = 6;
        toView.clipsToBounds = YES;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20 + SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [toView removeFromSuperview];
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            }
            
        }];
        
    }
    
}

@end
