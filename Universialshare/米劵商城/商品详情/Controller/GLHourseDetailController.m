                    //
//  GLHourseDetailController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLHourseDetailController.h"
#import "SDCycleScrollView.h"
#import "GLHourseDetailFirstCell.h"

#import "GLHourseDetailThirdCell.h"
#import "GLTwoButtonCell.h"
#import "GLImage_textDetailCell.h"
#import "GLHourseOptionCell.h"
#import "GLHourseChangeNumCell.h"

#import "GLEvaluateCell.h"
#import "GLConfirmOrderController.h"

#import "GLHourseOptionModel.h"
#import "GLShoppingCartController.h"

#import "GLGoodsDetailModel.h"
#import "GLShoppingCartController.h"
#import "JZAlbumViewController.h"

@interface GLHourseDetailController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,GLTwoButtonCellDelegate,GLHourseChangeNumCellDelegate,ChooseRankDelegate>
{
    NSMutableArray *_visableCells;
    
    //status:??
    int _status;
    LoadWaitView * _loadV;
    NSInteger _sum;
    NSIndexPath *_indexPath;//加减cell的IndexPath
}

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *cellArr;
@property (nonatomic, strong)GLGoodsDetailModel *model;
@property (assign, nonatomic) NSInteger is_collection;//是否收藏

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@property (nonatomic, copy)NSString *goods_spec;//规格项名字 如果是两个就用+拼接  例子:紫色+m
@property (nonatomic, copy)NSString *spec_id;//规格项id
@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏
@property(assign , nonatomic)CGPoint offset;//记录偏移

@end
static NSString *firstCell = @"GLHourseDetailFirstCell";

static NSString *thirdCell = @"GLHourseDetailThirdCell";
static NSString *twoButtonCell = @"GLTwoButtonCell";
static NSString *image_textCell = @"GLImage_textDetailCell";
static NSString *bottomCell = @"GLBottomCell";
static NSString *evaluateCell = @"GLEvaluateCell";
static NSString *optionCell = @"GLHourseOptionCell";
static NSString *changeNumCell = @"GLHourseChangeNumCell";


@implementation GLHourseDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _status = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.goods_spec = @"";
    _sum = 1;
