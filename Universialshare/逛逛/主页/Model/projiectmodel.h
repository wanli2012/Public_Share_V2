//
//  projiectmodel.h
//  AngelComing
//
//  Created by sm on 16/10/11.
//  Copyright © 2016年 ruichikeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface projiectmodel : NSObject
@property(nonatomic,strong)FMDatabase *dataBase;
//创建表
+(projiectmodel *)greateTableOfFMWithTableName:(NSString *)tableName;
//插入数据
-(void)insertOfFMWithDataArray:(NSArray*)dataArr;
//删除数据
-(void)deleteAllDataOfFMDB;
//查询数据
-(NSArray*)queryAllDataOfFMDB;
//判断表中是否存在数据
-(BOOL)isDataInTheTable;
@end
