//
//  LBStoreSendGoodsTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/6/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBStoreSendGoodsDelegete <NSObject>

-(void)clickSendGoods:(NSInteger)index;

@end

@interface LBStoreSendGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *codelb;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *phonelb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (assign, nonatomic) NSInteger  indexRow;
@property (assign, nonatomic) id<LBStoreSendGoodsDelegete>  delegete;

@end
