//
//  HXVideoCommentModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-11.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  该模型用于存储视频的评论信息
 */

#import <Foundation/Foundation.h>

@interface HXVideoCommentModel : NSObject

// 评论ID
@property (nonatomic, copy) NSNumber *commentID;

// 评论内容
@property (nonatomic, copy) NSString *content;

// 内容高度
@property (nonatomic, assign) NSInteger contentHeight;

// 楼数
@property (nonatomic, copy) NSNumber *floorInt;

// 楼
@property (nonatomic, copy) NSString *floor;

// 用户编号
@property (nonatomic, copy) NSNumber *userID;
// 用户名
@property (nonatomic, copy) NSString *userName;

// 用户头像
@property (nonatomic, copy) NSString *headImage;

// 创建时间
@property (nonatomic, copy) NSString *dateCreated;



@end