//    self.navigationItem.title = @"房子详情";
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 180 *autoSizeScaleY)
                                                          delegate:self
                                                  placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];
    
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.clipsToBounds = YES;
    _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
    _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
    _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
    _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    
    self.tableView.tableHeaderView = _cycleScrollView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.bounces = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHourseDetailFirstCell" bundle:nil] forCellReuseIdentifier:firstCell];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLHourseDetailThirdCell" bundle:nil] forCellReuseIdentifier:thirdCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLTwoButtonCell" bundle:nil] forCellReuseIdentifier:twoButtonCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLImage_textDetailCell" bundle:nil] forCellReuseIdentifier:image_textCell];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLEvaluateCell" bundle:nil] forCellReuseIdentifier:evaluateCell];
    [self.tableView registerClass:[GLHourseOptionCell class] forCellReuseIdentifier:optionCell];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLHourseChangeNumCell" bundle:nil] forCellReuseIdentifier:changeNumCell];

    _visableCells = [NSMutableArray array];
    
    [self postRequest];
   [self initSpecificationsDataSoruce];
    
}
- (void)postRequest{

    NSDictionary *dict;
    if ([UserModel defaultUser].loginstatus == YES) {
        dict =@{@"goods_id":self.goods_id,@"uid":[UserModel defaultUser].uid,@"token":[UserModel defaultUser].token};
    }else{
        dict =@{@"goods_id":self.goods_id};
    }

    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/goodsDetail" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
             if (![responseObject[@"data"] isEqual:[NSNull null]]) {
           self.model = [GLGoodsDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
        }
        self.cycleScrollView.imageURLStringsGroup = responseObject[@"data"][@"details_banner"];
            
        if ([responseObject[@"data"][@"is_collection"]integerValue] == 0) {
            [self.collectionBtn setImage:[UIImage imageNamed:@"collect_icon"] forState:UIControlStateNormal];
        }else{
            [self.collectionBtn setImage:[UIImage imageNamed:@"collect_select_icon"] forState:UIControlStateNormal];
                    }
        self.is_collection = [responseObject[@"data"][@"is_collection"] integerValue];

        }
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableView reloadData];
    }];
    
}
//跳到购物车
- (IBAction)goToCart:(id)sender {
    
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    
    self.hidesBottomBarWhenPushed = YES;
    GLShoppingCartController *cartVC = [[GLShoppingCartController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
    
}
//收藏
- (IBAction)collection:(id)sender {

    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    if (self.is_collection  == 0) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"GID"] = self.goods_id;
        dict[@"type"] = @(self.type);
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"Shop/addMyCollect" paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == 1){
                
                [self.collectionBtn setImage:[UIImage imageNamed:@"collect_select_icon"] forState:UIControlStateNormal];
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
        dict[@"GID"] = self.goods_id;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"Shop/delMyCollect" paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == 1){
    
                [self.collectionBtn setImage:[UIImage imageNamed:@"collect_icon"] forState:UIControlStateNormal];
                self.is_collection = 0;
                if (self.is_notice == YES) {
                    
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

//米分兑换
- (IBAction)exchange:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLConfirmOrderController *confirmVC = [[GLConfirmOrderController alloc] init];
    confirmVC.goods_count = [NSString stringWithFormat:@"%zd",_sum];
    confirmVC.orderType = self.type;
    [self.navigationController pushViewController:confirmVC animated:YES];
}

//加入购物车
- (IBAction)addToCart:(id)sender {
    //取出 数量
    GLHourseChangeNumCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    if ([UserModel defaultUser].isSetTwoPwd == 0) {
        [MBProgressHUD showError:@"请先在设置中设置支付密码"];
        return;
    }
    if ([cell.sumLabel.text integerValue] <= 0) {
        [MBProgressHUD showError:@"数量不能为0"];
        return;
    }
    if (self.goods_spec.length <= 0) {
        [MBProgressHUD showError:@"还未选择规格"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"goods_id"] = self.goods_id;
    dict[@"type"] = @(self.type);
    dict[@"spec_id"] = self.spec_id;
    
    _sum = [cell.sumLabel.text integerValue];
    dict[@"count"] = @(_sum);
  
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/addCart" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 1){

            [MBProgressHUD showSuccess:@"成功加入购物车"];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];
 
}
#pragma mark -- 去结算
//去结算 订单确认
- (IBAction)confirmOrder:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    //取出 数量
    GLHourseChangeNumCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];

    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    
    if ([UserModel defaultUser].isSetTwoPwd == 0) {
        [MBProgressHUD showError:@"请先在设置中设置支付密码"];
        return;
    }
    
    if ([cell.sumLabel.text integerValue] <= 0) {
        [MBProgressHUD showError:@"数量不能为0"];
        return;
    }
    if (self.goods_spec.length <= 0) {
        [MBProgressHUD showError:@"还未选择规格"];
        return;
    }
    GLConfirmOrderController *vc=[[GLConfirmOrderController alloc]init];
    vc.goods_id = self.goods_id;
    vc.goods_count = cell.sumLabel.text;
    vc.orderType = 2; //订单类型
    vc.goods_spec = self.spec_id;
    [self.navigationController pushViewController:vc animated:YES];

}

- (NSMutableArray *)cellArr{
    if (!_cellArr) {
        _cellArr = [NSMutableArray array];
        
    }
    return _cellArr;
}
#pragma mark -- SDCycleScrollViewDelegate 点击看大图
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    self.HideNavagation = YES;
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex =index;//这个参数表示当前图片的index，默认是0
    jzAlbumVC.imgArr = [self.cycleScrollView.imageURLStringsGroup copy];//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
    
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
#pragma UITableviewDelegate UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_status == 1) {
        
