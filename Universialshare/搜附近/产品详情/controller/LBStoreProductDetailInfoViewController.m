//
//  LBStoreProductDetailInfoViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/16.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//
#import "LBStoreProductDetailInfoViewController.h"
#import "SDCycleScrollView.h"
#import "LBStoreProductDetailInfoTableViewCell.h"
#import "LBStoreDetailreplaysTableViewCell.h"
#import "LBStoreDetailHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GLShoppingCartController.h"
#import "GLConfirmOrderController.h"
#import "MXNavigationBarManager.h"
#import "GLStoreProductCommentController.h"
#import "UMSocial.h"
#import <Social/Social.h>
#import "GLShareView.h"
#import "GLSet_MaskVeiw.h"
#import "JZAlbumViewController.h"

@interface LBStoreProductDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,CAAnimationDelegate>
{

    CALayer         *layer;
    NSInteger       _cnt;      // 记录个数
    UILabel     *_cntLabel;
    
    GLShareView *_shareV;
    GLSet_MaskVeiw *_maskV;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIButton *backbutton;
@property (weak, nonatomic) IBOutlet UILabel *titileLb;
@property (weak, nonatomic) IBOutlet UIButton *shareBt;
@property (weak, nonatomic) IBOutlet UIButton *carbutton;
@property (weak, nonatomic) IBOutlet UIButton *addcarBt;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic,strong) UIBezierPath *path;
@property (strong, nonatomic)NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet UIImageView *collectionimage;
@property (assign, nonatomic) NSInteger pl_count;
@property (assign, nonatomic) NSInteger is_collection;//是否收藏

@end

