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

@interface LBStoreProductDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,CAAnimationDelegate>
{

    CALayer         *layer;
    NSInteger       _cnt;      // 记录个数
    UILabel     *_cntLabel;
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

@end

@implementation LBStoreProductDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"产品详情";
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
}

-(void)initdatasource{
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"shop/getGoodsDetailByGoodsID" paramDic:@{@"goods_id":@"110"} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                self.dataDic = responseObject[@"data"];
                self.cycleScrollView.imageURLStringsGroup = self.dataDic[@"img_arr"];
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
        self.tableView.estimatedRowHeight = 70;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        LBStoreProductDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreProductDetailInfoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.namelb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"goods_data"][@"name"]];
        cell.storelb.text = [NSString stringWithFormat:@"%@",self.storename];
        cell.moneyLb.text = [NSString stringWithFormat:@"打折%@",self.dataDic[@"goods_data"][@"discount"]];
        cell.yuanjiLb.text = [NSString stringWithFormat:@"原价%@",self.dataDic[@"goods_data"][@"price"]];
        cell.infolb.text = [NSString stringWithFormat:@"已选:%@",self.dataDic[@"goods_data"][@"info"]];
        
        return cell;
        
    }else if (indexPath.section == 1){
        LBStoreDetailreplaysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailreplaysTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.starView.progress = [self.dataDic[@"com_data"][indexPath.row][@"mark"] integerValue];
        cell.nameLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"user_name"]];
        cell.contentLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"comment"]];
        cell.timeLb.text = [NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"addtime"]];
        [cell.imagev sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataDic[@"com_data"][indexPath.row][@"pic"]]] placeholderImage:[UIImage imageNamed:@"熊"] options:SDWebImageAllowInvalidSSLCertificates];
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
            headerview.titleLb.text = [NSString stringWithFormat:@"评论 (%lu)",[self.dataDic[@"com_data"] count]];
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
    [self.navigationController pushViewController:commentVC animated:YES];
}
//立即购买
- (IBAction)amoentbuy:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLConfirmOrderController *vc=[[GLConfirmOrderController alloc]init];
    vc.goods_id = self.goodId;
    vc.goods_count = @"1";
    [self.navigationController pushViewController:vc animated:YES];

}
//进入购物车
- (IBAction)enterCarBuyList:(UIButton *)sender {
    _cnt = 0;
    _cntLabel.hidden = NO;
    self.hidesBottomBarWhenPushed = YES;
    GLShoppingCartController *vc=[[GLShoppingCartController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//收藏
- (IBAction)productColletion:(UIButton *)sender {
    if ([UserModel defaultUser].loginstatus == YES) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"GID"] = self.goodId;
        dict[@"type"] = @(2);
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"shop/addMyCollect" paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == 1){
                
                 [MBProgressHUD showSuccess:@"收藏成功"];
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
            [self.tableView reloadData];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];
    }else{
        [MBProgressHUD showSuccess:@"请先登录"];
    }
    
}

- (IBAction)addBuyCarEvent:(UIButton *)sender {
    
    if ([UserModel defaultUser].loginstatus == YES) {
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
    }else{
        [MBProgressHUD showSuccess:@"请先登录"];
    }
    
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
        _cntLabel.text = [NSString stringWithFormat:@"%ld",_cnt];
        [_cntLabel.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [self.carbutton.layer addAnimation:shakeAnimation forKey:nil];
    }
}
-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
        
        _cycleScrollView.localizationImageNamesGroup = @[];
        
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
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
