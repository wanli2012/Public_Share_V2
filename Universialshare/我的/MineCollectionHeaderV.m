//
//  MineCollectionHeaderV.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "MineCollectionHeaderV.h"
#import <Masonry/Masonry.h>
#import "LBMineCenterinfoTableViewCell.h"
#import "UIButton+SetEdgeInsets.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SDCycleScrollView.h"

@interface MineCollectionHeaderV ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong) UIVisualEffectView *ruVisualEffectView;

@end

@implementation MineCollectionHeaderV


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadUI];

        self.backgroundColor=YYSRGBColor(235, 235, 235, 1);
    }
    return self;
    
}

-(void)loadUI{
    [self addSubview:self.baseview];
    [self addSubview:self.baseview1];
    [self.baseview addSubview:self.backimage];
    [self.backimage addSubview:self.ruVisualEffectView];
    [self.baseview addSubview:self.tableview];
    
    [self.baseview addSubview:self.headview];
    [self.headview addSubview:self.headimage];
    [self.baseview addSubview:self.namelebel];
    [self.baseview addSubview:self.identitylebel];
    [self.baseview addSubview:self.IDlebel];
    [self addSubview:self.cycleScrollView];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(1);
        make.height.equalTo(@(90 * autoSizeScaleX));
        
    }];

    [self.baseview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
        make.bottom.equalTo(self.cycleScrollView.mas_top).offset(0);
        make.top.equalTo(self).offset(0);
        
    }];

    [self.backimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.baseview).offset(0);
        make.leading.equalTo(self.baseview).offset(0);
        make.top.equalTo(self.baseview).offset(0);
        make.bottom.equalTo(self.baseview).offset(0);
    }];
    
    [self.ruVisualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.baseview).offset(0);
        make.leading.equalTo(self.baseview).offset(0);
        make.top.equalTo(self.baseview).offset(0);
        make.bottom.equalTo(self.baseview).offset(0);
    }];
    
    [self.headimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self.headview).offset(-2);
        make.leading.equalTo(self.headview).offset(2);
        make.top.equalTo(self.headview).offset(2);
        make.bottom.equalTo(self.headview).offset(-2);
    }];
    
    [self.namelebel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.headview);
        make.leading.equalTo(self.headview);
        make.top.equalTo(self.headview.mas_bottom).offset(8);
        //make.height.equalTo(@20);
    }];
    [self.identitylebel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.namelebel);
        make.leading.equalTo(self.namelebel);
        make.top.equalTo(self.namelebel.mas_bottom).offset(5);
        //make.height.equalTo(@20);
    }];
    [self.IDlebel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.identitylebel);
        make.leading.equalTo(self.identitylebel);
        make.top.equalTo(self.identitylebel.mas_bottom).offset(5);
        //make.height.equalTo(@20);
    }];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.baseview).offset(-10);
        make.leading.equalTo(self.headview.mas_trailing).offset(30);
        make.top.equalTo(self.baseview).offset(10 + 64);
        make.bottom.equalTo(self.baseview).offset(-10);
        
    }];

    [self.headimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[UserModel defaultUser].headPic]]];
    
    if (!self.headimage.image) {
        
        self.headimage.image = [UIImage imageNamed:@"dtx_icon"];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 25;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterinfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterinfoTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLb.text= [NSString stringWithFormat:@"%@",self.titleArr[indexPath.row]];
    
    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
        
        if (indexPath.row == 0) {
            cell.infoL.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].surplusLimit floatValue]];
            if ([cell.infoL.text isEqualToString:@""] || [cell.infoL.text rangeOfString:@"null"].location != NSNotFound) {
                cell.infoL.text = @"0";
            }
        }else if (indexPath.row == 1) {
            cell.infoL.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].allLimit floatValue]];
            if ([cell.infoL.text isEqualToString:@""] || [cell.infoL.text rangeOfString:@"null"].location != NSNotFound) {
                cell.infoL.text = @"0";
            }
        }else if (indexPath.row == 2) {
            cell.infoL.text =  [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].mark floatValue]];
            if ([cell.infoL.text isEqualToString:@""] || [cell.infoL.text rangeOfString:@"null"].location != NSNotFound) {
                cell.infoL.text = @"0";
            }
        }else if (indexPath.row == 3){
            cell.infoL.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].loveNum floatValue]];
            if ([cell.infoL.text isEqualToString:@""] || [cell.infoL.text rangeOfString:@"null"].location != NSNotFound) {
                cell.infoL.text = @"0";
            }
        }else if (indexPath.row == 4){
            cell.infoL.text =  [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].ketiBean floatValue]];
            if ([cell.infoL.text isEqualToString:@""]) {
                cell.infoL.text = @"0";
            }
        }else if (indexPath.row == 5){
            cell.infoL.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].recommendMark floatValue]];
            if ([cell.infoL.text isEqualToString:@""]) {
                cell.infoL.text = @"0";
            }
        }else if (indexPath.row == 6){
            cell.infoL.text = [UserModel defaultUser].lastFanLiTime;
            if ([cell.infoL.text isEqualToString:@""]) {
                cell.infoL.text = @"暂无";
            }
        }
        
    }else{
        
        if (indexPath.row == 0) {
            cell.infoL.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].mark floatValue]];
            if ([cell.infoL.text isEqualToString:@""]) {
                cell.infoL.text = @"0";
            }
        }else if (indexPath.row == 1){
            cell.infoL.text =  [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].loveNum floatValue]];
            if ([cell.infoL.text isEqualToString:@""] || [cell.infoL.text rangeOfString:@"null"].location != NSNotFound) {
                cell.infoL.text = @"0";
            }
        }else if (indexPath.row == 2){
            cell.infoL.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].ketiBean floatValue]];
            if ([cell.infoL.text isEqualToString:@""]) {
                cell.infoL.text = @"0";
            }
        }else if (indexPath.row == 3){
            cell.infoL.text = [NSString stringWithFormat:@"%.2f",[[UserModel defaultUser].recommendMark floatValue]];
            if ([cell.infoL.text isEqualToString:@""]) {
                cell.infoL.text = @"0";
            }
        }else if (indexPath.row == 4){
            cell.infoL.text = [UserModel defaultUser].lastFanLiTime;
            if ([cell.infoL.text isEqualToString:@""]) {
                cell.infoL.text = @"暂无";
            }
        }
    }
    
    return cell;
    
    
}