@implementation LBStoreProductDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titileLb.text = self.goodname;
    self.tableView.tableHeaderView = self.cycleScrollView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBStoreProductDetailInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreProductDetailInfoTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBStoreDetailreplaysTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailreplaysTableViewCell"];
    
    _cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, -2, 20, 20)];
    _cntLabel.textColor = TABBARTITLE_COLOR;
    _cntLabel.textAlignment = NSTextAlignmentCenter;
    _cntLabel.font = [UIFont boldSystemFontOfSize:12];
    _cntLabel.backgroundColor = [UIColor whiteColor];
    _cntLabel.layer.cornerRadius = CGRectGetHeight(_cntLabel.bounds)/2;
    _cntLabel.layer.masksToBounds = YES;
    _cntLabel.layer.borderWidth = 1.0f;
    _cntLabel.layer.borderColor = TABBARTITLE_COLOR.CGColor;
    [self.carbutton addSubview:_cntLabel];
    if (_cnt == 0) {
        _cntLabel.hidden = YES;
    }
    [self initdatasource];//请求数据
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    NSDictionary *dic ;
    if ([UserModel defaultUser].loginstatus == YES) {
        dic =@{@"goods_id":self.goodId,@"uid":[UserModel defaultUser].uid,@"token":[UserModel defaultUser].token};
    }else{
        dic =@{@"goods_id":self.goodId};
    }
    [NetworkManager requestPOSTWithURLStr:@"shop/getGoodsDetailByGoodsID" paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                self.dataDic = responseObject[@"data"];
                self.pl_count = [responseObject[@"pl_count"]integerValue];
                self.cycleScrollView.imageURLStringsGroup = self.dataDic[@"goods_data"][@"img_arr"];
                self.titileLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"goods_data"][@"name"]];
                
                if ([self.dataDic[@"goods_data"][@"is_collection"]integerValue] == 0) {
                    self.collectionimage.image = [UIImage imageNamed:@"collect_icon"];
                }else{
                    self.collectionimage.image = [UIImage imageNamed:@"collect_select_icon"];
                }
                self.is_collection = [self.dataDic[@"goods_data"][@"is_collection"]integerValue];
                
                [self.tableView reloadData];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [MXNavigationBarManager reStoreToCustomNavigationBar:self];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.dataDic.count > 0) {
        return 2;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return [self.dataDic[@"com_data"]count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        self.tableView.estimatedRowHeight = 125;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
        
        
    }else if (indexPath.section == 1){
        self.tableView.estimatedRowHeight = 90;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        LBStoreProductDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreProductDetailInfoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.storelb.text = [NSString stringWithFormat:@"%@",self.storename];
        
        cell.moneyLb.text = [NSString stringWithFormat:@"现价%@",self.dataDic[@"goods_data"][@"discount"]];
        cell.yuanjiLb.text = [NSString stringWithFormat:@"原价%@",self.dataDic[@"goods_data"][@"price"]];
        cell.infolb.text = [NSString stringWithFormat:@"规格:%@",self.dataDic[@"goods_data"][@"spec_info"]];
        cell.catalbel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"goods_data"][@"cate"]];
        
        if ([cell.infolb.text rangeOfString:@"null"].location != NSNotFound ) {
            cell.infolb.text = @"规格:默认";
        }
        
        if ([self.dataDic[@"goods_data"][@"rl_type"] integerValue] == 1) {
            cell.rebateTypeLb.text = @"20%";
        }else if ([self.dataDic[@"goods_data"][@"rl_type"] integerValue] == 2) {
            cell.rebateTypeLb.text = @"10%";
        }else if ([self.dataDic[@"goods_data"][@"rl_type"] integerValue] == 3) {
            cell.rebateTypeLb.text = @"5%";
        }else if ([self.dataDic[@"goods_data"][@"rl_type"] integerValue] == 4) {
            cell.rebateTypeLb.text = @"3%";
        }
        NSString *strone = [NSString stringWithFormat:@"[%@]",self.dataDic[@"goods_data"][@"attr"]];
        long len1 = [strone length];
        NSString *strtwo = [NSString stringWithFormat:@"[%@]%@",self.dataDic[@"goods_data"][@"attr"],self.dataDic[@"goods_data"][@"info"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:strtwo];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,len1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0,len1)];

        cell.namelb.attributedText = str;
        
        return cell;
        
    }else if (indexPath.section == 1){
        LBStoreDetailreplaysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailreplaysTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.starView.progress = [self.dataDic[@"com_data"][indexPath.row][@"mark"] integerValue];
        cell.nameLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"user_name"]];
        cell.contentLb.text =  [self.dataDic[@"com_data"][indexPath.row][@"comment"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        cell.timeLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"addtime"]];
        [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"pic"]]] placeholderImage:[UIImage imageNamed:@"熊"] options:SDWebImageAllowInvalidSSLCertificates];
        if ([self.dataDic[@"com_data"][indexPath.row][@"is_comment"] integerValue] == 2) {
            cell.replyLb.hidden = NO;
            cell.replyLb.text = [NSString stringWithFormat:@"商家回复:%@",[self.dataDic[@"com_data"][indexPath.row][@"reply"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            cell.constaritH.constant = 15;
            cell.constraitTop.constant = 0;

        }else{
            cell.replyLb.hidden = YES;
            cell.replyLb.text = @"";
            cell.constaritH.constant = 0;
            cell.constraitTop.constant = 6;
            
        }
        
        if ([cell.nameLb.text rangeOfString:@"null"].location != NSNotFound) {
            cell.nameLb.text = @"无名";
        }
        return cell;
        
    }
    return [[UITableViewCell alloc]init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }
    return 40;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LBStoreDetailHeaderView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBStoreDetailHeaderView"];
    if (!headerview) {
        headerview = [[LBStoreDetailHeaderView alloc] initWithReuseIdentifier:@"LBStoreDetailHeaderView"];
        
    }
    
    if (section == 0){
        headerview.titleLb.hidden = YES;
        headerview.moreBt.hidden = YES;
    }else if (section == 1){
        if (self.dataDic.count > 0 ) {
            headerview.titleLb.text = [NSString stringWithFormat:@"评论 (%d)",self.pl_count];
                headerview.moreBt.hidden = NO;
//            if ([self.dataDic[@"pl_count"]integerValue] > 3) {
//                 headerview.moreBt.hidden = NO;
//            }else{
//                headerview.moreBt.hidden = YES;
//            }
            
        }else{
            headerview.titleLb.text = @"评论 (0)";
            headerview.moreBt.hidden = YES;
        }
        [headerview.moreBt setTitle:@"查看更多" forState:UIControlStateNormal];
        [headerview.moreBt addTarget:self action:@selector(checkMore:) forControlEvents:UIControlEventTouchUpInside];
        headerview.titleLb.hidden = NO;
    }
    
    return headerview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
}

- (IBAction)backbuttonEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sharebuttonEvent:(UIButton *)sender {
    
    
}
//查看更多
- (void)checkMore:(id)sender{
    self.hidesBottomBarWhenPushed = YES;
    GLStoreProductCommentController *commentVC = [[GLStoreProductCommentController alloc] init];
    commentVC.goodId = self.goodId;
    [self.navigationController pushViewController:commentVC animated:YES];
}
//立即购买
- (IBAction)amoentbuy:(UIButton *)sender {
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    GLConfirmOrderController *vc=[[GLConfirmOrderController alloc]init];
    vc.goods_id = self.goodId;
    vc.goods_count = @"1";
    vc.orderType = 2; //订单类型
    [self.navigationController pushViewController:vc animated:YES];

}
//进入购物车
- (IBAction)enterCarBuyList:(UIButton *)sender {
    _cnt = 0;
    _cntLabel.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    GLShoppingCartController *vc=[[GLShoppingCartController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//收藏
- (IBAction)productColletion:(UITapGestureRecognizer *)sender {
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }

    if (self.is_collection  == 0) {
 
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"token"] = [UserModel defaultUser].token;
            dict[@"uid"] = [UserModel defaultUser].uid;
            dict[@"GID"] = self.goodId;
            dict[@"type"] = @(2);
            
            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:@"shop/addMyCollect" paramDic:dict finish:^(id responseObject) {
                
                [_loadV removeloadview];
                if ([responseObject[@"code"] integerValue] == 1){
                    self.collectionimage.image = [UIImage imageNamed:@"collect_select_icon"];
                    self.is_collection = 1;
                    [MBProgressHUD showSuccess:@"收藏成功"];
                    
                }else{
                    
                    [MBProgressHUD showError:responseObject[@"message"]];
                }
                
                [self.tableView reloadData];
                
            } enError:^(NSError *error) {
                [_loadV removeloadview];
                
            }];
       
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"GID"] = self.goodId;

        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"shop/delMyCollect" paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == 1){
                self.collectionimage.image = [UIImage imageNamed:@"collect_icon"];
                self.is_collection = 0;
                if (self.isnotice == YES) {
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"GLMyCollectionController" object:nil];
                }
                
                [MBProgressHUD showSuccess:@"取消收藏成功"];
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
            [self.tableView reloadData];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];
    }
    
}
//加入购物车

