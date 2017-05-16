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

@interface LBStoreProductDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{

    CALayer         *_layer;
    NSInteger       _cnt;      // 记录个数
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIButton *backbutton;
@property (weak, nonatomic) IBOutlet UILabel *titileLb;
@property (weak, nonatomic) IBOutlet UIButton *shareBt;
@property (weak, nonatomic) IBOutlet UIButton *carbutton;
@property (weak, nonatomic) IBOutlet UIButton *addcarBt;

@property (nonatomic,strong) UIBezierPath *path;

@end

@implementation LBStoreProductDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView.tableHeaderView = self.cycleScrollView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBStoreProductDetailInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreProductDetailInfoTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBStoreDetailreplaysTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBStoreDetailreplaysTableViewCell"];
    
    
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
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
        return cell;
        
    }else if (indexPath.section == 1){
        LBStoreDetailreplaysTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBStoreDetailreplaysTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        [headerview.moreBt setTitle:@"查看更多" forState:UIControlStateNormal];
        headerview.titleLb.text = @"看小伙伴怎么说";
        headerview.moreBt.hidden = NO;
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

- (IBAction)addBuyCarEvent:(UIButton *)sender {
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.addcarBt convertRect: self.addcarBt.bounds toView:window];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x + 20, rect.origin.y + 20, 20, 20)];
    image.backgroundColor = [UIColor redColor];
    //[[UIApplication sharedApplication].keyWindow addSubview:image];

    [self startAnimationWithRect:rect ImageView:image];
}
-(void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView
{
    if (!_layer) {
        _layer = [CALayer layer];
        _layer.contents = (id)imageView.layer.contents;
        
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = rect;
        [_layer setCornerRadius:CGRectGetHeight([_layer bounds]) / 2];
        _layer.masksToBounds = YES;
        // 原View中心点
        _layer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
        [self.view.layer addSublayer:_layer];
        self.path = [UIBezierPath bezierPath];
        // 起点
        [_path moveToPoint:_layer.position];
        // 终点
        
        [_path addLineToPoint:CGPointMake(SCREEN_WIDTH - 10, SCREEN_HEIGHT-20)];
        
    }
    [self groupAnimation];
}
-(void)groupAnimation
{
       _tableView.userInteractionEnabled = NO;
  
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.path = _path.CGPath;
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.duration=0.3f;
        rotationAnimation.repeatCount = INFINITY;
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:1];
        narrowAnimation.duration = 1.0f;
        narrowAnimation.toValue = [NSNumber numberWithFloat:0.1];
        
        narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        // group
        CAAnimationGroup *groups = [CAAnimationGroup animation];
        groups.animations = @[animation,rotationAnimation,narrowAnimation];
        groups.duration = 1.0f;
        groups.removedOnCompletion=NO;
        groups.fillMode=kCAFillModeForwards;
        groups.delegate = self;
        [_layer addAnimation:groups forKey:@"group"];
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [_layer animationForKey:@"group"]) {
        _tableView.userInteractionEnabled = YES;
        [_layer removeFromSuperlayer];
        _layer = nil;
        _cnt++;
        
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



@end
