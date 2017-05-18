//
//  SlideTabBarView.m
//  SlideTabBar
//
//  Created by Mr.LuDashi on 15/6/25.
//  Copyright (c) 2015年 李泽鲁. All rights reserved.
//

#import "SlideTabBarView.h"
#import "GLNearby_EatController.h"
#import "GLNearby_LiveController.h"
#import "GLNearby_PlayController.h"
#import "GLNearby_AllController.h"
#import "GLNearby_TradeOneModel.h"

#define TOPHEIGHT 40
#define YYSScreenW  [UIScreen mainScreen].bounds.size.width
#define YYSScreenH  [UIScreen mainScreen].bounds.size.height
#define YYSGlobalColor [UIColor colorWithRed:0/255.0 green:222/255.0  blue:0/255.0 alpha:1]
@interface SlideTabBarView()<UIScrollViewDelegate>
///@brife 整个视图的大小
@property (assign) CGRect mViewFrame;

///@brife 下方的ScrollView
@property (strong, nonatomic) UIScrollView *scrollView;

///@brife 上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViews;

///@brife 下方的表格数组
@property (strong, nonatomic) NSMutableArray *scrollTableViews;

///@brife TableViews的数据源
@property (strong, nonatomic) NSMutableArray *dataSource;

///@brife 当前选中页数
@property (assign) NSInteger currentPage;

///@brife 下面滑动的View
@property (strong, nonatomic) UIView *slideView;

///@brife 上方的view
@property (strong, nonatomic) UIView *topMainView;

///@brife 上方的ScrollView
@property (strong, nonatomic) UIScrollView *topScrollView;

@end

@implementation SlideTabBarView

-(instancetype)initWithFrame:(CGRect)frame WithCount: (int) count WithTitles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _mViewFrame = frame;
        _tabCount = count;
        _topViews = [[NSMutableArray alloc] init];
        _scrollTableViews = [[NSMutableArray alloc] init];
        _models = titles;
        
        [self initDataSource];
        
        [self initScrollView];
        
        [self initTopTabs];
        
        [self initDownTables];
        
        [self initDataSource];
        
        [self initSlideView];
        
    }
    
    return self;
}


#pragma mark -- 初始化滑动的指示View
-(void) initSlideView{
    
    CGFloat width = _mViewFrame.size.width / _tabCount;
    
    if(self.tabCount <=_tabCount){
        width = _mViewFrame.size.width / self.tabCount;
    }

    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT - 5, width, 2)];
    [_slideView setBackgroundColor:YYSRGBColor(0, 222, 0,1)];
    [_topScrollView addSubview:_slideView];
}


#pragma mark -- 初始化表格的数据源
-(void) initDataSource{
    _dataSource = [[NSMutableArray alloc] initWithCapacity:_tabCount];
    
    for (int i = 1; i <= _tabCount; i ++) {
        
        NSMutableArray *tempArray  = [[NSMutableArray alloc] initWithCapacity:20];
        
        for (int j = 1; j <= 20; j ++) {
            
            NSString *tempStr = [NSString stringWithFormat:@"我是第%d个TableView的第%d条数据。", i, j];
            [tempArray addObject:tempStr];
        }
        
        [_dataSource addObject:tempArray];
    }
}

#pragma mark -- 实例化ScrollView
-(void) initScrollView{

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT)];
    _scrollView.contentSize = CGSizeMake(_mViewFrame.size.width * _tabCount, _mViewFrame.size.height - TOPHEIGHT);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

#pragma mark -- 实例化顶部的tab

-(void) initTopTabs{
    CGFloat width = _mViewFrame.size.width / _tabCount;
    NSMutableArray *name1 = [NSMutableArray array];
    for (int i = 0 ;i < self.models.count; i++) {
        GLNearby_TradeOneModel *model = self.models[i];
        [name1 addObject:model.trade_name];
    }
    [name1 addObject:@"全部"];

    if(self.tabCount <= 6 ){
        width = _mViewFrame.size.width / self.tabCount;
    }
    
    _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    
    _topScrollView.showsHorizontalScrollIndicator = NO;
    
    _topScrollView.showsVerticalScrollIndicator = YES;
    
    _topScrollView.bounces = NO;
    
    _topScrollView.delegate = self;
    
    if (_tabCount >= 6) {
        _topScrollView.contentSize = CGSizeMake(100 * _tabCount, TOPHEIGHT);

    } else {
        _topScrollView.contentSize = CGSizeMake(_mViewFrame.size.width, TOPHEIGHT);
    }
    
    
    [self addSubview:_topMainView];
    
    [_topMainView addSubview:_topScrollView];
    
    
    
    for (int i = 0; i < _tabCount; i ++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, TOPHEIGHT)];
        
        view.backgroundColor = [UIColor whiteColor];
        view.tag = i;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
        label1.text = name1[i];
        label1.textColor = YYSRGBColor(85, 85, 85,1);
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:15];
        [view addSubview:label1];

        if (i == 0) {
            label1.textColor = YYSRGBColor(0, 222, 0,1);
        }
        
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabButton:)]];
        [_topViews addObject:view];
        [_topScrollView addSubview:view];
    }
}

