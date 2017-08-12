//
//  GLNearby_ClassifyHeaderView.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_ClassifyHeaderView.h"
#import "GLNearby_ClassifyConcollectionCell.h"
#import "LBNearby_classifyItemView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLNearby_ClassifyHeaderView ()<UIScrollViewDelegate>

@property (strong, nonatomic)  UIScrollView *scorllView;
@property (strong, nonatomic)  UIPageControl *pageControl;
@property (strong , nonatomic)NSArray *dataArr;

@end

@implementation GLNearby_ClassifyHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray*)dataArr{

    self = [super initWithFrame:frame];
    
    if (self) {
//        self = [[NSBundle mainBundle]loadNibNamed:@"GLNearby_ClassifyHeaderView" owner:self options:nil].firstObject;
//        self.frame = frame;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.dataArr = dataArr;
        [self initerface];
    }
    
    return self;

}


-(void)initerface{

    _pageControl = [[UIPageControl alloc]init];
     _pageControl.numberOfPages = ((self.dataArr.count ) / 10 + 1) ;
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPageIndicatorTintColor = TABBARTITLE_COLOR;
    _pageControl.pageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
    _pageControl.backgroundColor = [UIColor whiteColor];
    [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    _scorllView = [[UIScrollView alloc] init];
    _scorllView.pagingEnabled = YES;
    _scorllView.showsHorizontalScrollIndicator = NO;
    _scorllView.showsVerticalScrollIndicator = NO;
    _scorllView.delegate = self;
    _scorllView.backgroundColor = [UIColor whiteColor];
       [self addSubview:_scorllView];
       [self addSubview:_pageControl];
    
    [_scorllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-25);
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self.scorllView.mas_bottom).offset(0);
        make.height.equalTo(@20);
    }];
    
     _scorllView.contentSize = CGSizeMake(SCREEN_WIDTH * ((self.dataArr.count ) / 10 + 1), _scorllView.frame.size.height);
    [self  initdatasorece];
}

-(void)initdatasorece{

    NSInteger itemW = 50 * autoSizeScaleX ; //每个分类的宽度
    NSInteger itemH = itemW + 25; // 每个分类的高度
    NSInteger num = 5 ;//每行展示多少个分类
    NSInteger padding_x = 10 ;//第一个距离边界多少px
    NSInteger padding_top = 10 ;//距离顶部多少px
    NSInteger padding_y = 10 ;//item之间多少px
    NSInteger item_dis = (SCREEN_WIDTH - padding_x * 2 - num * itemW) / (num - 1);
    
    for (int i = 0 ; i <= self.dataArr.count; i++) {
        
        LBNearby_classifyItemView *item = [[NSBundle mainBundle]loadNibNamed:@"LBNearby_classifyItemView" owner:nil options:nil].firstObject;
        
        int  V = i / num;
        int  H = i % num;
        int sep = SCREEN_WIDTH * (i / 10);
        
        item.tag = 10 + i;
        item.frame = CGRectMake(sep + padding_x + (itemW + item_dis) * H, padding_x + padding_top + (padding_y + itemH) * (V % 2), itemW , itemH);
        item.autoresizingMask = UIViewAutoresizingNone;
        
        if (i == self.dataArr.count) {
            item.titleLb.text = @"全部分类";
            item.imagev.image = [UIImage imageNamed:@"全部分类"];
        }else{
            item.titleLb.text = self.dataArr[i][@"trade_name"];
            [item.imagev sd_setImageWithURL:[NSURL URLWithString:self.dataArr[i][@"thumb"]] placeholderImage:[UIImage imageNamed:@"分类占位图"]];
        }
        item.titleLb.font = [UIFont systemFontOfSize:12 * autoSizeScaleX];
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureClassfty:)];
        [item addGestureRecognizer:tapgesture];
        [_scorllView addSubview:item];
        
    }
    
}

-(void)pageControlChanged:(UIPageControl*)pageControl{

    NSInteger page = pageControl.currentPage;
    [self.scorllView setContentOffset:CGPointMake(page * SCREEN_WIDTH, 0) animated:YES];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSInteger offset = scrollView.contentOffset.x / SCREEN_WIDTH;

    self.pageControl.currentPage = offset;

}

-(void)tapgestureClassfty:(UITapGestureRecognizer*)tap{

    [self.delegete tapgesture:tap.view.tag];

}

-(NSArray*)dataArr{

    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

@end
