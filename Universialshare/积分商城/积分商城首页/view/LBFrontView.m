//
//  LBFrontView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBFrontView.h"
#import "SDCycleScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LBFrontView ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (strong, nonatomic)NSArray *imagearr;
@property(nonatomic , strong) UIVisualEffectView *ruVisualEffectView;
@end

@implementation LBFrontView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[NSBundle mainBundle]loadNibNamed:@"LBFrontView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundColor = [UIColor whiteColor];
        [self initInyerface];
    }
    return self;
}

-(void)initInyerface{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self.backView addSubview:self.cycleScrollView];
    self.imagev.image = [UIImage imageNamed:self.imagearr[0]];
    _ruVisualEffectView = [[UIVisualEffectView alloc]initWithEffect:
                           
                           [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _ruVisualEffectView.alpha = 0.9;
    _ruVisualEffectView.frame = CGRectMake(0, 0, self.imagev.frame.size.width, self.imagev.frame.size.height);
    [self.imagev addSubview:_ruVisualEffectView];

}

-(SDCycleScrollView*)cycleScrollView{

    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.backView.size.width, self.backView.size.height)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];//当一张都没有的时候的 占位图
        //每一张图的占位图
        _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
        
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.localizationImageNamesGroup = self.imagearr;
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"banner选中"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"banner未选中"];
    }
    
    return _cycleScrollView;

}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    [self.delegete clickScrollViewImage:index];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{

    NSString *imagextr = self.imagearr[index];
    if ([imagextr hasPrefix:@"http:"] || [imagextr hasPrefix:@"https:"]) {
        
        [self.imagev sd_setImageWithURL:[NSURL URLWithString:self.imagearr[index]] placeholderImage:nil];
        
    }else{
    
        self.imagev.image = [UIImage imageNamed:self.imagearr[index]];
    }
}

-(void)reloadImage:(NSArray *)arr{
    self.imagearr = arr;
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:self.imagearr[0]] placeholderImage:nil];
    self.cycleScrollView.imageURLStringsGroup = arr;
}

-(NSArray*)imagearr{

    if (!_imagearr) {
        _imagearr = @[@"banner01.jpg",
                      @"banner02.jpg",
                      @"banner03.jpg"];
    }
    
    return _imagearr;

}

@end
