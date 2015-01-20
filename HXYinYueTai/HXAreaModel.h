//
//  HXAreaModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-4.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  该模型用于存储区域信息
 */

#import <Foundation/Foundation.h>

@interface HXAreaModel : NSObject

// 区域名字
@property (nonatomic, copy) NSString *arearName;

// 区域代码
@property (nonatomic, copy) NSString *code;

@end