-(UIView*)baseview{
    
    if (!_baseview) {
        
    _baseview=[[UIView alloc]init];
    _baseview.backgroundColor=[UIColor whiteColor];
        
    }
    
    return _baseview;
}



-(UIView*)headview{

    if (!_headview) {
        
        _headview = ({
        
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(20 , 10 + 64 , 90  , 90 )];
            view.backgroundColor=YYSRGBColor(253, 180, 165, 1);
            view.layer.cornerRadius = 45;
            view.clipsToBounds = YES;
            view;
        });
    }

    return _headview;
}

-(UIImageView *)headimage{

    if (!_headimage) {
        _headimage=[[UIImageView alloc]init];
        _headimage.backgroundColor=[UIColor whiteColor];
        _headimage.clipsToBounds = YES;
        _headimage.layer.cornerRadius = 45 -2 ;
        _headimage.contentMode = UIViewContentModeScaleAspectFill;
        _headimage.userInteractionEnabled = YES;
        
    }
    
    return _headimage;

}

-(UIImageView *)backimage{
    
    if (!_backimage) {
        _backimage=[[UIImageView alloc]init];
        _backimage.backgroundColor = [UIColor whiteColor];
        _backimage.contentMode = UIViewContentModeScaleAspectFill;
        _backimage.clipsToBounds = YES;
    }
    
    return _backimage;
    
}

-(UILabel*)namelebel{
    
    if (!_namelebel) {
        _namelebel=[[UILabel alloc]init];
        _namelebel.backgroundColor=[UIColor clearColor];
        _namelebel.textColor=[UIColor whiteColor];
        _namelebel.font=[UIFont systemFontOfSize:12];
        _namelebel.textAlignment=NSTextAlignmentCenter;
        _namelebel.numberOfLines=0;
        [_namelebel sizeToFit];
    }
    return _namelebel;
    
}

-(UILabel*)identitylebel{
    
    if (!_identitylebel) {
        _identitylebel=[[UILabel alloc]init];
        _identitylebel.backgroundColor=[UIColor clearColor];
        _identitylebel.textColor=[UIColor whiteColor];
        _identitylebel.font=[UIFont systemFontOfSize:12];
        _identitylebel.textAlignment=NSTextAlignmentCenter;
        _identitylebel.numberOfLines=0;
        [_identitylebel sizeToFit];
    }
    return _identitylebel;
    
}

-(UILabel*)IDlebel{
    
    if (!_IDlebel) {
        _IDlebel=[[UILabel alloc]init];
        _IDlebel.backgroundColor=[UIColor clearColor];
        _IDlebel.textColor=[UIColor whiteColor];
        _IDlebel.font=[UIFont systemFontOfSize:12];
        _IDlebel.textAlignment=NSTextAlignmentCenter;
        _IDlebel.numberOfLines=0;
        [_IDlebel sizeToFit];
    }
    return _IDlebel;
    
}

-(UITableView*)tableview{
    
    if (!_tableview) {
        _tableview=[[UITableView alloc]init];
        _tableview.backgroundColor=[UIColor clearColor];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.tableFooterView=[UIView new];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.showsVerticalScrollIndicator=NO;
        [_tableview registerNib:[UINib nibWithNibName:@"LBMineCenterinfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterinfoTableViewCell"];
    }
    return _tableview;
}

-(NSArray*)titleArr{

    if (!_titleArr) {
        
        if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
             _titleArr=[NSArray arrayWithObjects:@"剩余额度",@"总额度",@"米券",@"米分",@"米子",@"推荐奖励",@"上个奖励日", nil];
        }else{
            _titleArr=[NSArray arrayWithObjects:@"米券",@"米分",@"米子",@"推荐奖励",@"上个奖励日", nil];
        }
    }
    
    return _titleArr;
    
}

-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
//        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.baseview.frame) + 1, SCREEN_WIDTH, self.frame.size.height - CGRectGetHeight(self.baseview.frame) )
//                                                              delegate:nil
//                                                      placeholderImage:[UIImage imageNamed:@"商家placeholder"]];
        
        _cycleScrollView = [[SDCycleScrollView alloc]init];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"商家placeholder"];
        _cycleScrollView.localizationImageNamesGroup = @[];
        _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.autoScrollTimeInterval = 2;// 自动滚动时间间隔
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = [UIColor groupTableViewBackgroundColor];// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);

    }

    return _cycleScrollView;

}

-(UIVisualEffectView*)ruVisualEffectView{
    if (!_ruVisualEffectView) {
        _ruVisualEffectView = [[UIVisualEffectView alloc]initWithEffect:
                               
                               [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _ruVisualEffectView.alpha = 0.9;
    }
    
    return _ruVisualEffectView;

}
@end
