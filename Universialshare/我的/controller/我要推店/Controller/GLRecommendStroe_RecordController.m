//
//  GLRecommendStroe_RecordController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/5/17.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRecommendStroe_RecordController.h"
#import "GLRecommendStore_RecordCell.h"
#import "GLRecommendStroe_RecordDateCell.h"

#import "JXAlertview.h"
#import "CustomDatePicker.h"


@interface GLRecommendStroe_RecordController ()<CustomAlertDelegete>
{
    CustomDatePicker *_Dpicker;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;

@end

static NSString *ID = @"GLRecommendStore_RecordCell";
//static NSString *ID2 = @"GLRecommendStroe_RecordDateCell";
@implementation GLRecommendStroe_RecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.queryBtn.layer.cornerRadius = 5.f;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"推店记录";
    [self.tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
//    [self.collectionView registerNib:[UINib nibWithNibName:ID2 bundle:nil] forCellWithReuseIdentifier:ID2];
}

- (IBAction)monthChoose:(id)sender {
    
    //闰年非闰年都做了判断 年份取得是当前年份的前后三十年，大家也可自行按照自己需求自行修改
    _Dpicker = [[CustomDatePicker alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width-20, 200)];
    JXAlertview *alert = [[JXAlertview alloc] initWithFrame:CGRectMake(10, (self.view.frame.size.height-260)/2, self.view.frame.size.width-20, 260)];

    alert.delegate = self;
    [alert initwithtitle:@"请选择月份" andmessage:@"" andcancelbtn:@"取消" andotherbtn:@"确定"];
    
    //我把Dpicker添加到一个弹出框上展现出来 当然大家还是可以以任何其他动画形式展现
    [alert addSubview:_Dpicker];
    [alert show];

}
-(void)btnindex:(int)index :(int)tag
{
    if (index == 2) {
        self.monthLabel.textColor = [UIColor blackColor];
        self.monthLabel.text = [NSString stringWithFormat:@"%d年%d月",_Dpicker.year,_Dpicker.month];
       
    }
}

- (IBAction)query:(id)sender {
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLRecommendStore_RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = 0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.estimatedRowHeight = 11;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
//    GLRecommendStore_RecordCell *consumerVC = [[GLRecommendStore_RecordCell alloc] init];
//    [self.navigationController pushViewController:consumerVC animated:YES];
}

//#pragma UICollectionViewDelegate UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    
//    return 24;
//}
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    GLRecommendStroe_RecordDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID2 forIndexPath:indexPath];
////    cell.backgroundColor = [UIColor redColor];
//
//    return cell;
//    
//}
////定义每个UICollectionViewCell 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(100, 50);
//}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    GLRecommendStroe_RecordDateCell *cell = (GLRecommendStroe_RecordDateCell *) [collectionView cellForItemAtIndexPath:indexPath];
//    cell.bgView.backgroundColor = [UIColor greenColor];
//    
//}
@end
