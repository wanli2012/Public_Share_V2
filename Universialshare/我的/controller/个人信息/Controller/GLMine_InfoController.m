//
//  GLMine_InfoController.m
//  PovertyAlleviation
//
//  Created by gonglei on 17/2/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_InfoController.h"
#import "GLMine_InfoCell.h"
#import "LBBaiduMapViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LBReplaceImagesview.h"

@interface GLMine_InfoController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_titlesArr;
    NSMutableArray *_valuesArr;
    NSString *_address;
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageV;
@property (weak, nonatomic) IBOutlet UILabel *userStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;

@property (strong, nonatomic)UIImage *imagehead;//头像
@property (strong, nonatomic)NSString *username;//用户明
@property (strong, nonatomic)NSString *adress;//店铺地址
@property (strong, nonatomic)NSString *storeType;//商家类型
@property (strong, nonatomic)NSString *shenfCode;//身份证号
@property (strong, nonatomic)NSString *ID;//用户ID
@property (strong, nonatomic)NSString *recomendID;//推荐人ID
@property (strong, nonatomic)NSString *recomendName;//推荐姓名
@property (strong, nonatomic)NSString *shop_phone;//联系人电话号码

@property (strong, nonatomic)NSString *sprovince;//省
@property (strong, nonatomic)NSString *scity;//市
@property (strong, nonatomic)NSString *saera;//区

@property (strong, nonatomic)UIButton *buttonedt;
@property (assign, nonatomic)BOOL EditBool;//判断是否可编辑
@property (strong, nonatomic)UIPickerView *pickerView;
@property (strong, nonatomic)UIView *pickerViewMask;
@property (strong, nonatomic)NSArray *usertypeArr;
@property (strong, nonatomic)LoadWaitView *loadV;

@property (weak, nonatomic) IBOutlet UIButton *doorImageBt;
@property (strong, nonatomic)LBReplaceImagesview *replaceImagesview;
@property (strong, nonatomic)UIView *maskView;
@property (assign, nonatomic)NSInteger  selectimageIndex;

@end

static NSString *ID = @"GLMine_InfoCell";

