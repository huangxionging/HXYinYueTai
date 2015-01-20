//
//  HXCreatorModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-6.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//
/**
 *  该模型用于存储创建悦单者的信息
 */

#import <Foundation/Foundation.h>

@interface HXCreatorModel : NSObject

// 用户id
@property (nonatomic, copy) NSNumber *userID;

// 昵称
@property (nonatomic, copy) NSString *nickName;

// 小头像
@property (nonatomic, copy) NSString *smallAvatar;

// 大图
@property (nonatomic, copy) NSString *largeAvatar;


@end
