//
//  HXChanelVideoListViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-3.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

#define GET_CHANEL_Detail_LIST (@"http://mapi.yinyuetai.com/channel/videos.json")

@interface HXChanelVideoListViewController : UIViewController<MJRefreshBaseViewDelegate>

// 频道的ID号
@property (nonatomic, copy) NSNumber *chanelID;

// 自定义导航栏
@property (nonatomic, strong) UIImageView *navigationBar;

@property (nonatomic, strong) UITableView *playListTableView;

@property (nonatomic, copy) NSString *titleString;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshFooterView *footRefreshView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshHeaderView *headRefreshView;

// 基础视图
@property (nonatomic, strong) MJRefreshBaseView *baseView;

@end