@implementation GLMine_InfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"个人资料";
    _EditBool = NO;
    [self logoQrCode];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_InfoCell" bundle:nil] forCellReuseIdentifier:ID];
    
    _buttonedt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
    [_buttonedt setTitle:@"编辑" forState:UIControlStateNormal];
    [_buttonedt setTitle:@"保存" forState:UIControlStateSelected];
    [_buttonedt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _buttonedt.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonedt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonedt addTarget:self action:@selector(edtingInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];
    
    [self updateInfo];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)updateInfo{
    
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer] && [[UserModel defaultUser].AudiThrough isEqualToString:@"1"]) {
        
        _titlesArr = @[@"头像",@"用户名",@"ID",@"店铺地址",@"商家类型",@"证件号",@"推荐人ID",@"推荐人姓名",@"联系电话"];
        
    }else if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser] || [[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        
        _titlesArr = @[@"头像",@"用户名",@"ID",@"证件号",@"推荐人ID",@"推荐人姓名",@"联系电话"];
    }
    
    
    self.ID = [UserModel defaultUser].name;
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].headPic]];
    
    self.imagehead =imageV.image;
    self.username = [UserModel defaultUser].truename;
    self.adress = [UserModel defaultUser].shop_address;
    self.storeType = [UserModel defaultUser].shop_type;
    self.shenfCode = [UserModel defaultUser].idcard;
    self.recomendID = [UserModel defaultUser].tjr;
    self.recomendName = [UserModel defaultUser].tjrname;
    self.shop_phone = [UserModel defaultUser].shop_phone;
    
}
//编辑按钮
-(void)edtingInfo:(UIButton*)sender{
    sender.selected = !sender.selected;
    _EditBool = !_EditBool;
    [self.view endEditing:YES];
    
    if (sender.selected) {
        
        
    }else{//保存
    
        
        
        NSDictionary *dic;
        
        if ((!self.imagehead  || [UIImagePNGRepresentation(self.imagehead) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"mine_head"])]) && [self.username isEqualToString:[UserModel defaultUser].truename] && [self.adress isEqualToString:[UserModel defaultUser].shop_address] && [self.storeType isEqualToString:[UserModel defaultUser].shop_type] && [self.shenfCode isEqualToString:[UserModel defaultUser].idcard] && [self.recomendID isEqualToString:[UserModel defaultUser].tjr] && [self.recomendName isEqualToString:[UserModel defaultUser].tjrname]&& [self.shop_phone isEqualToString:[UserModel defaultUser].shop_phone]) {
            
            [MBProgressHUD showError:@"未做任何修改"];
            return;
            
        }
        
        if (self.shenfCode.length > 0) {
            if (![predicateModel validateIdentityCard:self.shenfCode]) {
                [MBProgressHUD showError:@"身份证格式不对"];
                return;
            }
        }
        
        if (self.shop_phone.length <= 0 ) {
            [MBProgressHUD showError:@"请输入联系电话"];
            return;
        }
        
        if (![predicateModel valiMobile:self.shop_phone]) {
            [MBProgressHUD showError:@"电话格式错误"];
            return;
        }

        
        if (self.sprovince == nil) {
            self.sprovince = @"";
        }
        if (self.scity == nil) {
            self.scity = @"";
        }
        if (self.saera == nil) {
            self.saera = @"";
        }
        if (self.adress == nil) {
            self.adress = @"";
        }
        if (self.username == nil) {
            self.username = @"";
        }
        if (self.shenfCode == nil) {
            self.shenfCode = @"";
        }
        if (self.storeType == nil) {
            self.storeType = @"";
        }if (self.shop_phone == nil) {
            self.storeType = @"";
        }
       
        dic=@{@"token":[UserModel defaultUser].token , @"uid":[UserModel defaultUser].uid , @"sprovince":self.sprovince , @"scity":self.scity,@"saera":self.saera,@"saddress":self.adress,@"truename":self.username,@"idcard":self.shenfCode,@"shop_type":self.storeType,@"shop_phone":self.shop_phone};

        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        manager.requestSerializer.timeoutInterval = 10;
        // 加上这行代码，https ssl 验证。
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
        [manager POST:[NSString stringWithFormat:@"%@user/userAndShopInfoBq",URL_Base] parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //将图片以表单形式上传
            
            if (self.imagehead) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
                NSData *data = UIImagePNGRepresentation(self.imagehead);
                [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/png"];
            }
            
        }progress:^(NSProgress *uploadProgress){
            
        }success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"code"]integerValue]==1) {
                
                [MBProgressHUD showError:dic[@"message"]];
                
            }else{
                [MBProgressHUD showError:dic[@"message"]];
            }
            [_loadV removeloadview];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
        }];
    
    }
    
    [self.tableView reloadData];

}