//        return self.dataSource.count + 2;
        return 3;
    }else{
//        return self.dataSource.count;
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *GLcell;
    
    if (indexPath.row == 0) {
       
        GLHourseDetailFirstCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GLHourseDetailFirstCell"];
        cell.model = self.model;
        GLcell = cell;
      
    }else if(indexPath.row == 1){
        
        GLHourseChangeNumCell *cell = [self.tableView dequeueReusableCellWithIdentifier:changeNumCell];
        cell.indexPath = indexPath;
        _indexPath = indexPath;
        cell.delegate = self;
        if (![self.goods_spec isEqualToString:@""]) {
            cell.SpecificationsLb.text = self.goods_spec;
        }
        
        cell.sumLabel.text = [NSString stringWithFormat:@"%zd",_sum];
       
        GLcell = cell;
        
    }else{

        NSArray *arr = self.model.attr;
        GLHourseDetailThirdCell *cell = [[GLHourseDetailThirdCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) andDatasource:arr :@"商品属性" ];
        GLcell = cell;

    }
    
    [self.cellArr addObject:GLcell];
    GLcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return GLcell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        return self.tableView.rowHeight;
        
    }else if (indexPath.row == 1 ){

        self.tableView.estimatedRowHeight = 140;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        return self.tableView.rowHeight;
        
    }else if (indexPath.row ==2 ){
        
        NSArray *arr = self.model.attr;
        return [self jisuangaodu:arr];
        
    }else{
        
        return 100;
    }
    
}
- (float)jisuangaodu:(NSArray *)arr{
    float upX = 10;
    float upY = 40;

    for (int i = 0; i<arr.count; i++) {
        NSString *str = [arr objectAtIndex:i] ;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [str sizeWithAttributes:dic];
        
        if ( upX > (SCREEN_WIDTH-20 -size.width-35)) {
            
            upX = 10;
            upY += 30;
        }
        
        upX+= SCREEN_WIDTH * 0.4;
    
    }
    return upY + 30;
}
- (float)jisuanjincou:(NSArray *)arr{
    float upX = 10;
    float upY = 40;
    //    NSArray *arr = [[NSArray alloc] initWithObjects:@"级别",@"级别",@"级别",@"级别",nil];
    for (int i = 0; i<arr.count; i++) {
        NSString *str = [arr objectAtIndex:i] ;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [str sizeWithAttributes:dic];
        
        if ( upX > (SCREEN_WIDTH-20 -size.width-35)) {
            
            upX = 10;
            upY += 30;
        }
        
        upX+= size.width + 35;
    }
    return upY + 30;
}

- (void)changeNum:(NSString *)text{
    _sum = [text  integerValue];
}
//请求规格
-(void)initSpecificationsDataSoruce{

    [NetworkManager requestPOSTWithURLStr:@"Shop/getGoodsSpec" paramDic:@{@"goods_id":self.goods_id} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                for (int i=0; i<[responseObject[@"data"] count]; i++) {
                    [self.standardList addObject:responseObject[@"data"][i][@"spec_name"] ];
                     [self.standardValueList addObject:responseObject[@"data"][i][@"title_name"] ];
                    [self initChooseView];
                }
            }
        }
    } enError:^(NSError *error) {

    }];
    
}

