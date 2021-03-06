//
//  LBRecommendedSalesmanViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBRecommendedSalesmanViewController.h"
#import "SelectionOfSalesmanLevelView.h"
#import "LBAddrecomdManChooseAreaViewController.h"
#import "editorMaskPresentationController.h"

@interface LBRecommendedSalesmanViewController ()<UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UITextField *yanzTf;
@property (weak, nonatomic) IBOutlet UIButton *yanzBt;
@property (weak, nonatomic) IBOutlet UITextField *levelTf;
@property (weak, nonatomic) IBOutlet UITextField *proviceTf;
@property (weak, nonatomic) IBOutlet UITextField *cityTf;
@property (weak, nonatomic) IBOutlet UITextField *areaTf;
@property (weak, nonatomic) IBOutlet UITextField *secrestTf;
@property (weak, nonatomic) IBOutlet UIButton *nextBt;
//@property (weak, nonatomic) IBOutlet UITextField *idenfyCode;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *trueNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *ensurePwdTF;

@property (weak, nonatomic) IBOutlet UIView *levelView;
@property (strong, nonatomic)UIView *incentiveModelMaskV;
@property (strong, nonatomic)NSString *levelStr;//推广员等级
@property (strong, nonatomic)SelectionOfSalesmanLevelView *incentiveModelV;
@property (strong, nonatomic)LoadWaitView *loadV;

@property (nonatomic, strong)NSMutableArray *provinceArr;
@property (nonatomic, strong)NSMutableArray *cityArr;
@property (nonatomic, strong)NSMutableArray *countryArr;
@property (nonatomic, assign)NSInteger ischosePro;//记录选择省的第几行
@property (nonatomic, assign)NSInteger ischoseCity;//记录选择市的第几行
@property (nonatomic, assign)NSInteger ischoseArea;//记录选择区的第几行

@property (weak, nonatomic) IBOutlet UIImageView *IDImageV;//身份证正面照
@property (weak, nonatomic) IBOutlet UIImageView *IDImageV2;//身份证反面照
@property (assign, nonatomic)NSInteger tapIndex;//判断点击的是那个图片

@end

@implementation LBRecommendedSalesmanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加创客";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getPickerData];
}

