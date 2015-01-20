//
//  HXMusicListViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"


#define GET_PLAY_LIST (@"http://mapi.yinyuetai.com/playlist/list.json")

@interface HXMusicListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// 精选
@property (nonatomic, strong) UIButton *choiceButton;

// 热门
@property (nonatomic, strong) UIButton *hotButton;

// 最新
@property (nonatomic, strong) UIButton *newsButton;

@property (nonatomic, strong) UITableView *musicListTableView;

// 自定义线程
@property (nonatomic, retain) dispatch_queue_t customQueue;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshFooterView *footRefreshView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshHeaderView *headRefreshView;

// 基础视图
@property (nonatomic, strong) MJRefreshBaseView *baseView;

// 设置按钮
- (void) setChoiceButton;

- (void) setHotButton;

- (void) setNewButton;

- (void) setMusicListTableView;

@end
