//
//  HXSearchModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-7.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  该模型用于存储搜索的信息
 */

#import <Foundation/Foundation.h>

@interface HXSearchModel : NSObject

// 文字
@property (nonatomic, copy) NSString *word;

// 编号
@property (nonatomic, copy) NSNumber *idNumber;

// 类型
@property (nonatomic, copy) NSString *type;

@end
