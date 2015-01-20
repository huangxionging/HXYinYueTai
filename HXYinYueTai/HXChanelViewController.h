//
//  HXChanelViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

// 获取频道列表
#define GET_CHANEL_LIST (@"http://mapi.yinyuetai.com/recommend/video/aggregation.json")

@interface HXChanelViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// 表视图
@property (nonatomic, strong) UITableView *chanelTableView;

// 自定义线程
@property (nonatomic, retain) dispatch_queue_t customQueue;

// 设置表视图
- (void) setChanelTableView;

@end
