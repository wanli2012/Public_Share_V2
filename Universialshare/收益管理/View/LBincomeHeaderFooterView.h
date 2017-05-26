//
//  LBincomeHeaderFooterView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LBincomeHeaderdelegete <NSObject>

-(void)clickstartTimebutton:(UIButton*)buton;
-(void)clickendTimebutton:(UIButton*)buton;
-(void)clickSearchbutton:(UIButton*)button otherbutton:(UIButton*)button1;

@end
@interface LBincomeHeaderFooterView : UITableViewHeaderFooterView

@property(nonatomic , strong) UIButton *searchBt;//搜索
@property(nonatomic , strong) UIView *lineview;
@property(nonatomic , strong) UIButton *startBt;//开始时间
@property(nonatomic , strong) UIButton *endBt;//结束时间
@property(nonatomic , strong) UIImageView *headimage;
@property(nonatomic , assign) id<LBincomeHeaderdelegete> delegete;

@end
