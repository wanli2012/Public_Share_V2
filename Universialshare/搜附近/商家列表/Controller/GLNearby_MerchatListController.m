//
//  GLNearby_MerchatListController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLNearby_MerchatListController.h"
#import "GLNearby_MerchatListCell.h"
#import "GLSet_MaskVeiw.h"
#import "GLHomeLiveChooseController.h"

@interface GLNearby_MerchatListController ()<UITableViewDataSource,UITableViewDelegate>
{
    GLSet_MaskVeiw *_maskV;
    UIView *_contentView;
    GLHomeLiveChooseController *_chooseVC;
    
    UIButton *_tmpBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *classifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

static NSString *ID = @"GLNearby_MerchatListCell";
@implementation GLNearby_MerchatListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商家列表";
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.topView convertRect:self.topView.bounds toView:window];
    
    _chooseVC = [[GLHomeLiveChooseController alloc] init];
    //    _chooseVC.view.frame = CGRectZero;
    _chooseVC.view.frame = CGRectMake(0,0, SCREEN_WIDTH, 0);
    _contentView = _chooseVC.view;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 4;
    _contentView.layer.masksToBounds = YES;
    
    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(rect), SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    _maskV.contentView = _contentView;
    _maskV.bgView.alpha = 0.1;
    
    [_maskV showViewWithContentView:_contentView];
    _maskV.alpha = 0;

    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_maskV removeFromSuperview];
}
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        _maskV.alpha = 0;
        
    }];
    [self.cityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.classifyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.sortBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.cityBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    self.classifyBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    self.sortBtn.imageView.transform = CGAffineTransformMakeRotation(0);

 
}
//选择
- (IBAction)choose:(UIButton *)sender {
    
    if (_maskV.alpha == 0) {
        sender.selected = NO;
    }
    
    _maskV.alpha = 1;
    
    [self.cityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.classifyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.sortBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    self.cityBtn.selected = NO;
    self.classifyBtn.selected = NO;
    self.sortBtn.selected = NO;
    sender.selected = YES;
    
    self.cityBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    self.classifyBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    self.sortBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    
    switch (sender.tag) {
        case 10:
        {
            _chooseVC.dataSource = @[@"22",@"dd",@"22",@"dd",@"22",@"dd",@"22",@"dd",@"22",@"dd"];
         
        }
            break;
        case 11:
        {
            _chooseVC.dataSource = @[@"22",@"dd"];
        }
            break;
        case 12:
        {
            _chooseVC.dataSource = @[@"22",@"dd",@"22",@"dd"];
        }
            break;
            
        default:
            break;
    }
    
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
                        if (_chooseVC.dataSource.count < 8) {
                _chooseVC.view.yy_height = _chooseVC.dataSource.count * 44;
            }else{
                _chooseVC.view.yy_height = SCREEN_HEIGHT * 0.5;
            }

        }];

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            
            _chooseVC.view.yy_height = 0;
            
        } completion:^(BOOL finished) {
            
            _maskV.alpha = 0;
        }];

    }
    
    
    [_chooseVC.tableView reloadData];
}
#pragma UITableviewDelegate UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 8;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLNearby_MerchatListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

@end
