//
//  HXArtistModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-1.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  该模型用于存储艺术家的信息
 */

#import <Foundation/Foundation.h>

@interface HXArtistModel : NSObject

// 明星编号
@property (nonatomic, copy) NSNumber *artistId;

// 明星名字
@property (nonatomic, copy) NSString *artistName;

@end
