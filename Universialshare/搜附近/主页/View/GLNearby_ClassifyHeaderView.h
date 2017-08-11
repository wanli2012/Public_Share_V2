//
//  GLNearby_ClassifyHeaderView.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassifyHeaderViewdelegete <NSObject>

-(void)tapgesture:(NSInteger)tag;

@end

@interface GLNearby_ClassifyHeaderView : UIView

-(instancetype)initWithFrame:(CGRect)frame withDataArr:(NSArray*)dataArr;

@property (assign , nonatomic)id<ClassifyHeaderViewdelegete> delegete;

@end
