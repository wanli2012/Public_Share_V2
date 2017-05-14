//
//  GLMerchat_StoreCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMerchat_StoreCellDelegate <NSObject>

//index 1:暂停营业   2:修改密码
- (void)cellClick:(NSInteger )index;

@end

@interface GLMerchat_StoreCell : UITableViewCell

@property (nonatomic, assign)id<GLMerchat_StoreCellDelegate> delegate;

@end
