//
//  LBBelowTheLineViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBelowTheLineViewController.h"
#import "IncentiveModel.h"
#import "LBBelowTheLineListViewController.h"
#import "SelectUserTypeView.h"

@interface LBBelowTheLineViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet UIView *baseView1;
@property (weak, nonatomic) IBOutlet UIView *baseView2;
@property (weak, nonatomic) IBOutlet UIView *baseview3;
@property (weak, nonatomic) IBOutlet UIView *baseView4;
@property (weak, nonatomic) IBOutlet UIView *baseView5;
@property (weak, nonatomic) IBOutlet UIView *baseView6;
@property (weak, nonatomic) IBOutlet UIView *baseView7;
@property (weak, nonatomic) IBOutlet UIButton *codeBt;
@property (weak, nonatomic) IBOutlet UIButton *comitbt;

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *modeltf;
@property (weak, nonatomic) IBOutlet UITextField *moneyTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *numTf;
@property (weak, nonatomic) IBOutlet UITextField *yuliuTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *getNewCode;


@property (strong, nonatomic)IncentiveModel *incentiveModelV;
@property (strong, nonatomic)UIView *incentiveModelMaskV;
@property (nonatomic, assign) NSInteger userytpe; // 让利类型 1 20% 2 10% 3 5%

@property (nonatomic, assign) NSInteger documentType; // 1为打款凭证，2为消费凭证
@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UIImageView *TriangleImage;

@property (strong, nonatomic)NSString *phoneNum;//保存电话号码

@property (nonatomic, strong)SelectUserTypeView *selectUserTypeView;
@property (strong, nonatomic)NSString *usertype;
@property (weak, nonatomic) IBOutlet UITextField *usertypeTf;
@property (weak, nonatomic) IBOutlet UIView *userTypeView;

@end

@implementation LBBelowTheLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"线下下单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.phoneNum = @"";
    UITapGestureRecognizer *incentiveModelMaskVgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(incentiveModelMaskVtapgestureLb)];
    [self.incentiveModelMaskV addGestureRecognizer:incentiveModelMaskVgesture];
    
    NSString  *stringRandom =  [[NSUserDefaults standardUserDefaults]objectForKey:@"randomNumber"];
    
    if (stringRandom == nil || [stringRandom isEqualToString:@""]) {

        NSString *randomNumber = [self getRandomStringWithNum:4];
        
        self.yuliuTf.text = randomNumber;
        
        [[NSUserDefaults standardUserDefaults] setObject:randomNumber forKey:@"randomNumber"];//保存
    }else{
        
        self.yuliuTf.text = stringRandom;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"记录"] style:UIBarButtonItemStylePlain target:self action:@selector(checkrecorderEvent)];
    item.imageInsets = UIEdgeInsetsMake(5, -5, 0, 5);
    self.navigationItem.rightBarButtonItem = item;
    
 
}

