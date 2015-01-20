//
//  HXMyMusicViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXMyMusicViewController.h"
#import "HXLoginViewController.h"
#import "HXTabBarController.h"
#import "HXRegisterViewController.h"
#import "HXServiceViewController.h"
#import "HXLoginViewController.h"
#import "HXMVCollectionViewController.h"

@interface HXMyMusicViewController ()

@end

@implementation HXMyMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    // 发送展示导航栏通知
    [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_NAVIGATION_BAR  object: nil];
    // 发送展示tabBar通知
    [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_TAB_BAR object: nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    
    [self setTopView];
    
    [self setHeadImage];
    
    [self setLoginButton];
    
    [self setRegisterButton];
    
    [self setButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---设置顶视图
- (void) setTopView
{
    // 初始化
    _topView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, 100)];
    
    // 添加到self.view上
    [self.view addSubview: _topView];
    
    // 允许用户交互
    _topView.userInteractionEnabled = YES;
    
    // 添加图片
    _topView.image = [UIImage imageNamed: @"bg"];
    
}

#pragma mark---头像
- (void) setHeadImage
{
    // 头像初始化
    _headImage = [[UIImageView alloc] initWithFrame: CGRectMake(5, 5, 90, 90)];
    // 添加到顶视图上
    [_topView addSubview: _headImage];
    // 设置图像
    _headImage.image = [UIImage imageNamed: @"ArtistDetail_DisplayFrame"];
    
}

#pragma mark---设置按钮
- (void) setLoginButton
{
    // 登陆按钮
    UIButton *login = [UIButton buttonWithType: UIButtonTypeCustom];
    // 位置和大小
    login.frame = CGRectMake(_headImage.frame.size.width + _headImage.frame.origin.x + 30, (100 - 30) / 2, 75, 30);
    // 设置图片
    [login setBackgroundImage: [UIImage imageNamed: @"landing_button"] forState: UIControlStateNormal];
    [login setBackgroundImage: [UIImage imageNamed: @"landing_button_p"] forState: UIControlStateHighlighted];
    // 添加事件
    [login addTarget: self action: @selector(login) forControlEvents: UIControlEventTouchUpInside];
    [_topView addSubview: login];
}

#pragma mark---登陆按钮事件
- (void) login
{
    HXLoginViewController *loginViewController = [[HXLoginViewController alloc] init];
    [self.navigationController pushViewController: loginViewController animated: NO];
}

#pragma mark---设置注册按钮
- (void) setRegisterButton
{
    // 登陆按钮
    UIButton *registerButton = [UIButton buttonWithType: UIButtonTypeCustom];
    // 位置和大小
    registerButton.frame = CGRectMake(_headImage.frame.size.width + _headImage.frame.origin.x + 120, (100 - 30) / 2, 75, 30);
    // 设置图片
    [registerButton setBackgroundImage: [UIImage imageNamed: @"registered_button"] forState: UIControlStateNormal];
    [registerButton setBackgroundImage: [UIImage imageNamed: @"registered_button_p"] forState: UIControlStateHighlighted];
    
    // 添加事件
    [registerButton addTarget: self action: @selector(registerClick) forControlEvents: UIControlEventTouchUpInside];
    [_topView addSubview: registerButton];
}


#pragma mark---登陆按钮事件
- (void) registerClick
{
    HXRegisterViewController *registerViewController = [[HXRegisterViewController alloc] init];
    [self.navigationController pushViewController: registerViewController animated: NO];
}

#pragma mark---设置按钮
- (void) setButtons
{
    NSArray *buttonArray = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"HXMyMusicViewController" ofType: @"plist"]];
    NSInteger spacex = 0, spacey = _topView.frame.origin.y + _topView.frame.size.height ;
    for (NSInteger index = 0; index < buttonArray.count; ++index)
    {
        // 初始化
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        // 位置
        button.frame = CGRectMake(spacex , spacey, 80, 65);
        button.contentMode = UIViewContentModeScaleAspectFill;
        // 边框
        button.layer.borderWidth = 1;
        // 边框颜色
        button.layer.borderColor = [UIColor colorWithRed: 232 / 256.0 green: 238 / 256.0 blue: 249 / 256.0 alpha: 0.8].CGColor;
        // 背景图片
        [button setImage: [UIImage imageNamed: buttonArray[index][@"image_n"]] forState: UIControlStateNormal];
        [button setImage: [UIImage imageNamed: buttonArray[index][@"image_l"]] forState: UIControlStateHighlighted];
        // 添加标记
        button.tag = 500 + index;
        
        // 添加事件
        [button addTarget: self action: @selector(clickedButton:) forControlEvents: UIControlEventTouchUpInside];
        
        // 坐标偏移
        spacex += 80;
        
        if ((index + 1) % 4 == 0)
        {
            spacey += 65;
            spacex = 0;
        }
        [self.view addSubview: button];
        
    }
}

