//
//  HXServiceViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-4.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXServiceViewController.h"

#define TITLE_WIDTH (200)

@interface HXServiceViewController ()

@end

@implementation HXServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    // 发送隐藏导航栏通知
    [[NSNotificationCenter defaultCenter] postNotificationName: HIDE_NAVIGATION_BAR  object: nil];
    
    // 发送隐藏tabBar通知
    [[NSNotificationCenter defaultCenter] postNotificationName: HIDE_TAB_BAR object: nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview: _webView];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString: _url]];
    [_webView loadRequest: request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---设置导航栏
- (void) setNavigationBar
{
    // 初始化
    _navigationBar = [[UIImageView alloc] initWithFrame: CGRectMake(0, 20, self.view.frame.size.width, 44)];
    
    [self.view addSubview: _navigationBar];
    
    // 允许交互
    _navigationBar.userInteractionEnabled = YES;
    
    // 图片
    _navigationBar.image = [UIImage imageNamed: @"navigationBar"];
    
    // 在导航栏上放置返回按钮
    
    UIButton *back = [UIButton buttonWithType: UIButtonTypeCustom];
    
    // 设置按钮大小
    back.frame = CGRectMake(0, 0, 44, 44);
    
    // 设置图片
    [back setBackgroundImage: [UIImage imageNamed: @"back_btn"] forState: UIControlStateNormal];
    
    [back setBackgroundImage: [UIImage imageNamed: @"back_btn_p"] forState: UIControlStateHighlighted];
    
    // 添加事件
    [back addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    
    [_navigationBar addSubview: back];
    
    // 添加Label设置标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake((_navigationBar.frame.size.width - TITLE_WIDTH) / 2, 0, TITLE_WIDTH, 44)];
    // 字体颜色
    titleLabel.textColor = [UIColor whiteColor];
    // 排版
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _titleString;
    [_navigationBar addSubview: titleLabel];
}

#pragma mark---返回按钮事件
- (void) back
{
    if (_isModal == YES)
    {
        [self dismissViewControllerAnimated: YES completion: nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated: NO];
    }
}

- (BOOL) shouldAutorotate
{
    return NO;
}

@end
