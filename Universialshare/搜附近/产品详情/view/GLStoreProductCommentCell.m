//
//  GLStoreProductCommentCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLStoreProductCommentCell.h"

@interface GLStoreProductCommentCell()



@end

@implementation GLStoreProductCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.commentBtn.layer.borderWidth = 1;
    self.commentBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.commentBtn.layer.cornerRadius = 5.f;
    
    self.bgView.layer.cornerRadius = 5.f;
}
- (IBAction)comment:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(comment)]) {
        [self.delegate comment];
    }
}
- (void)setModel:(GLStoreProductCommentModel *)model{
    _model = model;
    self.replyLabel.text = model.reply;
    if (model.index == 1) {
        _bgView.hidden = YES;
        _commentBtn.hidden = NO;
    }else{
        _bgView.hidden = NO;
        _commentBtn.hidden = YES;
    }
}

@end
