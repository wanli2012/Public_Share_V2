//
//  LBPaysucessView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBPaysucessView.h"
#import <Masonry/Masonry.h>

@interface LBPaysucessView ()

@property(nonatomic , strong) UIImageView *headimage;
@property(nonatomic , strong) UILabel *sucesslb;

@end

@implementation LBPaysucessView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadUI];
        
        self.backgroundColor=YYSRGBColor(235, 235, 235, 1);
    }
    return self;
    
}

-(void)loadUI{
    [self addSubview:self.headimage];
    [self addSubview:self.sucesslb];
    [self addSubview:self.pricelb];
    
    [self.headimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self).centerOffset(CGPointMake(0, -100));
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    [self.sucesslb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self.headimage.mas_bottom).offset(8);
        make.height.equalTo(@20);
    
    }];

    [self.pricelb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.top.equalTo(self.sucesslb.mas_bottom).offset(8);
        make.height.equalTo(@20);
 
    }];


     _headimage.image = [UIImage imageNamed:@"支付成功"];
}

-(UIImageView*)headimage{
    
    if (!_headimage) {
        
        _headimage = ({
            
            UIImageView *view=[[UIImageView alloc]init];
            view.backgroundColor=[UIColor clearColor];
            view.contentMode = UIViewContentModeScaleAspectFit;
            view;
        });
    }
    
    return _headimage;
}

-(UILabel*)sucesslb{
    
    if (!_sucesslb) {
        _sucesslb=[[UILabel alloc]init];
        _sucesslb.backgroundColor=[UIColor clearColor];
        _sucesslb.textColor=[UIColor blackColor];
        _sucesslb.font=[UIFont systemFontOfSize:17];
        _sucesslb.textAlignment=NSTextAlignmentCenter;
        _sucesslb.text = @"成功支付";

    }
    return _sucesslb;
    
}

-(UILabel*)pricelb{
    
    if (!_pricelb) {
        _pricelb=[[UILabel alloc]init];
        _pricelb.backgroundColor=[UIColor clearColor];
        _pricelb.textColor=[UIColor blackColor];
        _pricelb.font=[UIFont systemFontOfSize:17];
        _pricelb.textAlignment=NSTextAlignmentCenter;
        
    }
    return _pricelb;
    
}

@end
