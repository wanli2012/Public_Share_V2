//
//  GLStoreProductCommentCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_CommentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCStarRatingView.h"

@interface GLMerchat_CommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet LCStarRatingView *starView;

@end

@implementation GLMerchat_CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.commentBtn.layer.borderWidth = 1;
    self.commentBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.commentBtn.layer.cornerRadius = 5.f;
    
    self.starView.enabled = NO;
    self.bgView.layer.cornerRadius = 5.f;
}
- (IBAction)comment:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(comment:)]) {
        [self.delegate comment:self.index];
    }
}
- (void)setModel:(GLMerchat_CommentModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"XRPlaceholder"]];
    self.nameLabel.text = model.user_name;
    self.dateLabel.text = model.addtime;
    self.contentLabel.text = model.comment;
    self.starView.progress = [model.mark integerValue];
    
    if ([model.is_comment integerValue] == 1) {
        _bgView.hidden = YES;
        _commentBtn.hidden = NO;
        _replyLabel.text = @"";
        
    }else{
        self.replyLabel.text = [NSString stringWithFormat:@"商家回复:%@",model.reply];
        _bgView.hidden = NO;
        _commentBtn.hidden = YES;
    }
  
}

@end
