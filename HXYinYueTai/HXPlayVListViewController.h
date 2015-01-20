//
//  HXPlayVListViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-10.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXVideoView.h"
#import "MJRefresh.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

// huodu
#define GET_VIDEO_RELATIVE (@"http://mapi.yinyuetai.com/video/show.json")

#define GET_VIDEO_COMMENT (@"http://mapi.yinyuetai.com/video/comment/list.json")

@interface HXPlayVListViewController : UIViewController

// 自定义导航栏
@property (nonatomic, strong) UIImageView *navigationBar;

// 标题
@property (nonatomic, copy) NSString *titleString;

// 编号
@property (nonatomic, copy) NSNumber *idNumber;

// 播放的动画
@property (nonatomic, strong) FLAnimatedImageView *animation;

// 视频视图
@property (nonatomic, strong) HXVideoView *videoView;

// 暂停按钮
@property (nonatomic, strong) UIButton *playOrStopButton;

// 滚动条
@property (nonatomic, strong) UISlider *progressSlider;

// 当前时间
@property (nonatomic, strong) UILabel *currentTime;

// 总时间
@property (nonatomic, strong) UILabel *totalTime;

// 工具视图
@property (nonatomic, strong) UIView *toolView;

// 自定义线程
@property (nonatomic, retain) dispatch_queue_t customQueue;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

// 滚动视图
@property (nonatomic, strong) UIScrollView *playScrollView;

// 描述
@property (nonatomic, strong) UIButton *descriptionInfo;

// 评论
@property (nonatomic, strong) UIButton *comment;

// 相关MV
@property (nonatomic, strong) UIButton *relate;

@property (nonatomic, strong) UIScrollView *leftScrollView;

@property (nonatomic, strong) UITableView *middleTableView;

@property (nonatomic, strong) UITableView *rightTableView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshFooterView *footRefreshView;

// 下拉刷新视图
@property (nonatomic, strong) MJRefreshHeaderView *headRefreshView;

// 基础视图
@property (nonatomic, strong) MJRefreshBaseView *baseView;

@end
