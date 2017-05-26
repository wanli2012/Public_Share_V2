//
//  LBincomeHeaderFooterView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBincomeHeaderFooterView.h"
#import <Masonry/Masonry.h>

@implementation LBincomeHeaderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initerface];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

-(void)initerface{
    [self addSubview:self.searchBt];
    [self addSubview:self.lineview];
    [self addSubview:self.startBt];
    [self addSubview:self.endBt];
    [self addSubview:self.headimage];

    [self.searchBt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@30);
        make.width.greaterThanOrEqualTo(@60);
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-10);
    }];
    
    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self);
        make.leading.equalTo(self);
        make.bottom.equalTo(self).offset(-1);
        make.height.equalTo(@1);
    }];
    
    [self.endBt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.searchBt.mas_leading).offset(-10);
        make.height.equalTo(@30);
        make.centerY.equalTo(self);
        make.width.equalTo([NSNumber numberWithFloat:(SCREEN_WIDTH - 110)/2]);
    }];
    
    [self.startBt mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self).offset(10);
        make.height.equalTo(@30);
        make.centerY.equalTo(self);
        make.width.equalTo([NSNumber numberWithFloat:(SCREEN_WIDTH - 110)/2]);
    }];
    
    [self.headimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.startBt.mas_trailing).offset(2);
        make.trailing.equalTo(self.endBt.mas_leading).offset(-2);
        make.height.equalTo(@1);
        make.centerY.equalTo(self);

    }];

    
}


-(void)searchBtbtton{
    [self.delegete clickSearchbutton:self.startBt otherbutton:self.endBt];

}

-(void)startTimeBtbtton{
    [self.delegete clickstartTimebutton:self.startBt];

}

-(void)endTimeBtbtton{
    [self.delegete clickendTimebutton:self.endBt];

}

-(UIButton*)searchBt{
    
    if (!_searchBt) {
        _searchBt=[[UIButton alloc]init];
        _searchBt.backgroundColor=TABBARTITLE_COLOR;
        [_searchBt setTitle:@"搜索" forState:UIControlStateNormal];
        _searchBt.titleLabel.font=[UIFont systemFontOfSize:13];
        [_searchBt addTarget:self action:@selector(searchBtbtton) forControlEvents:UIControlEventTouchUpInside];
        [_searchBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _searchBt.layer.cornerRadius =4;
        _searchBt.clipsToBounds =YES;
    }
    
    return _searchBt;
    
}

-(UIButton*)startBt{
    
    if (!_startBt) {
        _startBt=[[UIButton alloc]init];
        _startBt.backgroundColor=[UIColor whiteColor];
        [_startBt setTitle:@"请选择开始时间" forState:UIControlStateNormal];
        _startBt.titleLabel.font=[UIFont systemFontOfSize:12];
        [_startBt addTarget:self action:@selector(startTimeBtbtton) forControlEvents:UIControlEventTouchUpInside];
        [_startBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _startBt.layer.cornerRadius =4;
        _startBt.clipsToBounds =YES;
    }
    
    return _startBt;
    
}

-(UIButton*)endBt{
    
    if (!_endBt) {
        _endBt=[[UIButton alloc]init];
        _endBt.backgroundColor=[UIColor whiteColor];
        [_endBt setTitle:@"请选择结束时间" forState:UIControlStateNormal];
        _endBt.titleLabel.font=[UIFont systemFontOfSize:12];
        [_endBt addTarget:self action:@selector(endTimeBtbtton) forControlEvents:UIControlEventTouchUpInside];
        [_endBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _endBt.layer.cornerRadius =4;
        _endBt.clipsToBounds =YES;
    }
    
    return _endBt;
    
}

-(UIView*)lineview{
    
    if (!_lineview) {
        _lineview = [[UIView alloc]init];
        _lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _lineview;
    
}

-(UIImageView *)headimage{
    
    if (!_headimage) {
        _headimage=[[UIImageView alloc]init];
        _headimage.backgroundColor=[UIColor lightGrayColor];
        _headimage.contentMode = UIViewContentModeScaleAspectFill;
        _headimage.userInteractionEnabled = NO;

    }
    
    return _headimage;
}
@end
