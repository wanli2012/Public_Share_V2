//
//  LBAddMineProductionViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBAddMineProductionViewController.h"

@interface LBAddMineProductionViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViwH;

@property (weak, nonatomic) IBOutlet UIButton *submitBt;//提交
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (strong, nonatomic)NSMutableArray *imageArr;

@property (assign, nonatomic)NSInteger deleteImageIndex;//删除图片

@end

@implementation LBAddMineProductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"添加产品";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self refreshimageview];
    
}

-(void)refreshimageview{

    for (int j = 0 ; j < self.imageView.subviews.count; j++) {
        UIImageView  *imagev = [self.imageView viewWithTag:j+1];
        imagev.hidden = YES;
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureImagev:)];
        UILongPressGestureRecognizer *longgestureimagev = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longgestureimagev:)];
        [imagev addGestureRecognizer:tapgesture];
        [imagev addGestureRecognizer:longgestureimagev];
        
    }
    
    for (int i = 0 ; i < self.imageArr.count; i++) {
        
        
        UIImageView  *imagev = [self.imageView viewWithTag:i+1];
        imagev.hidden = NO;
        
        if (i == self.imageArr.count-1) {
            imagev.image=[UIImage imageNamed:self.imageArr[i]];
        }else{
            
            imagev.image = [UIImage imageWithData:self.imageArr[i]];
        }
        
    }
    
    
    if (self.imageArr.count > 3) {
        self.imageViwH.constant = 210;
        self.contentH.constant = 610;
    }else{
        self.imageViwH.constant = 210;
        self.contentH.constant = 500;
    }

}


-(void)tapgestureImagev:(UITapGestureRecognizer*)gesture{

    UIImageView *imaev = (UIImageView*)gesture.view;
    
    if (imaev.tag == self.imageArr.count) {
        if (self.imageArr.count == 6) {
            [MBProgressHUD showError:@"最多只能上传5张"];
            return;
        }
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
        [actionSheet showInView:self.view];
    }

}

-(void)longgestureimagev:(UILongPressGestureRecognizer*)longgesture{

     UIImageView *imaev = (UIImageView*)longgesture.view;
    self.deleteImageIndex = imaev.tag - 1;
    if (longgesture.state ==  UIGestureRecognizerStateBegan) {
        
        if (imaev.tag != self.imageArr.count) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要删除该图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 10;
            [alert show];
        }
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        if (alertView.tag == 10) {
            [self.imageArr removeObjectAtIndex:self.deleteImageIndex];
            [self refreshimageview];
            
        }
        
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
            
            data = UIImageJPEGRepresentation(image, 0.1);
        }else {
            data=    UIImageJPEGRepresentation(image, 0.1);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        [self.imageArr insertObject:data atIndex:0];
        [self refreshimageview];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}


-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.contentW.constant = SCREEN_WIDTH;
    self.contentH.constant = 500;
    self.imageViwH.constant = 100;
    
    self.submitBt.layer.cornerRadius = 4;
    self.submitBt.clipsToBounds = YES;

}

-(NSMutableArray*)imageArr{
    if (!_imageArr) {
        _imageArr=[NSMutableArray arrayWithObjects:@"照片框-拷贝-9", nil];
    }
    return _imageArr;
}
@end