//不同规格下的参数
-(void)setStoreGoods{
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/getGoodsSpecDetail" paramDic:@{@"goods_id":self.goods_id,@"goods_spec":self.goods_spec} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1){
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                self.model.rebate = responseObject[@"data"][@"marketprice"];
                self.model.money = responseObject[@"data"][@"productprice"];
                self.spec_id = responseObject[@"data"][@"spec_id"];
                [self.tableView reloadData];
            }
        }
    } enError:^(NSError *error) {
        
    }];
    
}
//选择规格
-(void)SpecificationsEvent{

    if (self.standardList.count <= 0) {
        [MBProgressHUD showError:@"暂无规格选择"];
        return;
    }
    [UIView animateWithDuration: 0.35 animations: ^{
        self.backgroundView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        self.chooseView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion: nil];

}

-(void)initChooseView{
    
    self.chooseView = [[ChooseView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.chooseView];
    
    
    CGFloat maxY = 0;
    CGFloat height = 0;
    for (int i = 0; i < self.standardList.count; i ++)
    {
        
        self.chooseRank = [[ChooseRank alloc] initWithTitle:self.standardList[i] titleArr:self.standardValueList[i] andFrame:CGRectMake(0, maxY, SCREEN_WIDTH, 40)];
        maxY = CGRectGetMaxY(self.chooseRank.frame);
        height += self.chooseRank.height;
        self.chooseRank.tag = 8000+i;
        self.chooseRank.delegate = self;
        
        [self.chooseView.mainscrollview addSubview:self.chooseRank];
    }
    self.chooseView.mainscrollview.contentSize = CGSizeMake(0, height);
    
    //加入购物车按钮  取消
    [self.chooseView.addBtn addTarget:self action:@selector(addGoodsCartBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //立即购买  确定
    [self.chooseView.buyBtn addTarget:self action:@selector(Buynow) forControlEvents:UIControlEventTouchUpInside];
    //取消按钮
//    [self.chooseView.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.chooseView.alphaView addGestureRecognizer:tap];
}
//取消
-(void)addGoodsCartBtnClick{
    [self dismiss];
}
//确定
-(void)Buynow{
    self.goods_spec = @"";
    if (self.rankArray.count !=  self.standardList.count) {
        [MBProgressHUD showError:@"请选择所有规格"];
        return;
    }
    
    for (int i = 0; i < self.rankArray.count; i++) {
        if (i == self.rankArray.count - 1) {
            self.goods_spec = [self.goods_spec stringByAppendingFormat:@"%@",_rankArray[i]];
        }else{
           self.goods_spec = [self.goods_spec stringByAppendingFormat:@"%@+",_rankArray[i]];
        }
    }
    
    [self setStoreGoods];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    [self dismiss];
}
/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss
{
    //    center.y = center.y+self.view.frame.size.height;
    [UIView animateWithDuration: 0.35 animations: ^{
        self.chooseView.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundView.transform = CGAffineTransformIdentity;
    } completion: nil];
    
}

-(void)selectBtnTitle:(NSString *)title andBtn:(UIButton *)btn{
    [self.rankArray removeAllObjects];
    for (int i=0; i < _standardList.count; i++)
    {
        ChooseRank *view = [self.chooseView.mainscrollview viewWithTag:8000+i];
        
        for (UIButton *obj in  view.btnView.subviews)
        {
            if(obj.selected){
                
                for (NSArray *arr in self.standardValueList)
                {
                    for (NSString *title in arr) {
                        
                        if ([view.selectBtn.titleLabel.text isEqualToString:title]) {
                            
                            [self.rankArray addObject:view.selectBtn.titleLabel.text];
                        }
                    }
                }
            }
        }
    }
}


- (void)changeView:(NSInteger )tag{

    if (tag == 11) {
        _status = 1;
    }else{
        _status = 0;
    }
    
    [self.tableView reloadData];
    
}

-(NSMutableArray*)standardList{
    if (!_standardList) {
        _standardList = [NSMutableArray array];
    }
    
    return _standardList;

}

-(NSMutableArray*)standardValueList{
    if (!_standardValueList) {
        _standardValueList = [NSMutableArray array];
    
    }
    
    return _standardValueList;
    
}

-(NSMutableArray *)rankArray{
    
    if (_rankArray == nil) {
        
        _rankArray = [[NSMutableArray alloc] init];
    }
    return _rankArray;
}
@end
