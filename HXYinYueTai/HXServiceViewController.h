//
//  HXServiceViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-4.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXServiceViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;

// 网页地址
@property (nonatomic, copy) NSString *url;

// 导航栏标题
@property (nonatomic, copy) NSString *titleString;

// 导航栏
@property (nonatomic, strong) UIImageView *navigationBar;

// 表示是否是modal的
@property (nonatomic, assign) BOOL isModal;

- (void) setNavigationBar;

@end
