//
//  HXMainDataBase.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-9-2.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXMainDataBase.h"

static  HXMainDataBase* database = nil;


@implementation HXMainDataBase

+ (instancetype) shareDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
                      
        database = [[HXMainDataBase alloc] init];
    });
    
    return database;
}

- (FMDatabaseQueue *)databaseQueue
{
    return _fmDatabaseQueue;
}

- (id) init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        NSLog(@"%@", database);
        database = [super init];
      if (database != nil)
      {
          NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/Main.db"];
          
          NSLog(@"path is %@",dbPath);
          
          _fmDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath: dbPath];
          
      }
      [database close];
    });
    return database;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    if (database == nil)
    {
        database = [super allocWithZone:zone];
    }
    
    return database;
}

- (void) open
{
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         if ([db open] == NO)
         {
             NSLog(@"打开失败");
         }
     }];
}

- (void) close
{
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         if ([db close] == NO)
         {
             NSLog(@"关闭失败");
         }
     }];
}

#pragma mark---清空表
- (void) clearTableWithName:(NSString *)tableName
{
    [self open];
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat: @"delete from %@", tableName];
         if (![db executeUpdate: sqlString])
         {
             NSLog(@"清空表失败");
         }
     }];
    
    [self close];
}

#pragma mark---删除表
- (void) deleteTableWithName:(NSString *)tableName
{
    [self open];
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat: @"drop table %@", tableName];

         if (![db executeUpdate: sqlString])
         {
             NSLog(@"删除失败");
         }
     }];
    [self close];
}




@end