//
//  HXTabBarController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-2.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXTabBarController : UITabBarController

// 自定义TabBar 是ImageView
@property (nonatomic, strong) UIImageView *customTabBar;

// 自定义NavigationBar 也是一章ImageView
@property (nonatomic, strong) UIImageView *customNavigationBar;

// 是否可以旋转
@property (nonatomic, assign) BOOL isRotate;

// 设置自定义TabBar
- (void) setCustomTabBar;

// 自定义导航栏
- (void) setCustomNavigationBar;

// 展示TabBar
- (void) showTabBar;

// 隐藏TabBar
- (void) hideTabBar;

// 禁止横屏
- (BOOL) shouldAutorotate;

@end
