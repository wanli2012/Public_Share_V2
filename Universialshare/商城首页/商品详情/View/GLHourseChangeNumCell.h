//
//  GLHourseChangeNumCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GLHourseChangeNumCellDelegate <NSObject>

- (void)changeNum:(NSInteger )tag indexPath:(NSIndexPath *)indexPath;
- (void)SpecificationsEvent;

@end

@interface GLHourseChangeNumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *changeNumView;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UIButton *SpecificationsBt;
@property (weak, nonatomic) IBOutlet UILabel *SpecificationsLb;


@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, assign)id<GLHourseChangeNumCellDelegate> delegate;

@end
