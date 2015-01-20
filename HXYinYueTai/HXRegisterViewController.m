//
//  HXRegisterViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-4.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXRegisterViewController.h"
#import "HXPhoneRegisterViewController.h"
#import "AFNetworking.h"

#define TITLE_WIDTH (100)

@interface HXRegisterViewController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation HXRegisterViewController

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
    
    [self setNavigationBar];
    
    _manager = [[AFHTTPRequestOperationManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    // 发送隐藏导航栏通知
    [[NSNotificationCenter defaultCenter] postNotificationName: HIDE_NAVIGATION_BAR  object: nil];
    
    // 发送隐藏tabBar通知
    [[NSNotificationCenter defaultCenter] postNotificationName: HIDE_TAB_BAR object: nil];
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
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake((_navigationBar.frame.size.width - TITLE_WIDTH) / 2, 0, TITLE_WIDTH, NAVIGATION_BAR_HEIGHT)];
    
    // 字体颜色
    title.textColor = [UIColor whiteColor];
    
    // 排版
    title.textAlignment = NSTextAlignmentCenter;
    
    
    title.text = @"新用户注册";
    
    [_navigationBar addSubview: title];
}

#pragma mark---返回按钮事件
- (void) back
{
    [self.navigationController popViewControllerAnimated: NO];
}


- (IBAction)phoneRegisterClick:(id)sender
{
    HXPhoneRegisterViewController *phoneViewController = [[HXPhoneRegisterViewController alloc] init];
    
    [self.navigationController pushViewController: phoneViewController animated: NO];
}

- (IBAction) completeClick:(id)sender
{
    @synchronized(self)
    {
        [_manager POST: POST_REGISTER parameters: @{@"deviceinfo": DEVICEINFO, @"email" : _acountTextField.text, @"password" : _passwordTextField.text, @"nickname" : _nickNameTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"%@", responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"%@", operation.responseObject[@"display_message"]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"✪错误✪" message:operation.responseObject[@"display_message"] delegate: nil cancelButtonTitle: @"确定" otherButtonTitles: nil];
            
            [alert show];
        }];
    }
}

- (IBAction)ClickButton:(UIButton *)sender
{
    if (sender == _acount)
    {
        _acount.selected = YES;
        _password.selected = NO;
        _nickName.selected = NO;
        [_acountTextField becomeFirstResponder];
    }
    else if (sender == _nickName)
    {
        _acount.selected = NO;
        _password.selected = NO;
        _nickName.selected = YES;
        [_nickNameTextField becomeFirstResponder];
    }
    else if (sender == _password)
    {
        _acount.selected = NO;
        _password.selected = YES;
        _nickName.selected = NO;
        [_passwordTextField becomeFirstResponder];
    }
}

#pragma mark---UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _acountTextField)
    {
        _acount.selected = YES;
    }
    else if (textField == _nickNameTextField)
    {
        _nickName.selected = YES;
    }
    else if (textField == _passwordTextField)
    {
        _password.selected = YES;
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _acountTextField)
    {
        _acount.selected = NO;
        if ([textField.text hasSuffix: @".com"] == NO || [textField.text rangeOfString: @"@"].location == NSNotFound || [textField.text rangeOfString: @"@"].location == [textField.text rangeOfString: @"."].location - 1)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"🐵🐷错误🐷🐵" message: @"邮箱地址错误" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
            
            [alertView show];
        }
    }
    else if (textField == _nickNameTextField)
    {
        _nickName.selected = NO;
    }
    else if (textField == _passwordTextField)
    {
        _password.selected = NO;
    }
}

@end