#pragma mark---按钮点击事件
- (void)clickedButton:(UIButton *)sender
{
    switch (sender.tag - 500)
    {
        case 0:
        {
             HXServiceViewController *serviceViewController = [[HXServiceViewController alloc] init];
            serviceViewController.url = @"http://mapi.yinyuetai.com/product/subscribe_view?D-A=0&deviceinfo=%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.1%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22HUAWEI%20Y300-0000%22%2C%22cr%22%3A%2246001%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22083df690358ed0c7ca179654e8010c33%22%2C%22clid%22%3A110033000%7D";
            serviceViewController.titleString = @"沃音悦台包月服务";
            [self.navigationController pushViewController: serviceViewController animated: NO];
            
            break;
        }
            
        case 1:
        {
            HXLoginViewController *loginViewController = [[HXLoginViewController alloc] init];
            [self.navigationController pushViewController: loginViewController animated: NO];
            break;
        }
            
        case 2:
        {
            HXLoginViewController *loginViewController = [[HXLoginViewController alloc] init];
            [self.navigationController pushViewController: loginViewController animated: NO];
            break;
        }
            
        case 3:
        {
            HXLoginViewController *loginViewController = [[HXLoginViewController alloc] init];
            [self.navigationController pushViewController: loginViewController animated: NO];
            break;
        }
            
        case 5:
        {
            HXMVCollectionViewController *mvCollectionViewController = [[HXMVCollectionViewController alloc] init];
            [self.navigationController pushViewController: mvCollectionViewController animated: NO];
            break;
        }
            
        case 6:
        {
            HXLoginViewController *loginViewController = [[HXLoginViewController alloc] init];
            [self.navigationController pushViewController: loginViewController animated: NO];
            break;
        }
            
        case 7:
        {
            
            HXLoginViewController *loginViewController = [[HXLoginViewController alloc] init];
            [self.navigationController pushViewController: loginViewController animated: NO];
            break;
        }

        case 8:
        {
             HXServiceViewController *serviceViewController = [[HXServiceViewController alloc] init];
            serviceViewController.url = @"http://mapi.yinyuetai.com/yyt/star?deviceinfo=%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.1%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22HUAWEI%20Y300-0000%22%2C%22cr%22%3A%2246001%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22083df690358ed0c7ca179654e8010c33%22%2C%22clid%22%3A110033000%7D";
            serviceViewController.titleString = @"口袋 ✪ Fan";
            [self.navigationController pushViewController: serviceViewController animated: NO];
            break;
        }
            
        // 音悦直播
        case 9:
        {
            break;
        }
        
        // 炫铃
        case 10:
        {
             HXServiceViewController *serviceViewController = [[HXServiceViewController alloc] init];
            // 网址
            serviceViewController.url = @"http://mapi.yinyuetai.com/ring?deviceinfo=%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.1%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22HUAWEI%20Y300-0000%22%2C%22cr%22%3A%2246001%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22083df690358ed0c7ca179654e8010c33%22%2C%22clid%22%3A110033000%7D";
            
            // 标题
            serviceViewController.titleString = @"音乐炫铃";
            [self.navigationController pushViewController: serviceViewController animated: NO];
            break;
        }
        
        // 游戏中心
        case 11:
        {
            HXServiceViewController *serviceViewController = [[HXServiceViewController alloc] init];
            // 网址
            serviceViewController.url = @"http://m.yinyuetai.com/apps/game";
            // 标题
            serviceViewController.titleString = @"音悦台";
            [self.navigationController pushViewController: serviceViewController animated: NO];
            break;
        }
        default:
            break;
    }
}



@end
