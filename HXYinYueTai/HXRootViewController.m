//
//  HXRootViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-30.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXRootViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "HXNetWork.h"



@interface HXRootViewController () <UIScrollViewDelegate>

@end

@implementation HXRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // 开始页
    _startImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _startImageView.image = [UIImage imageNamed: @"DefaultLaunch"];
    [self.view addSubview: _startImageView];
    
    // 创建并行线程
    _customQueue = dispatch_queue_create("HXYinYueTai", DISPATCH_QUEUE_CONCURRENT);
    
    // 若是第一次使用应用程序 则打开指导页
    if ([[NSUserDefaults standardUserDefaults] objectForKey: FIRST_USE] == nil)
    {
        // 保存使用状态
        [[NSUserDefaults standardUserDefaults] setObject: FIRST_USE forKey: FIRST_USE];
        
        // 强制同步
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self setGuideScrollView];
        
        [self setPageControl];
    }
    else
    {
#pragma mark---获取访问服务器时间和unikey和开始页面的地址
        dispatch_async(_customQueue, ^
       {
           AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
           
           NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString: GET_START] cachePolicy: 0 timeoutInterval: 5];
           
           [manager HTTPRequestOperationWithRequest: request success:^(AFHTTPRequestOperation *operation, id responseObject)
           {
               
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
               
           }];
           
           // 获取开始页面
           [manager GET: GET_START  parameters: @{ @"deviceinfo": DEVICEINFO}
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                _startHttp = responseObject[@"imageUrl"];
                [_startImageView setImageWithURL: [NSURL URLWithString: _startHttp]];
                [NSTimer scheduledTimerWithTimeInterval: 3.0 target: self selector: @selector(enterApp) userInfo: nil repeats: NO];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                // 网络访问失败
                [NSTimer scheduledTimerWithTimeInterval: 0.0 target: self selector: @selector(enterApp) userInfo: nil repeats: NO];
                NSLog(@"%@", error);
            }];
           
           // 获取访问时间
           [manager GET: GET_TIME  parameters: @{@"deviceInfo": DEVICEINFO}
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"访问时间是%@", responseObject[@"time"]);
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
            }];
           
           // 获取唯一的key
           [manager GET: GET_UNIKEY  parameters: @{ @"deviceinfo": DEVICEINFO, @"s": @"4416a82d8048d9824b3ed7b54917f3d2"}  success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                _unikey = responseObject[@"unikey"];
                
                NSLog(@"%@", _unikey);
            }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
            }];
       });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---设置指导页
- (void) setGuideScrollView
{
    _guideScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    _guideScrollView.contentSize = CGSizeMake(_guideScrollView.frame.size.width *4, 0);
    _guideScrollView.backgroundColor = [UIColor lightGrayColor];
    _guideScrollView.pagingEnabled = YES;                           // 分页显示
    _guideScrollView.bounces = NO;                                  // 分页显示
    _guideScrollView.delegate = self;                               // 设置代理
    
    for (NSInteger index = 0; index < 4; ++index)
    {
        UIImageView *imageGuide = [[UIImageView alloc] initWithFrame: CGRectMake(index * _guideScrollView.frame.size.width, 0, _guideScrollView.frame.size.width, _guideScrollView.frame.size.height)];
        
        // 知道页图片
        imageGuide.image = [UIImage imageNamed: [NSString stringWithFormat: @"GuideIphone5_%ld", (long) index + 1]];
        [_guideScrollView addSubview: imageGuide];
        
    }
    
    // 按钮
    UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(3 * _guideScrollView.frame.size.width, _guideScrollView.frame.size.height - 114, _guideScrollView.frame.size.width,  114)];
    [button addTarget: self action: @selector(enterApp) forControlEvents: UIControlEventTouchUpInside];
    [_guideScrollView addSubview: button];
    [self.view addSubview: _guideScrollView];
}

#pragma mark---进入主应用界面enterApp
- (void) enterApp
{
    if (_guideScrollView != nil)
    {
        [_guideScrollView removeFromSuperview];
        [_pageControl removeFromSuperview];
    }
    [_startImageView removeFromSuperview];                          // 将开始页移除
    
    // 创建TabBarController
    _tabBarController = [[HXTabBarController alloc] init];
    
    // 模态出标签导航控制器
    [self presentViewController: _tabBarController animated: NO completion:^
    {
        NSLog(@"切换控制器成功");
    }];
}

#pragma mark---设置分页控件

- (void) setPageControl
{
    // 分页控件初始化
    _pageControl = [[UIPageControl alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - 20, self.view.frame.size.width, 20)];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    _pageControl.numberOfPages = 4;
    [_pageControl addTarget: self action: @selector(pageChanged:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview: _pageControl];
}

// 分页控件事件响应
- (void) pageChanged: (UIPageControl *)sender
{
    _guideScrollView.contentOffset = CGPointMake(sender.currentPage * _guideScrollView.frame.size.width, 0);
}

#pragma mark---UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark---禁止横屏
- (BOOL) shouldAutorotate
{
    return NO;
}

#pragma mark---析构函数
- (void) dealloc
{
    // 移除展示导航栏通知
    [[NSNotificationCenter defaultCenter] removeObserver: self name: SHOW_NAVIGATION_BAR object: nil];
    
    // 移除隐藏导航栏通知
    [[NSNotificationCenter defaultCenter] removeObserver: self name: HIDE_NAVIGATION_BAR object: nil];
    
    // 移除展示TabBar通知
    [[NSNotificationCenter defaultCenter] removeObserver: self name: SHOW_TAB_BAR object: nil];
    
    // 移除TabBar隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver: self name: HIDE_TAB_BAR object: nil];
}

@end


