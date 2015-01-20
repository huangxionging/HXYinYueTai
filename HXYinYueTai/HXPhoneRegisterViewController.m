//
//  HXPhoneRegisterViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-15.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXPhoneRegisterViewController.h"
#import "AFNetworking.h"

// 标题宽度
#define TITLE_WIDTH (100)

// 手机号码位数
#define PHONE_NUMBERS (11)

@interface HXPhoneRegisterViewController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation HXPhoneRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
    
    _manager = [[AFHTTPRequestOperationManager alloc] init];
    
    [_nexStep setBackgroundImage: [UIImage imageNamed: @"Login_phoneNext_No_Sel"] forState: UIControlStateNormal];
    
    [_nexStep setBackgroundImage: [UIImage imageNamed: @"Login_phoneNext_Sel@2x"] forState: UIControlStateHighlighted];
    
    
    _nexStep.enabled = NO;
    
    [_manager GET: GET_DEV_TOKEN parameters: @{@"deviceinfo": DEVICEINFO, @"device_token" : @"gt-7b1bee6ac03b72f716cb74d248555c16"} success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@", responseObject[@"message"]);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@", operation.responseObject);
    }];
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
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake((_navigationBar.frame.size.width - TITLE_WIDTH) / 2, 0, TITLE_WIDTH, NAVIGATION_BAR_HEIGHT)];
    
    // 字体颜色
    title.textColor = [UIColor whiteColor];
    
    // 排版
    title.textAlignment = NSTextAlignmentCenter;
    
    
    title.text = @"手机注册";
    
    [_navigationBar addSubview: title];
}

#pragma mark---返回按钮事件
- (void) back
{
    [self.navigationController popViewControllerAnimated: NO];
}

- (IBAction)nextClick:(id)sender
{
    [_manager POST: @"http://mobilelog.kugou.com/messagecheck.php" parameters: @{@"apiver": @"16", @"pnum" : _phoneTextField.text, @"stype" : @"1", @"nettype" : @"2", @"imei" : @"10955554972843210758169068003636874291", @"ver" : @"6351", @"platid" : @"0", @"cid" : @"14"} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@", responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error);
     }];
    
    [_manager POST: GET_PHONE_REGISTER parameters: @{@"v": @"1410691549622", @"mobilenum" : _phoneTextField.text, @"tpl" : @"mobimap", @"clientfrom" : @"native"} success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@", responseObject[@"errInfo"][@"msg"]);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"%@", operation.responseObject[@"display_message"]);
    }];
}
- (IBAction)phoneClick:(UIButton *)sender
{
    [_phoneTextField becomeFirstResponder];
    sender.selected = YES;
}

#pragma mark----UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger count = 0;
    
    if ([string isEqualToString: @""] == NO)
    {
        count = PHONE_NUMBERS - 1;
    }
    else
    {
        count = PHONE_NUMBERS + 1;
    }
    
    // 或者用一个表达式判断 ([textField.text length] + [string length] + 1) / 2 == (PHONE_NUMBERS + 1) / 2; 但是不如本处代码通用
    
    if ([textField.text length] == count)
    {
        _nexStep.enabled = YES;
        [_nexStep setBackgroundImage: [UIImage imageNamed: @"Login_phoneNext"] forState: UIControlStateNormal];
    }
    else
    {
        _nexStep.enabled = NO;
        [_nexStep setBackgroundImage: [UIImage imageNamed: @"Login_phoneNext_No_Sel"] forState: UIControlStateNormal];
    }
    return YES;
}

@end
