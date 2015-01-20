//
//  HXVTopListViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

#define GET_VCHART_AREA_LIST (@"http://mapi.yinyuetai.com/vchart/get_vchart_areas.json")

#define GET_VCHART_TREND_LIST (@"http://mapi.yinyuetai.com/vchart/trend.json")

@interface HXVTopListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// 表视图
@property (nonatomic, strong) UITableView *vTopListTableView;

// 地区
@property (nonatomic, strong) UIScrollView *area;

// 工具视图
@property (nonatomic, strong) UIView *toolView;

// 中间标签
@property (nonatomic, strong) UILabel *middleLabel;

// 左按钮
@property (nonatomic, strong) UIButton *leftButton;

// 右按钮
@property (nonatomic, strong) UIButton *rightButton;

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

// 设置表视图
- (void) setVTopListTableView;

// 设置滚动视图
- (void) setArea;

// 设置工具视图
- (void) setToolView;

@end