- (IBAction)addBuyCarEvent:(UIButton *)sender {
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"goods_id"] = self.goodId;
        dict[@"count"] = @(1);
        dict[@"type"] = @(2);
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"shop/addCart" paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == 1){
                
                [self addbuycarannimation];
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
            [self.tableView reloadData];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];
    
}
//分享页面消失
- (void)dismiss{
    CGFloat shareVH = SCREEN_HEIGHT /5;
    [UIView animateWithDuration:0.2 animations:^{
        
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, shareVH);
        
    } completion:^(BOOL finished) {
        
        [_maskV removeFromSuperview];
    }];
}
//分享商品
- (IBAction)tapgestureShareproduct:(UITapGestureRecognizer *)sender {
    CGFloat shareVH = SCREEN_HEIGHT /5;
    
    if (_maskV == nil) {
        
        _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        _maskV.bgView.alpha = 0.4;
        
        _shareV = [[NSBundle mainBundle] loadNibNamed:@"GLShareView" owner:nil options:nil].lastObject;
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH, 0);
        [_shareV.weiboShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareV.weixinShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareV.friendShareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [self.view addSubview:_maskV];
    }
    [_maskV showViewWithContentView:_shareV];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _shareV.frame = CGRectMake(0, SCREEN_HEIGHT - shareVH, SCREEN_WIDTH, shareVH);
    }];
    
}


