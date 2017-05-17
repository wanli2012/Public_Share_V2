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
        _cntLabel.text = [NSString stringWithFormat:@"%d",_cnt];
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



@end
