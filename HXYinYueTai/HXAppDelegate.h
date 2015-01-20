//
//  HXAppDelegate.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-30.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface HXAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

// 被管理的设备环境
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// 被管理的对象
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

// 持久化
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void) saveContext;

- (NSURL *)applicationDocumentsDirectory;

@end
