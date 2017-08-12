//
//  LBDisplayPageView.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBDisplayPageView.h"

@implementation LBDisplayPageView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"LBDisplayPageView" owner:self options:nil].firstObject;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.frame = frame;
    }
    
    return self;
    
}

@end
