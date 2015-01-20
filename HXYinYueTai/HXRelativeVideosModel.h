//
//  HXRelativeVideosModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-10.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  该模型用于存储相关视频的信息
 */

#import <Foundation/Foundation.h>
#import "HXVideoModel.h"

@interface HXRelativeVideosModel : NSObject

// 视频模型
@property (nonatomic, strong) HXVideoModel *videoModel;

// 日期
@property (nonatomic, copy) NSString *regdate;

// 视频总数
@property (nonatomic, copy) NSNumber *totalViews;

// 总评论
@property (nonatomic, copy) NSNumber *totalComments;

// 相关视频
@property (nonatomic, strong) NSMutableArray *relativeVideos;

- (id) init;

@end
