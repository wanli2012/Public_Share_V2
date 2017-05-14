//
//  GLMerchat_StoreCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/14.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMerchat_StoreCell.h"

@interface GLMerchat_StoreCell ()
@property (weak, nonatomic) IBOutlet UIButton *suspendBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation GLMerchat_StoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.suspendBtn.layer.cornerRadius = 5.f;
    self.modifyBtn.layer.cornerRadius = 5.f;
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.clipsToBounds = YES;
    self.suspendBtn.clipsToBounds = YES;
    self.modifyBtn.clipsToBounds = YES;
}

- (IBAction)click:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellClick:)]) {
        if (sender == self.suspendBtn) {
            [self.delegate cellClick:1];
        }else{
            [self.delegate cellClick:2];
        }
    }
}

@end
