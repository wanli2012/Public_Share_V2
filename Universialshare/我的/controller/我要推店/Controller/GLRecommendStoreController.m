//
//  GLRecommendStoreController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendStoreController.h"
#import "GLRecommendStroe_RecordController.h"

@interface GLRecommendStoreController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

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

//选择图片来源
-(void)tapgesturephotoOrCamera{
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
    [actionSheet showInView:self.view];
    
    
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
//        switch (self.tapIndex) {
//            case 1:
//            {
//                self.handImage.image = [UIImage imageWithData:data];
//            }
//                break;
//            case 2:
//            {
//                self.positiveImage.image = [UIImage imageWithData:data];
//            }
//                break;
//            case 3:
//            {
//                self.otherSideImage.image = [UIImage imageWithData:data];
//            }
//                break;
//            case 4:
//            {
//                self.licenseImage.image = [UIImage imageWithData:data];
//            }
//                break;
//            case 5:
//            {
//                self.undertakingOne.image = [UIImage imageWithData:data];
//            }
//                break;
//            case 6:
//            {
//                self.undertakingTwo.image = [UIImage imageWithData:data];
//            }
//                break;
//            case 7:
//            {
//                self.doorplateImage.image = [UIImage imageWithData:data];
//            }
//                break;
//            case 8:
//            {
//                self.DoorplateOneimage.image = [UIImage imageWithData:data];
//            }
//                break;
//            case 9:
//            {
//                self.InteriorImage.image = [UIImage imageWithData:data];
//            }
//                break;
//            case 10:
//            {
//                self.InteriorOneImage.image = [UIImage imageWithData:data];
//            }
//                break;
//                
//            default:
//                break;
//        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

//提交
- (IBAction)ensure:(id)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@""] = @2;
    [NetworkManager requestPOSTWithURLStr:@"index/banner_list" paramDic:@{@"type":@"6"} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                
//                for (NSDictionary *dic  in responseObject[@"data"]) {
//                    
//                }
//                
            }
        }
        
    } enError:^(NSError *error) {
        [MBProgressHUD showError:error.description];
    }];

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