#pragma mark - get data
- (void)getPickerData {
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
     _loadV.isTap = NO;
    [NetworkManager requestPOSTWithURLStr:@"User/getCityList" paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            self.provinceArr = responseObject[@"data"];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

//选择等级
- (IBAction)chooseLevel:(UITapGestureRecognizer *)sender {
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.levelView convertRect: self.levelView.bounds toView:window];
    
    if ([[UserModel defaultUser].groupId isEqualToString:TWOSALER]) {
        self.incentiveModelV.frame=CGRectMake(SCREEN_WIDTH-130, rect.origin.y+20, 120, 60);
    }else{
        
        self.incentiveModelV.frame=CGRectMake(SCREEN_WIDTH-130, rect.origin.y+20, 120, 80);
    }
    
    [self.view addSubview:self.incentiveModelMaskV];
    [self.incentiveModelMaskV addSubview:self.incentiveModelV];
    
}
//选择省份
- (IBAction)choseProvince:(UITapGestureRecognizer *)sender {
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr;
    vc.titlestr = @"请选择省份";
    vc.returnreslut = ^(NSInteger index){
        _ischosePro = index;
        _proviceTf.text = _provinceArr[index][@"province_name"];
        _cityTf.text = @"";
        _areaTf.text = @"";
        
    };
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}
//选择城市
- (IBAction)choseCity:(UITapGestureRecognizer *)sender {
    
    if (self.proviceTf.text.length <= 0) {
        [MBProgressHUD showError:@"请选择省份"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr[_ischosePro][@"city"];
    vc.titlestr = @"请选择城市";
    vc.returnreslut = ^(NSInteger index){
        _ischoseCity = index;
        _cityTf.text = _provinceArr[_ischosePro][@"city"][index][@"city_name"];
        _areaTf.text = @"";
        
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}
//选择区域
- (IBAction)choseArea:(UITapGestureRecognizer *)sender {
    
    if (self.cityTf.text.length <= 0) {
        [MBProgressHUD showError:@"请选择城市"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    vc.provinceArr = self.provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"];
    vc.titlestr = @"请选择区域";
    vc.returnreslut = ^(NSInteger index){
        _ischoseArea = index;
        _areaTf.text = _provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"][index][@"country_name"];
        
    };
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}
//身份证图片上传
- (IBAction)uploadIDPic:(id)sender {
    _tapIndex = 1;
    [self tapgesturephotoOrCamera];
}
- (IBAction)uploadIDPicBack:(id)sender {
    _tapIndex = 2;
    [self tapgesturephotoOrCamera];
}
//选择图片来源
-(void)tapgesturephotoOrCamera{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
    
    
}
//发送验证
- (IBAction)sendCodeEvent:(UIButton *)sender {
    
    if (self.phonetf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phonetf.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:@"user/get_yzm" paramDic:@{@"phone":self.phonetf.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
        
    } enError:^(NSError *error) {
        
    }];
    
}
-(void)sixbuttonE{
    self.levelStr= TWOSALER;
    self.levelTf.text=@"城市创客";
    [self.incentiveModelMaskV removeFromSuperview];
    [self.incentiveModelV removeFromSuperview];
    
}
-(void)twenteenButtonE{
    self.levelStr = THREESALER;
    self.levelTf.text=@"创客";
    [self.incentiveModelMaskV removeFromSuperview];
    [self.incentiveModelV removeFromSuperview];
    
}
//点击maskview
-(void)incentiveModelMaskVtapgestureLb{
    
    [self.incentiveModelMaskV removeFromSuperview];
    [self.incentiveModelV removeFromSuperview];
    
}
//完成
- (IBAction)nextEvent:(UIButton *)sender {
    
    if (self.phonetf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phonetf.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
   
    if (self.yanzTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    if (self.trueNameLabel.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入真实姓名"];
        return;
    }
    
    if (self.levelTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入等级"];
        return;
    }
    
    if (self.proviceTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入省份"];
        return;
    }
    
    if (self.cityTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入城市"];
        return;
    }
    
    if (self.secrestTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if (self.secrestTf.text.length <6 || self.secrestTf.text.length > 20) {
        [MBProgressHUD showError:@"请输入6-16密码"];
        return;
    }
    if ([predicateModel checkIsHaveNumAndLetter:self.secrestTf.text] != 3) {
        
        [MBProgressHUD showError:@"密码须包含数字和字母"];
        return;
    }
    if (![self.ensurePwdTF.text isEqualToString:self.secrestTf.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    
    if (!self.IDImageV.image || [UIImagePNGRepresentation(self.IDImageV.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"样板-拷贝"])]) {
        [MBProgressHUD showError:@"请上传身份证正面照"];
        return;
    }
    
    if (!self.IDImageV2.image || [UIImagePNGRepresentation(self.IDImageV2.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝"])]) {
        [MBProgressHUD showError:@"请上传身份证反面照"];
        return;
    }

    self.nextBt.enabled = NO;
    self.nextBt.backgroundColor = [UIColor lightGrayColor];
    NSString *encryptsecret = [RSAEncryptor encryptString:self.secrestTf.text publicKey:public_RSA];
    
    NSDictionary *dic = @{@"uid":[UserModel defaultUser].uid,
                          @"token":[UserModel defaultUser].token,
                          @"group_id":[UserModel defaultUser].groupId,
                          @"phone":self.phonetf.text,
                          @"yzm":self.yanzTf.text,
                          @"grade":self.levelStr,
                          @"province":_provinceArr[_ischosePro][@"province_code"],
                          @"city":_provinceArr[_ischosePro][@"city"][_ischoseCity][@"city_code"],
                          @"country":_provinceArr[_ischosePro][@"city"][_ischoseCity][@"country"][_ischoseArea][@"country_code"],
                          @"password":encryptsecret,
                          @"truename":self.trueNameLabel.text};
    
    NSArray *imageViewArr = [NSArray arrayWithObjects:self.IDImageV,self.IDImageV2,nil];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"face_pic",@"con_pic", nil];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@User/openTjmember",URL_Base] parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传

        for (int i = 0; i < imageViewArr.count; i ++) {
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
            UIImageView *imaev = (UIImageView*)imageViewArr[i];
            NSData *data = UIImagePNGRepresentation(imaev.image);
            [formData appendPartWithFileData:data name:titleArr[i] fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){
        
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
        
        if (uploadProgress.fractionCompleted == 1.0) {
             [SVProgressHUD dismiss];
        }

    }success:^(NSURLSessionDataTask *task, id responseObject) {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([dic[@"code"]integerValue]==1) {
            
            [MBProgressHUD showError:dic[@"message"]];
          [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            self.nextBt.enabled = YES;
            
            self.nextBt.backgroundColor = TABBARTITLE_COLOR;
            
            [MBProgressHUD showError:dic[@"message"]];
            [SVProgressHUD dismiss];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [MBProgressHUD showError:error.localizedDescription];
        self.nextBt.enabled = YES;
        self.nextBt.backgroundColor = TABBARTITLE_COLOR;
    }];
 
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self getpicture];//获取相册
        }break;
            
        case 1:{
            [self getcamera];//获取照相机
        }break;
        default:
            break;
    }
}

-(void)getpicture{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //    // 设置选择后的图片可以被编辑
    //    picker.allowsEditing = YES;
    //    [self presentViewController:picker animated:YES completion:nil];
    //1.获取媒体支持格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = @[mediaTypes[0]];
    //5.其他配置
    //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
    picker.allowsEditing = YES;
    //6.推送
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)getcamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可以被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data=    UIImageJPEGRepresentation(image, 0.2);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        switch (self.tapIndex) {
            case 1:
            {
                self.IDImageV.image = [UIImage imageWithData:data];
            }
                break;
            case 2:
            {
                self.IDImageV2.image = [UIImage imageWithData:data];
            }
                break;
          
            default:
                break;
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.trueNameLabel && ![string isEqualToString:@""]) {
        
        //只能输入英文或中文
        NSString *regex = @"[a-zA-Z\u4e00-\u9fa5]+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([string isEqualToString:@""]) {
            return YES;
        }else{
            return [pred evaluateWithObject:string];
        }
    }
    
    return YES;
    
}

//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.yanzBt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.yanzBt.userInteractionEnabled = YES;
                self.yanzBt.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                self.yanzBt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.yanzBt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.yanzBt.userInteractionEnabled = NO;
                self.yanzBt.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.yanzBt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.nextBt.layer.cornerRadius = 4;
    self.nextBt.clipsToBounds = YES;
    
    self.contentW.constant = SCREEN_WIDTH;
    
    
    self.baseView.layer.cornerRadius = 4;
    self.baseView.clipsToBounds = YES;
    
    self.yanzBt.layer.cornerRadius = 4;
    self.yanzBt.clipsToBounds = YES;

}

-(UIView*)incentiveModelMaskV{
    
    if (!_incentiveModelMaskV) {
        _incentiveModelMaskV=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _incentiveModelMaskV.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *incentiveModelMaskVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(incentiveModelMaskVtapgestureLb)];
        [_incentiveModelMaskV addGestureRecognizer:incentiveModelMaskVgesture];
    }
    
    return _incentiveModelMaskV;
    
}
-(SelectionOfSalesmanLevelView*)incentiveModelV{
    
    if (!_incentiveModelV) {
        _incentiveModelV=[[NSBundle mainBundle]loadNibNamed:@"SelectionOfSalesmanLevelView" owner:self options:nil].firstObject;
        [_incentiveModelV.sixButton addTarget:self action:@selector(sixbuttonE) forControlEvents:UIControlEventTouchUpInside];
        [_incentiveModelV.twenteenButton addTarget:self action:@selector(twenteenButtonE) forControlEvents:UIControlEventTouchUpInside];
        
        if([[UserModel defaultUser].groupId isEqualToString:TWOSALER]){
            _incentiveModelV.sixButtonHeight.constant = 0;
            _incentiveModelV.sixButton.hidden = YES;
        }
//        [_incentiveModelV.twentyFBt addTarget:self action:@selector(twentyFbuttonE) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _incentiveModelV;
    
}
@end
