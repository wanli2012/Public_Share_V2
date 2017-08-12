//
//  LBFrontView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBFrontView.h"
#import "SDCycleScrollView.h"

@interface LBFrontView ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation LBFrontView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[NSBundle mainBundle]loadNibNamed:@"LBFrontView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)initInyerface{
    
    [self.backView addSubview:self.cycleScrollView];

}

-(SDCycleScrollView*)cycleScrollView{

    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.backView.frame
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];//当一张都没有的时候的 占位图
        //每一张图的占位图
        _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
        
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        _cycleScrollView.localizationImageNamesGroup = @[@"banner01.jpg",
                                                         @"banner02.jpg",
                                                         @"banner03.jpg"];
    }
    
    return _cycleScrollView;

}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
}

@end
