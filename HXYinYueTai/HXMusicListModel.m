//
//  HXMusicListModel.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-6.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXMusicListModel.h"

@implementation HXMusicListModel

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _creator = [[HXCreatorModel alloc] init];
    }
    
    return self;
}

@end
