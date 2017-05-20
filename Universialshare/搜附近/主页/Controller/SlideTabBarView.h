//
//  SlideTabBarView.h
//  SlideTabBar
//
//  Created by Mr.LuDashi on 15/6/25.
//  Copyright (c) 2015年 李泽鲁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideTabBarView : UIView

//@property (nonatomic, strong)NSArray *models;

@property (assign) int tabCount;
-(instancetype)initWithFrame:(CGRect)frame WithCount: (int) count;
@end