//MARK: 二维码中间内置图片,可以是公司logo
-(void)logoQrCode{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSData *qrImageData = [[UserModel defaultUser].name dataUsingEncoding:NSUTF8StringEncoding];
 
    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];
    
    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];
    
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    //转成 UI的 类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    
    
    //再把小图片画上去
    UIImage *sImage = [UIImage imageNamed:@""];
    
    CGFloat sImageW = 100;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();

    //设置图片
    self.codeImageV.image = finalyImage;
}
//添加地址
- (void)addAddress {
//    self.hidesBottomBarWhenPushed = YES;
//    LBBaiduMapViewController *mapVC = [[LBBaiduMapViewController alloc] init];
//    
//    mapVC.returePositon = ^(NSString *strposition,NSString *pro,NSString *city,NSString *area,CLLocationCoordinate2D coors){
//        [UserModel defaultUser].address = strposition;
//        if ([[UserModel defaultUser].userLogin integerValue] == 1) {
//            [_valuesArr replaceObjectAtIndex:4 withObject:[UserModel defaultUser].address];
//        }else if ([[UserModel defaultUser].userLogin integerValue] == 29){
//            [_valuesArr replaceObjectAtIndex:3 withObject:[UserModel defaultUser].address];
//        }
//        [usermodelachivar achive];
//        [self.tableView reloadData];
//    };
//    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titlesArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_InfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_titlesArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer] && [[UserModel defaultUser].AudiThrough isEqualToString:@"1"]) {//零售商
        
        if (indexPath.row == 0) {
            cell.headimage.hidden = NO;
            cell.imageW.constant = 30;
            cell.textTf.enabled = NO;
            cell.textTf.hidden = YES;
            cell.headimage.image = self.imagehead;
            if (!cell.headimage.image) {
                cell.headimage.image = [UIImage imageNamed:@"dtx_icon"];
            }
            
        }else{
            cell.headimage.hidden = YES;
            cell.imageW.constant = 0;
            
            if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 4 || indexPath.row == 1 || indexPath.row == 5) {
                cell.textTf.enabled = NO;
            }else{
                if (_EditBool == NO) {
                    cell.textTf.enabled = NO;
                }else{
                    cell.textTf.enabled = YES;
                }

            }
            //设置初始值
            if (indexPath.row == 1) {
                cell.textTf.hidden = NO;
                cell.adressLb.hidden= YES;
                cell.textTf.text = self.username;
            }else if (indexPath.row == 2){
                cell.textTf.hidden = NO;
                cell.adressLb.hidden= YES;
                cell.textTf.text = self.ID;
            }else if (indexPath.row == 3){
                cell.textTf.hidden = YES;
                cell.adressLb.hidden= NO;
                cell.adressLb.text = self.adress;
            }else if (indexPath.row == 4){
                cell.textTf.hidden = NO;
                cell.adressLb.hidden= YES;
                cell.textTf.text = self.storeType;
            }else if (indexPath.row == 5){
                cell.textTf.hidden = NO;
                cell.adressLb.hidden= YES;
                cell.textTf.text = self.shenfCode;
            }else if (indexPath.row == 6){
                cell.textTf.hidden = NO;
                cell.adressLb.hidden= YES;
                cell.textTf.text = self.recomendID;
            }else if (indexPath.row == 7){
                cell.textTf.hidden = NO;
                cell.adressLb.hidden= YES;
                cell.textTf.text = self.recomendName;
            }else if (indexPath.row == 8){
                cell.textTf.hidden = NO;
                cell.adressLb.hidden= YES;
                cell.textTf.text = self.shop_phone;
            }
            
            
            __weak typeof(self) weakself = self;
            //编辑赋值
            cell.returnEditing = ^(NSString *content , NSInteger index){
                
                if (index == 1) {
                    weakself.username = content;
                }else if (index == 3){
                    
                    self.adress = content;
                    
                }else if (index == 4){
                    
                    self.storeType = content;
                    
                }else if (index == 5){
                    
                    self.shenfCode = content;
                    
                }else if (index == 8){
                    
                    self.shop_phone = content;
                    
                }
                
            };
            
            //弹出键盘
            cell.returnkeyBoard = ^(NSInteger index){
                
                if (index == 1) {
                    NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:5 inSection:0];
                    GLMine_InfoCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                    [cell.textTf becomeFirstResponder];
                }else if (index == 5){
                    
                   [weakself.view endEditing:YES];
                }
            };
            
            
        }
        
    }else if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser] || [[UserModel defaultUser].usrtype isEqualToString:Retailer]) {//普通用户
        
        if (indexPath.row == 0) {
            cell.headimage.hidden = NO;
            cell.imageW.constant = 30;
            cell.textTf.enabled = NO;
            cell.textTf.hidden = YES;
            cell.headimage.image = self.imagehead;
            if (!cell.headimage.image) {
                cell.headimage.image = [UIImage imageNamed:@"dtx_icon"];
            }
            
        }else{
            cell.headimage.hidden = YES;
            cell.imageW.constant = 0;
            
            if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 1 || indexPath.row == 3) {
                cell.textTf.enabled = NO;
            }else{
                if (_EditBool == NO) {
                    cell.textTf.enabled = NO;
                }else{
                    cell.textTf.enabled = YES;
                }
            }
            
        }
        
        //设置初始值
        if (indexPath.row == 1) {
            cell.textTf.text = self.username;
        }else if (indexPath.row == 2){
            cell.textTf.text = self.ID;
        }else if (indexPath.row == 3){
            cell.textTf.text = self.shenfCode;
        }else if (indexPath.row == 4){
            cell.textTf.text = self.recomendID;
        }else if (indexPath.row == 5){
            cell.textTf.text = self.recomendName;
        }else if (indexPath.row == 6){
            cell.textTf.text = self.shop_phone;
        }
        
        
        __weak typeof(self) weakself = self;
        // 赋值
        cell.returnEditing = ^(NSString *content , NSInteger index){
        
            if (index == 1) {
                weakself.username = content;
            }else if (index == 3){
            
                self.shenfCode = content;
            
            }else if (index == 6){
                
                self.shop_phone = content;
                
            }
        
        };
        
        //弹出键盘
        cell.returnkeyBoard = ^(NSInteger index){

            if (index == 1) {
                NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:3 inSection:0];
                GLMine_InfoCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                [cell.textTf becomeFirstResponder];
            }else if (index == 3){
                
                [weakself.view endEditing:YES];
            }
            
        };

    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if (_EditBool == YES) {
            self.selectimageIndex = 1;
            UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
            [actionSheet showInView:self.view];
        }
    }

    
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        
        if (_EditBool == YES) {
            if (indexPath.row == 3) {//选择地址
                self.hidesBottomBarWhenPushed = YES;
                LBBaiduMapViewController *mapVC = [[LBBaiduMapViewController alloc] init];
                mapVC.returePositon = ^(NSString *strposition,NSString *pro,NSString *city,NSString *area,CLLocationCoordinate2D coors){
                    self.adress = strposition;
                    self.sprovince = pro;
                    self.scity =city;
                    self.saera = area;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:mapVC animated:YES];
            }else if (indexPath.row == 4){
            
                [self.view addSubview:self.pickerViewMask];
                [self.pickerViewMask addSubview:self.pickerView];
            
            }
        }
        
    }else if ([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]) {
        
        
    }

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
        
        if (self.selectimageIndex == 1) {
            self.imagehead = [UIImage imageWithData:data];
            [self.tableView reloadData];
        }
        if (self.selectimageIndex == 2) {
            self.replaceImagesview.imageone.image = [UIImage imageWithData:data];
        }
        if (self.selectimageIndex == 3) {
            self.replaceImagesview.imagetwo.image = [UIImage imageWithData:data];
        }
        if (self.selectimageIndex == 4) {
            self.replaceImagesview.imagethree.image = [UIImage imageWithData:data];
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.usertypeArr.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    
    return SCREEN_WIDTH -20;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 50;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    self.storeType = self.usertypeArr[row];
    [self.tableView reloadData];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   
    return self.usertypeArr[row];
}

