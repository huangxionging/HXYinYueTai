//
//  HXVChartModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-5.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  该模型用于存储V榜信息
 */

#import <Foundation/Foundation.h>

@interface HXVChartModel : NSObject

// 排名分数
@property (nonatomic, copy) NSString *rank;

// ID 号 是NSNumber类型
@property (nonatomic, copy) NSNumber *idNumber;

// 描述
@property (nonatomic, copy) NSString *descriptionInfo;

// 艺术家数组，存放艺术家的信息
@property (nonatomic, strong) NSMutableArray *artists;

// 艺术家名字
@property (nonatomic, strong) NSString *artistName;

// 海报地址
@property (nonatomic, copy) NSString *posterPicture;

// 缩略图
@property (nonatomic, copy) NSString *thumbnailPicture;

// 专辑图片地址
@property (nonatomic, copy) NSString *albumImage;

// 标题
@property (nonatomic, copy) NSString *title;

// 视频地址
@property (nonatomic, copy) NSString *url;

// 平板地址
@property (nonatomic, copy) NSString *hdUrl;

// 非hd地址
@property (nonatomic, copy) NSString *uhdUrl;

// super hd
@property (nonatomic, copy) NSString *shdUrl;

// 视频大小
@property (nonatomic, copy) NSNumber *videoSize;

// 平板版本大小
@property (nonatomic, copy) NSNumber *hdVideoSize;

// 超高清hd版本大小
@property (nonatomic, copy) NSNumber *uhdVideoSize;

// 超清
@property (nonatomic, copy) NSNumber *shdVideoSize;

// 状态值
@property (nonatomic, copy) NSNumber *status;

// 持续时间
@property (nonatomic, copy) NSString *duration;

// 悦单地址
@property (nonatomic, copy) NSString *playListPicture;

// 短片标题
@property (nonatomic, copy) NSNumber *score;

- (id) init;

@end
