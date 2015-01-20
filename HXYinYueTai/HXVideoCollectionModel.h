//
//  HXVideoCollectionModel.h
//  HXYinYueTai
//
//  Created by huangxiong on 14/10/21.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HXVideoCollectionModel : NSManagedObject

/**
 *  海报地址
 */
@property (nonatomic, retain) NSString * image;

/**
 *  标题
 */
@property (nonatomic, retain) NSString * title;

/**
 *  艺术家
 */
@property (nonatomic, retain) NSString * artist;

/**
 *  视频地址
 */
@property (nonatomic, retain) NSString * hdurl;

/**
 *  编号
 */
@property (nonatomic, retain) NSString * number;

@end