////重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -20 , 50)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//点击pickerViewMask
-(void)tapgestureMask{

    [self.pickerView removeFromSuperview];
    [self.pickerViewMask removeFromSuperview];


}
//修改门店照
- (IBAction)repalceDoorImage:(UIButton *)sender {
    
    [self.view addSubview:self.maskView];
    [self.maskView addSubview:self.replaceImagesview];
    self.replaceImagesview.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        self.replaceImagesview.transform=CGAffineTransformMakeScale(1, 1);
    }];
    
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.doorImageBt.layer.cornerRadius = 4;
    self.doorImageBt.clipsToBounds = YES;

}


-(UIPickerView*)pickerView{

    if (!_pickerView) {
        _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 150, SCREEN_WIDTH - 20, 150)];
        _pickerView.dataSource=self;
        _pickerView.delegate=self;
        _pickerView.backgroundColor=[UIColor whiteColor];
    }
    return _pickerView;

}

-(UIView*)pickerViewMask{

    if (!_pickerViewMask) {
        _pickerViewMask=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _pickerViewMask.backgroundColor= YYSRGBColor(0, 0, 0, 0.2);
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureMask)];
        [_pickerViewMask addGestureRecognizer:tap];
    }

    return _pickerViewMask;
}



-(NSArray*)usertypeArr{
    if (!_usertypeArr) {
        _usertypeArr=[NSArray arrayWithObjects:@"制造业",@"服务业", nil];
    }
    return _usertypeArr;
}

