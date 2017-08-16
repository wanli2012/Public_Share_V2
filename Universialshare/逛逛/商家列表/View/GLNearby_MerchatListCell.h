//
//  GLNearby_MerchatListCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLNearby_MerchatListModel.h"

@protocol GLNearby_MerchatListCellDelegate <NSObject>

- (void)mapTo:(NSInteger)index;

@end

@interface GLNearby_MerchatListCell : UITableViewCell

@property (nonatomic, strong)GLNearby_MerchatListModel *model;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (nonatomic, assign)id <GLNearby_MerchatListCellDelegate> delegate;

@property (nonatomic, assign)NSInteger index;

@end
