//
//  HXChanelModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-3.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  该模型用于存频道信息
 */

#import <Foundation/Foundation.h>

@interface HXChanelModel : NSObject

// 类型
@property (nonatomic, copy) NSString *type;

// 编号
@property (nonatomic, copy) NSNumber *chanelID;

// 标题
@property (nonatomic, copy) NSString *title;

// 图片地址
@property (nonatomic, copy) NSString *imageUrl;

// 标记
@property (nonatomic, copy) NSString *flag;


@end
