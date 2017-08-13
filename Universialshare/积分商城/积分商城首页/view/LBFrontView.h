//
//  LBFrontView.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/8/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface LBFrontView : UIView

@property (strong, nonatomic)SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIView *navabaseV;


-(void)reloadImage:(NSArray*)arr;

@end
