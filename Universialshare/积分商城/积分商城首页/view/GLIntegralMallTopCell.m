//
//  GLIntegralMallTopCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralMallTopCell.h"
#import "UIImageView+WebCache.h"
#import "GLMallHotModel.h"
@interface GLIntegralMallTopCell ()

@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel2;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel3;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;


@end

@implementation GLIntegralMallTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self changeColor:self.jifenLabel rangeNumber:2666];
    [self changeColor:self.jifenLabel2 rangeNumber:2666];
    [self changeColor:self.jifenLabel3 rangeNumber:2666];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyClick:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyClick:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyClick:)];
    
    self.firstView.tag = 11;
    self.secondView.tag = 12;
    self.thirdView.tag = 13;
    [self.firstView addGestureRecognizer:tap];
    [self.secondView addGestureRecognizer:tap2];
    [self.thirdView addGestureRecognizer:tap3];
    
    self.moreView.tag = 14;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyClick:)];
    [self.moreView addGestureRecognizer:tap4];
    
    self.imageV.layer.cornerRadius = 3;
    self.imageV.clipsToBounds = YES;
    self.imageV2.layer.cornerRadius = 3;
    self.imageV2.clipsToBounds = YES;
    self.imageV3.layer.cornerRadius = 3;
    self.imageV3.clipsToBounds = YES;
    
}

- (NSMutableAttributedString *)changeColor:(UILabel*)label rangeNumber:(NSInteger )rangeNum
{
    NSString *remainBeans = [NSString stringWithFormat:@"%lu",(long)rangeNum];
    NSString *totalStr = [NSString stringWithFormat:@"%@/米券",remainBeans];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSRange rangel = [[textColor string] rangeOfString:remainBeans];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:rangel];
    return textColor;
}

- (void)setModels:(NSArray *)models{
    _models = models;
    if (models.count == 0) {
        self.firstView.hidden = YES;
        self.secondView.hidden = YES;
        self.thirdView.hidden = YES;
    }else if (models.count == 1){
        self.firstView.hidden = NO;
        self.secondView.hidden = YES;
        self.thirdView.hidden = YES;
        GLMallHotModel *model = models[0];
        //        [NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model.mall_url];
        [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model.mall_url]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        _titleLabel.text = model.mall_name;
    }else if (models.count == 2){
        self.firstView.hidden = NO;
        self.secondView.hidden = NO;
        self.thirdView.hidden = YES;
        GLMallHotModel *model = models[0];
        //        [NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model.mall_url];
        [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model.mall_url]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        _titleLabel.text = model.mall_name;
        
        [_jifenLabel setAttributedText:[self changeColor:_jifenLabel rangeNumber:[model.mall_inte integerValue]]];
        
        GLMallHotModel *model2 = models[1];
        [_imageV2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model2.mall_url]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        _titleLabel2.text = model2.mall_name;
    }
   else if (models.count == 3) {
       self.firstView.hidden = NO;
       self.secondView.hidden = NO;
       self.thirdView.hidden = NO;
       
        GLMallHotModel *model = models[0];
//        [NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model.mall_url];
        [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model.mall_url]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        _titleLabel.text = model.mall_name;
        
        [_jifenLabel setAttributedText:[self changeColor:_jifenLabel rangeNumber:[model.mall_inte integerValue]]];
        
        GLMallHotModel *model2 = models[1];
        [_imageV2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model2.mall_url]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        _titleLabel2.text = model2.mall_name;
        
        [_jifenLabel2 setAttributedText:[self changeColor:_jifenLabel rangeNumber:[model2.mall_inte integerValue]]];
        
        GLMallHotModel *model3 = models[2];
        [_imageV3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?x-oss-process=style/miquan",model3.mall_url]] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
        _titleLabel3.text = model3.mall_name;
        
        [_jifenLabel3 setAttributedText:[self changeColor:_jifenLabel rangeNumber:[model3.mall_inte integerValue]]];
    }


}

-(void)classifyClick:(UITapGestureRecognizer*)gesture{

    [self.delegete tapgestureTag:gesture];

}
@end
