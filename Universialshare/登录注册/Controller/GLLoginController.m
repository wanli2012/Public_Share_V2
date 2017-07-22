
//  GLLoginController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/5.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLLoginController.h"
#import "GLRegisterController.h"
#import "BasetabbarViewController.h"
#import "LoginIdentityView.h"
#import "LBHomeLoginFortgetSecretViewController.h"
#import "LBViewProtocolViewController.h"

@interface GLLoginController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *scretTf;

@property (strong, nonatomic)LoginIdentityView *loginView;
@property (strong, nonatomic)UIImageView *currentloginViewimage;//当前选择身份的选中图

@property (strong, nonatomic)UIView *maskView;
@property (strong, nonatomic)NSString *usertype;//用户类型 默认为善行者
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bgView.layer.cornerRadius = 5;
//    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.bgView.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.bgView.layer.shadowRadius = 5;//阴影半径，默认3
    
    [self.loginView.cancelBt addTarget:self action:@selector(maskviewgesture) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.sureBt addTarget:self action:@selector(surebuttonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *maskvgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskviewgesture)];
    [self.maskView addGestureRecognizer:maskvgesture];
    //选择米家
    UITapGestureRecognizer *shanVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shangViewgesture)];
    [self.loginView.shangView addGestureRecognizer:shanVgesture];
    //选择米商
    UITapGestureRecognizer *lingVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lingViewgesture)];
    [self.loginView.lingView addGestureRecognizer:lingVgesture];
    //选择一级业务员
    UITapGestureRecognizer *OneVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneSalerViewgesture)];
    [self.loginView.oneView addGestureRecognizer:OneVgesture];
    //选择二级业务员
    UITapGestureRecognizer *TwoVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoSalerViewgesture)];
    [self.loginView.twoView addGestureRecognizer:TwoVgesture];
    //选择三级业务员
    UITapGestureRecognizer *ThreeVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(threeSalerViewgesture)];
    [self.loginView.threeView addGestureRecognizer:ThreeVgesture];
    
    self.currentloginViewimage = self.loginView.shangImage;
    
