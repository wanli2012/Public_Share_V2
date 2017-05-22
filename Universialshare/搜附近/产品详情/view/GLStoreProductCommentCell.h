//
//  GLStoreProductCommentCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/5/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLStoreProductCommentModel.h"

@protocol  GLStoreProductCommentCellDelegate <NSObject>

- (void)comment;

@end
@interface GLStoreProductCommentCell : UITableViewCell

@property (nonatomic, strong)GLStoreProductCommentModel *model;

@property (nonatomic, assign)id<GLStoreProductCommentCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@property (nonatomic, assign)NSInteger index;
@end
