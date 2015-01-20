//
//  HXMusicListModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-6.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  该模型用于存储悦单信息
 */

#import <Foundation/Foundation.h>
#import "HXCreatorModel.h"

@interface HXMusicListModel : NSObject

// 编号
@property (nonatomic, copy) NSNumber *idNumber;

// 标题
@property (nonatomic, copy) NSString *title;

// 缩略图
@property (nonatomic, copy) NSString *thumbnailPicture;

// 悦单地址
@property (nonatomic, copy) NSString *playListPicture;

// 悦单地址 大图
@property (nonatomic, copy) NSString *playListBigPicture;

// MV数量
@property (nonatomic, copy) NSNumber *videoCount;

// mv数量这几个字的长度
@property (nonatomic, assign) NSInteger videoLabelWidth;

// 描述信息
@property (nonatomic, copy) NSString *descriptionInfo;

// 分类
@property (nonatomic, copy) NSString *category;

// 创建者
@property (nonatomic, copy) HXCreatorModel *creator;

// 状态
@property (nonatomic, copy) NSNumber *status;

// 视频总数
@property (nonatomic, copy) NSNumber *totalViews;

// 总喜欢数
@property (nonatomic, copy) NSNumber *totalFavorites;

// 更新时间
@property (nonatomic, copy) NSString *updateTime;

// 创建时间
@property (nonatomic, copy) NSString *createTime;

// 总积分
@property (nonatomic, copy) NSNumber *integral;

// 周积分
@property (nonatomic, copy) NSNumber *weekIntegral;

// 总用户数
@property (nonatomic, copy) NSNumber *totalUser;

// 排名
@property (nonatomic, copy) NSNumber *rank;

- (id) init;

@end
