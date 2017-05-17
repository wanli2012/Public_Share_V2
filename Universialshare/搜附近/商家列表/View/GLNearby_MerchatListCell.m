//
//  GLNearby_MerchatListCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_MerchatListCell.h"

@interface GLNearby_MerchatListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;

@end

@implementation GLNearby_MerchatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.picImageV.layer.cornerRadius = 5.f;
    self.picImageV.clipsToBounds = YES;
    
}
- (IBAction)mapToHere:(id)sender {
}



@end
