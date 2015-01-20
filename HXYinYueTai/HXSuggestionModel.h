//
//  HXSuggestionModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  该模型用于存储首页的推荐视频信息
 */

#import <Foundation/Foundation.h>

@interface HXSuggestionModel : NSObject

// 类型
@property (nonatomic, copy) NSString *type;

// ID 号 是NSNumber类型
@property (nonatomic, copy) NSNumber *idNumber;

// 描述
@property (nonatomic, copy) NSString *descriptionInfo;

// 海报地址
@property (nonatomic, copy) NSString *posterPicture;

// 缩略图
@property (nonatomic, copy) NSString *thumbnailPicture;

// 标题
@property (nonatomic, copy) NSString *title;

// 子类型
@property (nonatomic, copy) NSString *subType;

// 视频地址
@property (nonatomic, copy) NSString *url;

// 平板地址
@property (nonatomic, copy) NSString *hdUrl;

// 超高清hd
@property (nonatomic, copy) NSString *uhdUrl;

// 视频大小
@property (nonatomic, copy) NSNumber *videoSize;

// 平板版本大小
@property (nonatomic, copy) NSNumber *hdVideoSize;

// 超高清hd大小
@property (nonatomic, copy) NSNumber *uhdVideoSize;

// 状态值
@property (nonatomic, copy) NSNumber *status;

// 痕迹地址
@property (nonatomic, copy) NSString *traceUrl;

// 点击地址
@property (nonatomic, copy) NSString *clickUrl;

@end