#pragma mark --点击顶部的按钮所触发的方法
-(void) tabButton: (UITapGestureRecognizer *) tap{
    UIView *view = tap.view;
    [_scrollView setContentOffset:CGPointMake(view.tag * _mViewFrame.size.width, 0) animated:YES];
}

#pragma mark --初始化下方的TableViews
GLNearby_EatController *eat;
GLNearby_LiveController *live;
GLNearby_PlayController *play;
GLNearby_AllController *all;


- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
-(void) initDownTables{
    
    for (int i = 0; i < _tabCount; i ++) {
        
        if (i == 0) {
            
            eat = [[GLNearby_EatController alloc] init];
            [self.viewController addChildViewController:eat];
            eat.view.yy_width = SCREEN_WIDTH;
            eat.view.frame = CGRectMake(YYSScreenW*i, 0, YYSScreenW, _scrollView.yy_height);
            [_scrollTableViews addObject:eat.view];
            [_scrollView addSubview:eat.view];

        } else if (i == 1) {
            live = [[GLNearby_LiveController alloc] init];
            [self.viewController addChildViewController:live];
            live.view.yy_width = YYSScreenW;
            live.view.frame = CGRectMake(YYSScreenW*i, 0, YYSScreenW, _scrollView.yy_height);
            [_scrollTableViews addObject:live.view];
            [_scrollView addSubview:live.view];
            
        }else if (i == 2) {
            play = [[GLNearby_PlayController alloc] init];
            [self.viewController addChildViewController:play];
            play.view.yy_width = YYSScreenW;
            play.view.frame = CGRectMake(YYSScreenW*i, 0, YYSScreenW, _scrollView.yy_height);
            [_scrollTableViews addObject:play.view];
            [_scrollView addSubview:play.view];
            
        }else {
            all = [[GLNearby_AllController alloc] init];
            [self.viewController addChildViewController:all];
            all.view.yy_width = YYSScreenW;
            all.view.frame = CGRectMake(YYSScreenW*i, 0, YYSScreenW, _scrollView.yy_height);
            [_scrollTableViews addObject:all.view];
            [_scrollView addSubview:all.view];
        
        }
        
        
    }
    
}


#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
-(void) updateTableWithPageNumber: (NSUInteger) pageNumber{
    
    [self changeBackColorWithPage:pageNumber];
    
    int tabviewTag = pageNumber % _tabCount;
    
    CGRect tableNewFrame = CGRectMake(pageNumber * _mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT);
    
    UIView *view = _scrollTableViews[tabviewTag];
//    NSLog(@"%@",_scrollTableViews[tabviewTag]);
    view.frame = tableNewFrame;
    [eat.tableView reloadData];
    [live.tableView reloadData];
    [play.tableView reloadData];
    [all.tableView reloadData];

//    [view. reloadData];
}


- (void) changeBackColorWithPage: (NSInteger) currentPage {
    for (int i = 0; i < _topViews.count; i ++) {
        UIView *tempView = _topViews[i];
        for (UILabel *label in [tempView subviews]) {
            if (i == currentPage) {
                label.textColor = YYSGlobalColor;
            } else {
                label.textColor = YYSRGBColor(85, 85, 85,1);
            }
        }
        
    }
}


#pragma mark -- scrollView的代理方法

-(void) modifyTopScrollViewPositiong: (UIScrollView *) scrollView{
    if ([_topScrollView isEqual:scrollView]) {
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        
        CGFloat width = _slideView.frame.size.width;
        
        int count = (int)contentOffsetX/(int)width;
        
        CGFloat step = (int)contentOffsetX%(int)width;
        
        CGFloat sumStep = width * count;
        
        if (step > width/2) {
            
            sumStep = width * (count + 1);
            
        }
        
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        return;
    }

}

///拖拽后调用的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self modifyTopScrollViewPositiong:scrollView];
}



-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];


}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    if ([scrollView isEqual:_scrollView]) {
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        
        //    UITableView *currentTable = _scrollTableViews[_currentPage];
        //    [currentTable reloadData];
        
        [self updateTableWithPageNumber:_currentPage];

        return;
    }
    [self modifyTopScrollViewPositiong:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_scrollView isEqual:scrollView]) {
        CGRect frame = _slideView.frame;
        if (self.tabCount <= 4) {
             frame.origin.x = scrollView.contentOffset.x/_tabCount;
        } else {
             frame.origin.x = scrollView.contentOffset.x/4;
            
        }

        _slideView.frame = frame;
    }
    
}

@end
