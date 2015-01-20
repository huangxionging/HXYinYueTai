//
//  HXSearchViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-7.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

#define GET_SEARCH_LIST (@"http://mapi.yinyuetai.com/search/suggest.json")

#define GET_SEARCH_VIDEO (@"http://mapi.yinyuetai.com/search/video.json")

#define GET_SEARCH_PALYLIST (@"http://mapi.yinyuetai.com/search/playlist.json")

#define GET_SEARCH_ARTIST (@"http://mapi.yinyuetai.com/search/artist.json");

@interface HXSearchViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>

// 顶视图
@property (nonatomic, strong) UIImageView *topView;

// 搜索视图
@property (nonatomic, strong) UIImageView *searchView;

// 搜索框
@property (nonatomic, strong) UITextField *searchBar;

// MV按钮
@property (nonatomic, strong) UIButton *videoButton;

// 悦单
@property (nonatomic, strong) UIButton *playListButton;

// 艺术家
@property (nonatomic, strong) UIButton *artistButton;

// 滚动视图
@property (nonatomic, strong) UIScrollView *searchScrollView;

// 搜索表视图
@property (nonatomic, strong) UITableView *searchTableView;

// 搜索结果表视图
@property (nonatomic, strong) UITableView *searchResultTableView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshFooterView *footRefreshView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshHeaderView *headRefreshView;

// 基础视图
@property (nonatomic, strong) MJRefreshBaseView *baseView;

@end