-(void)checkrecorderEvent{
    
    self.hidesBottomBarWhenPushed = YES;
    LBBelowTheLineListViewController *vc = [[LBBelowTheLineListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

//帐户类型选择
- (IBAction)accountTypeChoose:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    self.selectUserTypeView.block = ^(NSInteger index){
        
        switch (index) {
            case 0://会员
            {
                weakSelf.usertype = OrdinaryUser;
                weakSelf.usertypeTf.text=@"会员";
            }
                break;
            case 1://商家
            {
                weakSelf.usertype = Retailer;
                weakSelf.usertypeTf.text=@"商家";
            }
                break;
            case 2://创客
            {
                weakSelf.usertype = THREESALER;
                weakSelf.usertypeTf.text=@"创客";
            }
                break;
            case 3://城市创客
            {
                weakSelf.usertype = TWOSALER;
                weakSelf.usertypeTf.text=@"城市创客";
            }
                break;
            case 4://大区创客
            {
                weakSelf.usertype = ONESALER;
                weakSelf.usertypeTf.text=@"大区创客";
            }
                break;
            case 5://省级服务中心
            {
                weakSelf.usertype = PROVINCE;
                weakSelf.usertypeTf.text=@"省级服务中心";
            }
                break;
            case 6://市级服务中心
            {
                weakSelf.usertype = CITY;
                weakSelf.usertypeTf.text=@"市级服务中心";
            }
                break;
            case 7://区级服务中心
            {
                weakSelf.usertype = DISTRICT;
                weakSelf.usertypeTf.text=@"区级服务中心";
            }
                break;
            case 8://省级行业服务中心
            {
                weakSelf.usertype = PROVINCE_INDUSTRY;
                weakSelf.usertypeTf.text=@"省级行业服务中心";
            }
                break;
            case 9://市级行业服务中心
            {
                weakSelf.usertype = CITY_INDUSTRY;
                weakSelf.usertypeTf.text=@"市级行业服务中心";
            }
                break;
                
            default:
                break;
        }
        
        [weakSelf incentiveModelMaskVtapgestureLb];
        
    };
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.usertypeTf convertRect:self.usertypeTf.bounds toView:window];

    self.selectUserTypeView.frame = CGRectMake(rect.origin.x, rect.origin.y + 45, rect.size.width, 180);

//    self.selectUserTypeView.height = 0;
    self.selectUserTypeView.transform = CGAffineTransformMakeScale(1.0, 0);
    self.selectUserTypeView.layer.anchorPoint=CGPointMake(0.5, 0);
    [self.view addSubview:self.incentiveModelMaskV];
    [self.view addSubview:self.selectUserTypeView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.selectUserTypeView.height = 180;
        
    } completion:^(BOOL finished) {
        
    }];

}


//重新生成生成预留信息
- (IBAction)getNewCodeEvent:(UIButton *)sender {

    NSString *randomNumber = [self getRandomStringWithNum:4];
    
    self.yuliuTf.text = randomNumber;
    
}

- (NSString *)getRandomStringWithNum:(NSInteger)num
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 62;
        if (number < 10) {
            
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
            
        }else if(number < 36 && number >10) {
            
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
            
        }else{
            
            int figure = (arc4random() % 26) + 65;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

//选择激励模式
- (IBAction)choseJiliModel:(UITapGestureRecognizer *)sender {
   

    self.TriangleImage.transform = CGAffineTransformMakeRotation(M_PI);

    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.baseView2 convertRect: self.baseView2.bounds toView:window];
    
    self.incentiveModelV.frame=CGRectMake(SCREEN_WIDTH-130, rect.origin.y+20, 120, 150);
    
    [self.view addSubview:self.incentiveModelMaskV];
    [self.incentiveModelMaskV addSubview:self.incentiveModelV];
}
//打款凭证
- (IBAction)choseimageone:(UITapGestureRecognizer *)sender {
    self.documentType = 1;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
}
//消费凭证
- (IBAction)choseimageTwo:(UITapGestureRecognizer *)sender {
    self.documentType = 2;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
}