- (void)shareClick:(UIButton *)sender {
    
    if (sender == _shareV.weiboShareBtn) {
        [self shareTo:@[UMShareToSina]];
    }else if (sender == _shareV.weixinShareBtn){
        [self shareTo:@[UMShareToWechatSession]];
    }else if (sender == _shareV.friendShareBtn){
        [self shareTo:@[UMShareToWechatTimeline]];
    }
    
}
- (void)shareTo:(NSArray *)type{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@",SHARE_URL,[UserModel defaultUser].name];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"大众共享";
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@",SHARE_URL,[UserModel defaultUser].name];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"大众共享";
    
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString stringWithFormat:@"%@%@",SHARE_URL,[UserModel defaultUser].name];
    //    [UMSocialData defaultData].extConfig.sinaData.title = @"加入我们吧";
    
    UIImage *image=[UIImage imageNamed:@"mine_logo"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:type content:[NSString stringWithFormat:@"大众共享，让每一个有心参与公益事业的人都能参与进来(用safari浏览器打开)%@",[NSString stringWithFormat:@"%@%@",SHARE_URL,[UserModel defaultUser].name]] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
}

-(void)addbuycarannimation{

    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.addcarBt convertRect: self.addcarBt.bounds toView:window];
    
    self.addcarBt.backgroundColor=[UIColor grayColor];
    self.addcarBt.enabled = NO;
    
    //起点
    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
    //控点
    CGPoint controlPoint = CGPointMake(10, rect.origin.y);
    
    //创建一个layer
    layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 20, 20);
    layer.contents = (__bridge id)[UIImage imageNamed:@"购物车"].CGImage;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.position = CGPointMake(rect.origin.x, rect.origin.y);
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.cornerRadius = layer.frame.size.width/2;
    layer.masksToBounds = YES;
    [self.view.layer addSublayer:layer];
    
    //    //创建关键帧
    //    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //    animation.delegate = self;
    //    //动画时间
    //    animation.duration = 1;
    //
    //    //当动画完成，停留到结束位置
    //    animation.removedOnCompletion = NO;
    //    animation.fillMode = kCAFillModeForwards;
    //
    //    //当方法名字遇到create,new,copy,retain，都需要管理内存
    //    CGMutablePathRef path = CGPathCreateMutable();
    //    //设置起点
    //    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    //    CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x, controlPoint.y, 25, SCREEN_HEIGHT - 25);
    //    //设置动画路径
    //    animation.path = path;
    //    //执行动画
    //    [layer addAnimation:animation forKey:@"addCar"];
    //    //释放路径
    //    CGPathRelease(path);
    
    _path = [UIBezierPath bezierPath];
    [_path moveToPoint:startPoint];
    [_path addQuadCurveToPoint:CGPointMake(25, SCREEN_HEIGHT - 25) controlPoint:controlPoint];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAutoReverse;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.2f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:1.05f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.2;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:1.5f];
    narrowAnimation.duration = 1.0f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 1.0f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [layer addAnimation:groups forKey:@"addCar"];

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [layer animationForKey:@"addCar"]) {
        self.addcarBt.backgroundColor=YYSRGBColor(91, 202, 113, 1);
        self.addcarBt.enabled = YES;
        [layer removeFromSuperlayer];
        layer = nil;
        _cnt++;
        if (_cnt > 0) {
            _cntLabel.hidden = NO;
        }
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        _cntLabel.text = [NSString stringWithFormat:@"%ld",(long)_cnt];
        [_cntLabel.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [self.carbutton.layer addAnimation:shakeAnimation forKey:nil];
    }
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex =index;//这个参数表示当前图片的index，默认是0
    jzAlbumVC.imgArr = [self.cycleScrollView.imageURLStringsGroup mutableCopy];
    [self presentViewController:jzAlbumVC animated:NO completion:nil];

}
-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        
        _cycleScrollView.localizationImageNamesGroup = @[];

        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    }
    
    return _cycleScrollView;
    
}

-(NSDictionary*)dataDic{
    
    if (!_dataDic) {
        _dataDic=[NSDictionary dictionary];
    }
    
    return _dataDic;
}

@end
