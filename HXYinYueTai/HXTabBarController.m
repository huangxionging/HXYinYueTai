//
//  HXTabBarController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-2.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXTabBarController.h"
#import "HXFirstPageViewController.h"
#import "HXChanelViewController.h"
#import "HXMyMusicViewController.h"
#import "HXVTopListViewController.h"
#import "HXMusicListViewController.h"
#import "HXServiceViewController.h"
#import "HXSearchViewController.h"
#import "HXNavigationController.h"

@interface HXTabBarController ()

@end

@implementation HXTabBarController

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
    
    // 注册展示展示导航栏通通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showNavigationBar) name: SHOW_NAVIGATION_BAR object: nil];
    
    // 注册展示展示导航栏通通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hideNavigationBar) name: HIDE_NAVIGATION_BAR object: nil];
    
    // 注册展示TabBar通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showTabBar) name: SHOW_TAB_BAR object: nil];
    
    // 注册隐藏TabBar通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hideTabBar) name: HIDE_TAB_BAR object: nil];
    
    [self setViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setViewController
{
    // 创建UITabBarViewController
    [self setCustomTabBar];
    [self setCustomNavigationBar];
    
    // 首先是首页
    HXFirstPageViewController *firstPageViewController = [[HXFirstPageViewController alloc] init];
    
    HXNavigationController *first = [[HXNavigationController alloc] initWithRootViewController: firstPageViewController];
    
    // 其次是频道
    HXChanelViewController *chanelViewController = [[HXChanelViewController alloc] init];
    
    HXNavigationController *chanel = [[HXNavigationController alloc] initWithRootViewController: chanelViewController];
    
    // 然后我的音悦
    HXMyMusicViewController *myMusicViewController = [[HXMyMusicViewController alloc] init];
    
    HXNavigationController *myMusic = [[HXNavigationController alloc] initWithRootViewController: myMusicViewController];
    
    // 再是V榜
    HXVTopListViewController *vTopListViewContoller = [[HXVTopListViewController alloc] init];
    
    HXNavigationController *vTopList = [[HXNavigationController alloc] initWithRootViewController: vTopListViewContoller];
    
    // 最后是悦单
    HXMusicListViewController *musicListViewController = [[HXMusicListViewController alloc] init];
    
    HXNavigationController *musicList = [[HXNavigationController alloc] initWithRootViewController: musicListViewController];

    
    first.navigationBar.hidden = YES;
    chanel.navigationBar.hidden = YES;
    vTopList.navigationBar.hidden = YES;
    musicList.navigationBar.hidden = YES;
    
    self.viewControllers = @[first, chanel, myMusic, vTopList, musicList];
}

#pragma mark---设置自定义TabBar
- (void) setCustomTabBar
{
    // 标记
    NSInteger TAG = 100;
    
    // 定制TabBar
    _customTabBar = [[UIImageView alloc] initWithFrame: self.tabBar.frame];
    _customTabBar.userInteractionEnabled = YES;
    _customTabBar.image = [UIImage imageNamed: @"BottomBar_Icon"];
    [self.view addSubview: _customTabBar];
    
    // 在自定义TabBar上放置按钮
    NSArray *buttonImageNames = @[@[@"Bottom_First", @"Bottom_First_Sel"], @[@"Bottom_MV", @"Bottom_MV_Sel"],@[@"Bottom_More", @"Bottom_More_Sel"],  @[@"Bottom_VList", @"Bottom_VList_Sel"], @[@"Bottom_MVList", @"Bottom_MVList_Sel"]];
    
    NSInteger buttonNumbers = buttonImageNames.count;
    
    // 每个按钮的宽度
    NSInteger space = _customTabBar.frame.size.width / buttonNumbers;
    for (NSInteger index = 0; index < buttonNumbers; ++index)
    {
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(index * space, 0, _customTabBar.frame.size.height, _customTabBar.frame.size.height)];
        [button setBackgroundImage: [UIImage imageNamed: buttonImageNames[index][0]] forState: UIControlStateNormal];
        [button setBackgroundImage: [UIImage imageNamed: buttonImageNames[index][1]] forState: UIControlStateSelected];
        
        // 设置标记
        button.tag = index + TAG;
        
        // 添加事件
        [button addTarget: self action: @selector(changeTabBar:) forControlEvents: UIControlEventTouchUpInside];
        [_customTabBar addSubview: button];
        
        if (index == 0)
        {
            button.selected = YES;
        }
    }
}

#pragma mark---切换tabBar按钮事件响应
- (void) changeTabBar: (UIButton *)sender
{
    NSInteger TAG = 100;
    
    for (UIButton *button in  _customTabBar.subviews)
    {
        button.selected = NO;
    }
    
    sender.selected = YES;
    
    // 导航栏的切换 只有在我的   悦单中不一样
    if (sender.tag - TAG == 2)
    {
        [_customNavigationBar viewWithTag: 201].hidden = YES;
        [_customNavigationBar viewWithTag: 202].hidden = YES;
        [_customNavigationBar viewWithTag: 203].hidden = NO;
    }
    else
    {
        [_customNavigationBar viewWithTag: 201].hidden = NO;
        [_customNavigationBar viewWithTag: 202].hidden = NO;
        [_customNavigationBar viewWithTag: 203].hidden = YES;
    }
    
    switch (sender.tag - TAG)
    {
        case 0:
        {
            ((UILabel *)[_customNavigationBar viewWithTag: 200]).text = @"首页";
            break;
        }
            
        case 1:
        {
            ((UILabel *)[_customNavigationBar viewWithTag: 200]).text = @"频道";
            break;
        }
            
        case 2:
        {
            ((UILabel *)[_customNavigationBar viewWithTag: 200]).text = @"我的音悦";
            break;
        }
            
        case 3:
        {
            ((UILabel *)[_customNavigationBar viewWithTag: 200]).text = @"V榜";
            break;
        }
            
        case 4:
        {
            ((UILabel *)[_customNavigationBar viewWithTag: 200]).text = @"悦单";
            break;
        }
        default:
            break;
    }
    
    self.selectedIndex = sender.tag - TAG;
}

