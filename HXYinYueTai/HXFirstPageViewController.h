//
//  HXFirstPageViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

// 获取推荐接口
#define GET_SUGGESTIONS (@"http://mapi.yinyuetai.com/suggestions/front_page.json")

// 获取视频列表接口
#define GET_VIDEO_LIST (@"http://mapi.yinyuetai.com/video/list.json")

// 获取猜你喜欢视频接口
#define GET_VIDEO_GUESS (@"http://mapi.yinyuetai.com/video/guess.json")

@interface HXFirstPageViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

// 表视图
@property (nonatomic, strong) UITableView *homePageTableView;

// 头视图
@property (nonatomic, strong) UIView *headView;

// 滚动视图
@property (nonatomic, strong) UIScrollView *homePageScrollView;

// 分页控件
@property (nonatomic, strong) UIPageControl *homePageControl;

// 子头视图
@property (nonatomic, strong) UIView *subHeadView;

// 子头视图按钮
@property (nonatomic, strong) UIButton *subHeadViewButton;

// 子头视图上的imageView;
@property (nonatomic, strong) UIImageView *subHeadImageView;

// 标题
@property (nonatomic, strong) UILabel *labelTitle;

// 描述
@property (nonatomic, strong) UILabel *labelDescription;

// 自定义线程
@property (nonatomic, strong) dispatch_queue_t customQueue;

// 行数
@property (nonatomic, assign) NSInteger row;


// 设置表视图
- (void) setHomePageTableView;

// 设置头视图
- (void) setHeadView;

// 设置滚动视图
- (void) setHomePageScrollView;

// 设置子头视图
- (void) setSubHeadView;

// 设置分页控件
- (void) setHomePageControl;

// 子头视图按钮
- (void) setSubHeadViewButton;

// 子头视图上的imageView
- (void) setSubHeadImageView;

// 设置标题和描述
- (void) setTitleAndDescription;

@end
