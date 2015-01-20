//
//  HXLoginViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-4.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXLoginViewController.h"
#import "HXRegisterViewController.h"
#import "AFNetworking.h"

#define TITLE_WIDTH (100)

@interface HXLoginViewController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation HXLoginViewController

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
    
    _manager = [[AFHTTPRequestOperationManager alloc] init];
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
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake((_navigationBar.frame.size.width - TITLE_WIDTH) / 2, 0, TITLE_WIDTH, 44)];
    
    // 字体颜色
    title.textColor = [UIColor whiteColor];
    
    // 排版
    title.textAlignment = NSTextAlignmentCenter;
    
    
    title.text = @"账号管理";
    
    [_navigationBar addSubview: title];
}

#pragma mark---返回按钮事件
- (void) back
{
    [self.navigationController popViewControllerAnimated: NO];
}

- (IBAction)accountClick:(UIButton *)sender
{
    [_acountTextFiled becomeFirstResponder];
    _acount.selected = YES;
    
    _password.selected = NO;
}

- (IBAction)passwordClick:(UIButton *)sender
{
    [_passwordTextField becomeFirstResponder];
    _acount.selected = NO;
    _password.selected = YES;
}

- (IBAction)registerAccount:(UIButton *)sender
{
}

- (IBAction)login:(UIButton *)sender
{
    [_manager GET: LOGIN parameters: @{@"deviceinfo": DEVICEINFO, @"username" : _acountTextFiled.text, @"password" : [_passwordTextField.text stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding]} success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@", responseObject);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"错误" message: operation.responseObject[@"display_message"] delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
        
        [alertView show];
        
        NSLog(@"%@", error);
    }];
}

- (IBAction)lookPassword:(UIButton *)sender
{
}


#pragma mark---UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _acountTextFiled)
    {
        _acount.selected = YES;
    }
    
    else if (textField == _passwordTextField)
    {
        _password.selected = YES;
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _acountTextFiled)
    {
        _acount.selected = NO;
    }
    
    else if (textField == _passwordTextField)
    {
        _password.selected = NO;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
