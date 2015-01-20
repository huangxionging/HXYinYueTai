//
//  HXMoreViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-14.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

// 获取区域
#define GET_AREA (@"http://mapi.yinyuetai.com/video/get_mv_areas.json")

// 获取视频列表接口
#define GET_VIDEO_LIST (@"http://mapi.yinyuetai.com/video/list.json")

@interface HXMoreViewController : UIViewController

// 表视图
@property (nonatomic, strong) UITableView *moreTableView;

// 地区
@property (nonatomic, strong) UIScrollView *area;

// 自定义线程
@property (nonatomic, retain) dispatch_queue_t customQueue;

// 用于记录滚动视图的位置
@property (nonatomic, assign) CGFloat currentLocal;

// 启用定时器监测滚动视图
@property (nonatomic, strong) NSTimer *timer;

// 当前处于亮状态的值
@property (nonatomic, assign) NSInteger currentHighlight;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshFooterView *footRefreshView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshHeaderView *headRefreshView;

// 基础视图
@property (nonatomic, strong) MJRefreshBaseView *baseView;

// 表示在数组中的关系
@property (nonatomic, copy) NSString *parameter;

// 标题
@property (nonatomic, copy) NSString *titleString;


@end
