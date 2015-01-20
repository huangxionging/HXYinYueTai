//
//  HXRootViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-30.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXTabBarController.h"

// 第一次使用
#define FIRST_USE (@"fisrt")

// 获取时间接口
#define GET_TIME (@"http://mapi.yinyuetai.com/common/time.json?")

// 获取唯一时间
#define GET_UNIKEY (@"http://mapi.yinyuetai.com/product/getUnikey.json")

// 获取开始页地址
#define GET_START (@"http://mapi.yinyuetai.com/mv/get_start.json")

@interface HXRootViewController : UIViewController

// 指导页
@property (nonatomic, strong) UIScrollView *guideScrollView;

// 分页控件
@property (nonatomic, strong) UIPageControl *pageControl;

// 自定义线程
@property (nonatomic, strong) dispatch_queue_t customQueue;

// 开始页图像
@property (nonatomic, strong) UIImageView *startImageView;

// 标签导航控制器
@property (nonatomic, strong) HXTabBarController *tabBarController;



// 访问服务器时间
@property (nonatomic, copy) NSString *time;

// 获取每次访问的key
@property (nonatomic, copy) NSString *unikey;

// 开始页地址
@property (nonatomic, copy) NSString *startHttp;

// 设置指导页
- (void) setGuideScrollView;

// 设置分页控件
- (void) setPageControl;

// 分页控件响应
- (void) pageChanged: (UIPageControl *)sender;

// 进入应用程序
- (void) enterApp;

@end




