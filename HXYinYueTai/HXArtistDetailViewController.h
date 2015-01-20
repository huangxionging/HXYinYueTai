//
//  HXArtistDetailViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-13.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSearchArtistModel.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "HXArtistCell.h"

#define TITLE_WIDTH (200)

// 按钮宽度
#define BUTTON_WIDTH (101)

// 按钮高度
#define BUTTON_HEIGHT (30)

#define GET_ARTIST_DETAIL (@"http://mapi.yinyuetai.com/video/list_by_artist.json")

@interface HXArtistDetailViewController : UIViewController<MJRefreshBaseViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) HXSearchArtistModel *artistModel;

// 艺人详情
@property (nonatomic, strong) UITableView *ArtistTableView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshFooterView *footRefreshView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshHeaderView *headRefreshView;

// 基础视图
@property (nonatomic, strong) MJRefreshBaseView *baseView;

@property (nonatomic, strong) UIImageView *navigationBar;

// 网络请求管理器
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, weak) HXArtistCell *artistView;

@end