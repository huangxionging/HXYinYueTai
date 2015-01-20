//
//  HXMainDataBase.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-9-2.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface HXMainDataBase : NSObject
{
    FMDatabaseQueue *_fmDatabaseQueue;
}

// 通过单例访问
+ (id) shareDatabase;

// 获取数据库队列
- (FMDatabaseQueue *)databaseQueue;

- (void) open;

- (void) close;

// 清空表
- (void) clearTableWithName: (NSString *)tableName;

// 删除表
- (void) deleteTableWithName: (NSString *)tableName;

@end