#pragma mark---展示TabBar
- (void)showTabBar
{
    self.tabBar.hidden = NO;
    
    _customTabBar.hidden = NO;
}

#pragma mark---自定义NavigationBar
- (void)setCustomNavigationBar
{
    // 初始化
    _customNavigationBar = [[UIImageView alloc] initWithFrame: CGRectMake(0, 20, self.view.frame.size.width, NAVIGATION_BAR_HEIGHT)];
    
    [self.view addSubview: _customNavigationBar];
    
    // 允许与用户交互
    _customNavigationBar.userInteractionEnabled = YES;
    
    _customNavigationBar.image = [UIImage imageNamed: @"search_topView"];
    
    
    // 添加一个Label 长度为100
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake((_customNavigationBar.frame.size.width - 100) / 2, 0, 100, _customNavigationBar.frame.size.height)];
    
    // 设置标记
    label.tag = 200;
    
    label.textColor = [UIColor whiteColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = @"首页";
    
    [_customNavigationBar addSubview: label];
    
    // 口袋 Fan按钮
    UIButton *movieGameCentre = [UIButton buttonWithType: UIButtonTypeCustom];
    
    movieGameCentre.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + 20, 0, 44, 44);
    
    // 标记
    movieGameCentre.tag = 201;
    
    [movieGameCentre setBackgroundImage: [UIImage imageNamed:@"Movie_gamecentre"] forState: UIControlStateNormal];
    
    [movieGameCentre setBackgroundImage: [UIImage imageNamed: @"Movie_gamecentre_Sel"] forState: UIControlStateHighlighted];
    
    // 添加事件
    [movieGameCentre addTarget: self action: @selector(moveToFan) forControlEvents: UIControlEventTouchUpInside];
    
    [_customNavigationBar addSubview: movieGameCentre];
    
    // 搜索按钮
    UIButton *search = [UIButton buttonWithType: UIButtonTypeCustom];
    
    search.frame = CGRectMake(movieGameCentre.frame.origin.x + movieGameCentre.frame.size.width + 2, 0, 44, 44);
    
    // 标记
    search.tag = 202;
    
    [search setBackgroundImage: [UIImage imageNamed:@"Search"] forState: UIControlStateNormal];
    
    [search setBackgroundImage: [UIImage imageNamed: @"Search_Sel"] forState: UIControlStateHighlighted];
    
    // 添加事件
    [search addTarget: self action: @selector(moveToSearch) forControlEvents: UIControlEventTouchUpInside];
    
    [_customNavigationBar addSubview: search];
    
    // 设置按钮
    UIButton *setting = [UIButton buttonWithType: UIButtonTypeCustom];
    setting.frame = CGRectMake(movieGameCentre.frame.origin.x + movieGameCentre.frame.size.width + 2, 0, 44, 44);
    setting.tag = 203;
    [setting setBackgroundImage: [UIImage imageNamed:@"setting"] forState: UIControlStateNormal];
    [setting setBackgroundImage: [UIImage imageNamed: @"setting_p"] forState: UIControlStateHighlighted];
    [setting addTarget: self action: @selector(moveToSetting) forControlEvents: UIControlEventTouchUpInside];
    setting.hidden = YES;
    [_customNavigationBar addSubview: setting];
    
}

#pragma mark---展示自定义导航栏
- (void) showNavigationBar
{
    _customNavigationBar.hidden = NO;
}

#pragma mark---隐藏自定义导航栏
- (void) hideNavigationBar
{
    _customNavigationBar.hidden = YES;
}

#pragma mark---切换到口袋 Fan
- (void) moveToFan
{
    // 服务控制器
    HXServiceViewController *serviceViewController = [[HXServiceViewController alloc] init];
    serviceViewController.url = @"http://mapi.yinyuetai.com/yyt/star?deviceinfo=%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.1%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22HUAWEI%20Y300-0000%22%2C%22cr%22%3A%2246001%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22083df690358ed0c7ca179654e8010c33%22%2C%22clid%22%3A110033000%7D";
    serviceViewController.titleString = @"口袋 ✪ Fan";
    serviceViewController.isModal = YES;
    serviceViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController: serviceViewController animated: YES completion: nil];
}

#pragma mark---切换到搜索页面
- (void) moveToSearch
{
    // 搜索控制器
    HXSearchViewController *searchViewController = [[HXSearchViewController alloc] init];
    HXNavigationController *search = [[HXNavigationController alloc] initWithRootViewController: searchViewController];
    search.navigationBar.hidden = YES;
    searchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController: search animated: YES completion: nil];
    
}

#pragma mark---切换到设置页面
- (void) moveToSetting
{
    
}

#pragma mark---隐藏TabBar
- (void)hideTabBar
{
    self.tabBar.hidden = YES;
    
    _customTabBar.hidden = YES;
}

// 是否可以旋转
- (BOOL) shouldAutorotate
{
   
    return NO;

}

@end