//    CAGradientLayer *layer = [CAGradientLayer new];
//    //colors存放渐变的颜色的数组
//    layer.colors=@[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)TABBARTITLE_COLOR.CGColor,(__bridge id)[UIColor whiteColor].CGColor];
//    layer.startPoint = CGPointMake(0.5, 0);
//    layer.endPoint = CGPointMake(0.5, 1);
//    layer.frame = self.loginBtn.bounds;
//    [self.loginBtn.layer addSublayer:layer];
//    
//    CAGradientLayer *layera = [CAGradientLayer new];
//    //colors存放渐变的颜色的数组
//    layera.colors=@[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)YYSRGBColor(198, 51, 14, 1).CGColor,(__bridge id)[UIColor whiteColor].CGColor];
//    layera.startPoint = CGPointMake(0.5, 0);
//    layera.endPoint = CGPointMake(0.5, 1);
//    layera.frame = self.registerBtn.bounds;
//    [self.registerBtn.layer addSublayer:layera];
    
    if ([UserModel defaultUser].phone != nil && [[UserModel defaultUser].phone length] > 0) {
        self.phone.text = [UserModel defaultUser].phone;
    }

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.usertype = OrdinaryUser;

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}
//注册
- (IBAction)registerClick:(id)sender {
    [self.view endEditing:YES];
    GLRegisterController *registerVC = [[GLRegisterController alloc] init];
//    registerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:registerVC animated:YES completion:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//登录
- (IBAction)login:(id)sender {
    
    [self.view endEditing:YES];
    if (self.phone.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码或ID"];
        return;
    }
    
    if (self.scretTf.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    if (self.scretTf.text.length < 6 || self.scretTf.text.length > 20) {
        [MBProgressHUD showError:@"请输入6-20位密码"];
        return;
    }
    
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.loginView];
    self.loginView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.loginView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    
}
//隐藏或显示图片
- (IBAction)showOrHide:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.scretTf setSecureTextEntry:NO];
        [sender setImage:[UIImage imageNamed:@"隐藏"] forState:UIControlStateNormal];
        
    }else{
        [self.scretTf setSecureTextEntry:YES];
        [sender setImage:[UIImage imageNamed:@"显示"] forState:UIControlStateNormal];
    }
}
//退出
- (IBAction)exitLoginEvent:(UIButton *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
//忘记密码
- (IBAction)forgetButtonEvent:(UIButton *)sender {

    LBHomeLoginFortgetSecretViewController *vc=[[LBHomeLoginFortgetSecretViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
//使用说明
- (IBAction)useInfoamtion:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBViewProtocolViewController *vc=[[LBViewProtocolViewController alloc]init];
    vc.webUrl = COMMONPROBLE;
    vc.navTitle = @"常见问题";
    [self.navigationController pushViewController:vc animated:YES];
    
}


//确定按
-(void)surebuttonEvent{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
 
     NSString *encryptsecret = [RSAEncryptor encryptString:self.scretTf.text publicKey:public_RSA];

    [NetworkManager requestPOSTWithURLStr:@"user/login" paramDic:@{@"userphone":self.phone.text,@"password":encryptsecret,@"groupID":self.usertype} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
            [UserModel defaultUser].banknumber = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"banknumber"]];
            [UserModel defaultUser].counta = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"count"]];
            [UserModel defaultUser].giveMeMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"giveMeMark"]];
            [UserModel defaultUser].groupId = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"groupId"]];
            [UserModel defaultUser].headPic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"headPic"]];
            [UserModel defaultUser].ketiBean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"ketiBean"]];
            [UserModel defaultUser].lastFanLiTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lastFanLiTime"]];
            [UserModel defaultUser].lastTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lastTime"]];
            [UserModel defaultUser].loveNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"loveNum"]];
            [UserModel defaultUser].mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mark"]];
            [UserModel defaultUser].name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"name"]];
            [UserModel defaultUser].phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]];
            [UserModel defaultUser].recommendMark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"recommendMark"]];
            [UserModel defaultUser].regTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"regTime"]];
            [UserModel defaultUser].token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
            [UserModel defaultUser].uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
            [UserModel defaultUser].version = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"version"]];
            [UserModel defaultUser].vsnAddress = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"vsnAddress"]];
            [UserModel defaultUser].vsnUpdateTime = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"vsnUpdateTime"]];
            [UserModel defaultUser].djs_bean = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"djs_bean"]];
        
            [UserModel defaultUser].idcard = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"idcard"]];
            [UserModel defaultUser].truename = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"truename"]];
            [UserModel defaultUser].tjr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"tjr"]];
            [UserModel defaultUser].tjrname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"tjrname"]];
            
            [UserModel defaultUser].rzstatus = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"rzstatus"]];
            [UserModel defaultUser].loginstatus = YES;
            [UserModel defaultUser].usrtype = self.usertype;
            [UserModel defaultUser].AudiThrough = @"0";
            
            [UserModel defaultUser].t_one = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_one"]];
            [UserModel defaultUser].t_two = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_two"]];
            [UserModel defaultUser].t_three = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"t_three"]];
            
            if ([[UserModel defaultUser].banknumber rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].banknumber = @"";
            }
            if ([[UserModel defaultUser].counta rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].counta = @"";
            }
            if ([[UserModel defaultUser].giveMeMark rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].giveMeMark = @"";
            }
            if ([[UserModel defaultUser].tjr rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].tjr = @"";
            }
            if ([[UserModel defaultUser].tjrname rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].tjrname = @"";
            }
            
            if ([[UserModel defaultUser].truename rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].truename = @"";
            }
            
            if ([[UserModel defaultUser].idcard rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].idcard = @"";
            }
            
            if ([self.usertype isEqualToString:Retailer]) {//零售商
                [UserModel defaultUser].shop_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_name"]];
                [UserModel defaultUser].shop_address = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_address"]];
                [UserModel defaultUser].shop_type = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shop_type"]];
                [UserModel defaultUser].is_main = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_main"]];
                
                [UserModel defaultUser].allLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"allLimit"]];
                [UserModel defaultUser].isapplication = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"isapplication"]];
                [UserModel defaultUser].surplusLimit = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"surplusLimit"]];
                
                if ([[UserModel defaultUser].shop_name rangeOfString:@"null"].location != NSNotFound) {
                    
                    [UserModel defaultUser].shop_name = @"";
                }
                if ([[UserModel defaultUser].shop_address rangeOfString:@"null"].location != NSNotFound) {
                    
                    [UserModel defaultUser].shop_address = @"";
                }
                if ([[UserModel defaultUser].shop_type rangeOfString:@"null"].location != NSNotFound) {
                    
                    [UserModel defaultUser].shop_type = @"";
                }
            }else{//普通用户
                [UserModel defaultUser].shop_name = @"";
                [UserModel defaultUser].shop_address = @"";
                [UserModel defaultUser].shop_type = @"";
                [UserModel defaultUser].is_main = @"";

            }
            
            [usermodelachivar achive];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

