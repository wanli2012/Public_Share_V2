//
//  GLNearby_ClassifyHeaderView.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^typeBlock)(NSString *typeID);

@interface GLNearby_ClassifyHeaderView : UIView

@property (nonatomic, copy) typeBlock block;

@end