//获取验证码
- (IBAction)getcodeEvent:(UIButton *)sender {
    if (self.phoneTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入会员电话号码或ID"];
        return;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"user/getTrueName" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"username" :self.phoneTf.text} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            self.phoneNum = responseObject[@"data"][@"phone"];
            [self startTime];//获取倒计时
            [NetworkManager requestPOSTWithURLStr:@"user/get_yzm" paramDic:@{@"phone":self.phoneNum} finish:^(id responseObject) {
                if ([responseObject[@"code"] integerValue]==1) {
                    
                }else{
                    
                }
            } enError:^(NSError *error) {
                
            }];
 
        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
            
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}
//提交
- (IBAction)submitInfoEvent:(UIButton *)sender {
    
    if (self.phoneTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写购买会员"];
        return;
    }
    if (self.modeltf.text.length <= 0) {
        [MBProgressHUD showError:@"请选择奖励模式"];
        return;
    }
    if (self.moneyTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写消费金额"];
        return;
    }else{
        if ([self.moneyTf.text hasPrefix:@"."] || [self.moneyTf.text hasSuffix:@"."]) {
            [MBProgressHUD showError:@"消费金额格式错误"];
            return;
        }
    }
    
    if (self.nameTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写商品名称"];
        return;
    }
    if (self.numTf.text.length <= 0) {
        [MBProgressHUD showError:@"请填写商品数量"];
        return;
    }
    if (self.codeTf.text.length <= 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    
    if (!self.imageOne.image || [UIImagePNGRepresentation(self.imageOne.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"imcc_record_bg"])]) {
        [MBProgressHUD showError:@"请上传打款凭证"];
        return;
    }
    if (!self.imageTwo.image || [UIImagePNGRepresentation(self.imageTwo.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"imcc_record_bg"])]) {
        [MBProgressHUD showError:@"请上传消费凭证"];
        return;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"user/getTrueName" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"username" :self.phoneTf.text,@"group_id" :self.usertype} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                NSString *str=[NSString stringWithFormat:@"确定向%@下单吗?",responseObject[@"data"][@"truename"]];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
            
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        NSDictionary  * dic=@{@"token":[UserModel defaultUser].token , @"uid":[UserModel defaultUser].uid , @"username":self.phoneTf.text , @"yzm":self.codeTf.text,@"rlmodel_type":[NSNumber numberWithInteger:self.userytpe],@"money":self.moneyTf.text,@"shopname":self.nameTf.text,@"shopnum":self.numTf.text,@"code":self.yuliuTf.text,@"version":@"3",@"group_id" :self.usertype};
        self.comitbt.userInteractionEnabled = NO;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        manager.requestSerializer.timeoutInterval = 20;
        // 加上这行代码，https ssl 验证。
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
        [manager POST:[NSString stringWithFormat:@"%@user/placeOrderLine",URL_Base] parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //将图片以表单形式上传
            
            if (self.imageOne.image) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@one.png",str];
                NSData *data = UIImagePNGRepresentation(self.imageOne.image);
                [formData appendPartWithFileData:data name:@"dkpz" fileName:fileName mimeType:@"image/png"];
            }
            if (self.imageTwo.image) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@two.png",str];
                NSData *data = UIImagePNGRepresentation(self.imageTwo.image);
                [formData appendPartWithFileData:data name:@"xfpz" fileName:fileName mimeType:@"image/png"];
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
                [self.navigationController popViewControllerAnimated:YES];
                 [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"randomNumber"];//清除
                
            }else{
                [MBProgressHUD showError:dic[@"message"]];
            }
           self.comitbt.userInteractionEnabled = YES;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            self.comitbt.userInteractionEnabled = YES;
            [MBProgressHUD showError:error.localizedDescription];
        }];
                
    }
    
}
//结束编辑
- (IBAction)endeditEvent:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
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
            
            data = UIImageJPEGRepresentation(image, 0.1);
        }else {
            data=    UIImageJPEGRepresentation(image, 0.1);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        if (self.documentType == 1) {
            self.imageOne.image = [UIImage imageWithData:data];
        }else if (self.documentType == 2){
            self.imageTwo.image = [UIImage imageWithData:data];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneTf && [string isEqualToString:@"\n"]) {
        [self.moneyTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.moneyTf && [string isEqualToString:@"\n"]){
        
        [self.nameTf becomeFirstResponder];
        return NO;
    }else if (textField == self.nameTf && [string isEqualToString:@"\n"]){
        
        [self.numTf becomeFirstResponder];
        return NO;
    }else if (textField == self.numTf && [string isEqualToString:@"\n"]){
        
        [self.codeTf becomeFirstResponder];
        return NO;
    }else if (textField == self.codeTf && [string isEqualToString:@"\n"]) {
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.phoneTf) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    return YES;
    
}


#pragma mark - 点击激励模式选择
-(void)threeButtonE{
    self.userytpe = [KThreePersent integerValue];
    self.modeltf.text = @"3%奖励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}

-(void)sixbuttonE{
    self.userytpe=3;
    self.modeltf.text=@"5%奖励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}
-(void)twenteenButtonE{
    self.userytpe=2;
    self.modeltf.text=@"10%奖励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}
-(void)twentyFbuttonE{
    self.userytpe=1;
    self.modeltf.text=@"20%奖励模式";
    [self incentiveModelMaskVtapgestureLb];
    
}
//点击maskview
-(void)incentiveModelMaskVtapgestureLb{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
//        self.selectUserTypeView.transform=CGAffineTransformMakeScale(1.0, 0.00001);
        self.selectUserTypeView.height = 0;
    } completion:^(BOOL finished) {
        
        [self.incentiveModelMaskV removeFromSuperview];
        [self.selectUserTypeView removeFromSuperview];
    }];
    
//    [self.incentiveModelMaskV removeFromSuperview];
    [self.incentiveModelV removeFromSuperview];
    self.TriangleImage.transform = CGAffineTransformIdentity;
    
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.baseView1.layer.cornerRadius = 4;
    self.baseView1.clipsToBounds = YES;
    self.baseView2.layer.cornerRadius = 4;
    self.baseView2.clipsToBounds = YES;
    self.baseview3.layer.cornerRadius = 4;
    self.baseview3.clipsToBounds = YES;
    self.baseView4.layer.cornerRadius = 4;
    self.baseView4.clipsToBounds = YES;
    self.baseView5.layer.cornerRadius = 4;
    self.baseView5.clipsToBounds = YES;
    self.baseView6.layer.cornerRadius = 4;
    self.baseView6.clipsToBounds = YES;
    self.baseView7.layer.cornerRadius = 4;
    self.baseView7.clipsToBounds = YES;

    self.codeBt.layer.cornerRadius = 4;
    self.codeBt.clipsToBounds = YES;
    self.comitbt.layer.cornerRadius = 4;
    self.comitbt.clipsToBounds = YES;
    self.getNewCode.layer.cornerRadius = 4;
    self.getNewCode.clipsToBounds = YES;
    
    self.contentW.constant = SCREEN_WIDTH;
    self.contentH.constant = 650;

}

-(IncentiveModel*)incentiveModelV{
    
    if (!_incentiveModelV) {
        _incentiveModelV=[[NSBundle mainBundle]loadNibNamed:@"IncentiveModel" owner:self options:nil].firstObject;
        [_incentiveModelV.threeButton addTarget:self action:@selector(threeButtonE) forControlEvents:UIControlEventTouchUpInside];
        [_incentiveModelV.sixButton addTarget:self action:@selector(sixbuttonE) forControlEvents:UIControlEventTouchUpInside];
        [_incentiveModelV.twenteenButton addTarget:self action:@selector(twenteenButtonE) forControlEvents:UIControlEventTouchUpInside];
        [_incentiveModelV.twentyFBt addTarget:self action:@selector(twentyFbuttonE) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return _incentiveModelV;
    
}
-(UIView*)incentiveModelMaskV{
    
    if (!_incentiveModelMaskV) {
        _incentiveModelMaskV=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _incentiveModelMaskV.backgroundColor=[UIColor clearColor];
    }
    
    return _incentiveModelMaskV;
    
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
                [self.codeBt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.codeBt.userInteractionEnabled = YES;
                self.codeBt.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                self.codeBt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.codeBt.userInteractionEnabled = NO;
                self.codeBt.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.codeBt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

-(SelectUserTypeView*)selectUserTypeView{
    
    if (!_selectUserTypeView) {
        _selectUserTypeView=[[NSBundle mainBundle]loadNibNamed:@"SelectUserTypeView" owner:self options:nil].firstObject;
        
        _selectUserTypeView.layer.cornerRadius = 10.f;
        _selectUserTypeView.clipsToBounds = YES;

        _selectUserTypeView.dataSoure  = @[@"会员",@"商家",@"创客",@"城市创客",@"大区创客",@"省级服务中心",@"市级服务中心",@"区级服务中心",@"省级行业服务中心",@"市级行业服务中心"];

    }
    
    return _selectUserTypeView;
    
}
@end