//普通用户
-(void)shangViewgesture{
    
    self.usertype = OrdinaryUser;
    if (self.currentloginViewimage == self.loginView.shangImage) {
        return;
    }
    self.loginView.shangImage.image=[UIImage imageNamed:@"登录选中"];
    self.currentloginViewimage.image=[UIImage imageNamed:@"登录未选中"];
    self.currentloginViewimage = self.loginView.shangImage;
}
//零售商
-(void)lingViewgesture{
    
    self.usertype = Retailer;
    if (self.currentloginViewimage == self.loginView.lingimage) {
        return;
    }
    self.loginView.lingimage.image=[UIImage imageNamed:@"登录选中"];
    self.currentloginViewimage.image=[UIImage imageNamed:@"登录未选中"];
    self.currentloginViewimage = self.loginView.lingimage;
    
}
//一级业务员
-(void)oneSalerViewgesture{

    self.usertype = ONESALER;
    if (self.currentloginViewimage == self.loginView.oneImage) {
        return;
    }
    self.loginView.oneImage.image=[UIImage imageNamed:@"登录选中"];
    self.currentloginViewimage.image=[UIImage imageNamed:@"登录未选中"];
    self.currentloginViewimage = self.loginView.oneImage;

}
//二级业务员
-(void)twoSalerViewgesture{
    
    self.usertype = TWOSALER;
    if (self.currentloginViewimage == self.loginView.twoImage) {
        return;
    }
    self.loginView.twoImage.image=[UIImage imageNamed:@"登录选中"];
    self.currentloginViewimage.image=[UIImage imageNamed:@"登录未选中"];
    self.currentloginViewimage = self.loginView.twoImage;
    
}
//三级业务员
-(void)threeSalerViewgesture{
    
    self.usertype = THREESALER;
    if (self.currentloginViewimage == self.loginView.threeImage) {
        return;
    }
    self.loginView.threeImage.image=[UIImage imageNamed:@"登录选中"];
    self.currentloginViewimage.image=[UIImage imageNamed:@"登录未选中"];
    self.currentloginViewimage = self.loginView.threeImage;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phone && [string isEqualToString:@"\n"]) {
        [self.scretTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.scretTf && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.phone ) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    return YES;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
    
}

//点击maskview
-(void)maskviewgesture{
    
    [self.maskView removeFromSuperview];
    [self.loginView removeFromSuperview];
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.clipsToBounds = YES;
    self.registerBtn.layer.cornerRadius = 4;
    self.registerBtn.clipsToBounds = YES;
    
    self.loginView.sureBt.layer.cornerRadius = 4;
    self.loginView.sureBt.clipsToBounds = YES;
    self.loginView.cancelBt.layer.cornerRadius = 4;
    self.loginView.cancelBt.clipsToBounds = YES;


}

-(LoginIdentityView*)loginView{
    
    if (!_loginView) {
        _loginView=[[NSBundle mainBundle]loadNibNamed:@"LoginIdentityView" owner:self options:nil].firstObject;
        _loginView.frame=CGRectMake(20, (SCREEN_HEIGHT - 240)/2, SCREEN_WIDTH-40, 240);
        _loginView.alpha=1;
        
    }
    
    return _loginView;
    
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0f]];
        
    }
    return _maskView;
    
}

@end
