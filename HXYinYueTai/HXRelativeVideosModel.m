//
//  HXRelativeVideosModel.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-10.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXRelativeVideosModel.h"

@implementation HXRelativeVideosModel

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _videoModel = [[HXVideoModel alloc] init];
        
        _relativeVideos = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
