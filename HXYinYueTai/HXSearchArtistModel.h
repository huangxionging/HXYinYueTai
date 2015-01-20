//
//  HXSearchArtistModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-9.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  该模型用于存储搜索结果艺术家的信息
 */

#import "HXArtistModel.h"

@interface HXSearchArtistModel : HXArtistModel

// 绰号
@property (nonatomic, copy) NSString *aliasName;

// 头像
@property (nonatomic, copy) NSString *smallAvatar;

// 区域
@property (nonatomic, copy) NSString *area;

// MV数量
@property (nonatomic, copy) NSNumber *videoCount;

// 粉丝总数
@property (nonatomic, copy) NSNumber *fanCount;

// 订阅总数
@property (nonatomic, copy) NSNumber *subCount;

// 是否已订阅
@property (nonatomic, copy) NSNumber *isSub;

@end