- (LBReplaceImagesview *)replaceImagesview{
    if (!_replaceImagesview) {
        _replaceImagesview = [[NSBundle mainBundle] loadNibNamed:@"LBReplaceImagesview" owner:nil options:nil].lastObject;
        
        _replaceImagesview.layer.cornerRadius = 5.f;
        _replaceImagesview.clipsToBounds = YES;
        
        _replaceImagesview.frame = CGRectMake(20, (SCREEN_HEIGHT - ((SCREEN_WIDTH - 80)/3 + 85))/2, SCREEN_WIDTH - 40, (SCREEN_WIDTH - 80)/3 + 85);
        
        [_replaceImagesview.cancelBt addTarget:self action:@selector(maskViewTap) forControlEvents:UIControlEventTouchUpInside];
        
        [_replaceImagesview.sureBt addTarget:self action:@selector(addQtIDandOilCardID) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *gestureone=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectonimageone)];
        [_replaceImagesview.imageone addGestureRecognizer:gestureone];
        
        UITapGestureRecognizer *gesturetwo=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectonimagetwo)];
        [_replaceImagesview.imagetwo addGestureRecognizer:gesturetwo];
        
        UITapGestureRecognizer *gesturethree=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectonimagethree)];
        [_replaceImagesview.imagethree addGestureRecognizer:gesturethree];

    }
    return _replaceImagesview;
}

-(UIView*)maskView{
    
    if (!_maskView) {
        _maskView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
        
    }
    return _maskView;
    
}
//取消
-(void)maskViewTap{

    [UIView animateWithDuration:0.3 animations:^{
        self.replaceImagesview.transform=CGAffineTransformMakeScale(0.1, 0.00001);
        
    } completion:^(BOOL finished) {
        
        [self.maskView removeFromSuperview];
    }];

}
//确定
-(void)addQtIDandOilCardID{
    
    if ([UIImagePNGRepresentation(self.replaceImagesview.imageone.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝-12"])] ||[UIImagePNGRepresentation(self.replaceImagesview.imagetwo.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"照片框-拷贝-13"])]  ||     [UIImagePNGRepresentation(self.replaceImagesview.imagethree.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"内景2-拷贝"])]) {
        [MBProgressHUD showError:@"请上传店3张铺环境照"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    NSMutableArray *imageViewArr = [NSMutableArray arrayWithObjects:self.replaceImagesview.imageone,self.replaceImagesview.imagetwo,self.replaceImagesview.imagethree,nil];
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"store_one",@"store_two",@"store_three", nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@user/setStorePic",URL_Base] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        //        NSLog(@"dict = %@",dict);
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
            self.replaceImagesview.sureBt.userInteractionEnabled = YES;
        }
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"]integerValue]==1) {
            
            [MBProgressHUD showError:dic[@"message"]];
            [self maskViewTap];
        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
        [_loadV removeloadview];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.replaceImagesview.sureBt.userInteractionEnabled = YES;
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

    

}
//门店照
-(void)selectonimageone{
    self.selectimageIndex = 2;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];

}

-(void)selectonimagetwo{
    self.selectimageIndex = 3;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
}

-(void)selectonimagethree{
    self.selectimageIndex = 4;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];

}



@end
