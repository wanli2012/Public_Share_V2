//
//  LBHomeIncomeView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBHomeIncomeView.h"
#import <Masonry/Masonry.h>

@implementation LBHomeIncomeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadUI];
        
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
    
}

-(void)loadUI{
      [self addSubview:self.headimage];
      [self addSubview:self.alllebel];
      [self addSubview:self.lineview];
    
    [self.alllebel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@60);
        make.centerX.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
    
    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self);
        make.leading.equalTo(self);
        make.bottom.equalTo(self).offset(-1);
        make.height.equalTo(@1);
    }];
    
    [self.headimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.alllebel.mas_leading).offset(-5);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.alllebel);

    }];

}


-(UIImageView *)headimage{
    
    if (!_headimage) {
        _headimage=[[UIImageView alloc]init];
        _headimage.backgroundColor=[UIColor whiteColor];
        _headimage.clipsToBounds = YES;
        _headimage.layer.cornerRadius = 4 ;
        _headimage.contentMode = UIViewContentModeScaleAspectFill;
        _headimage.userInteractionEnabled = NO;
        _headimage.image = [UIImage imageNamed:@"熊"];
        
    }
    
    return _headimage;
}

-(UILabel*)alllebel{
    
    if (!_alllebel) {
        _alllebel=[[UILabel alloc]init];
        _alllebel.backgroundColor=[UIColor clearColor];
        _alllebel.textColor=[UIColor blackColor];
        _alllebel.font=[UIFont systemFontOfSize:15];
        _alllebel.textAlignment=NSTextAlignmentCenter;
        _alllebel.text = @"营业总额: ¥0";
    }
    
    return _alllebel;
    
}

-(UIView*)lineview{

    if (!_lineview) {
        _lineview = [[UIView alloc]init];
        _lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _lineview;

}

@end
