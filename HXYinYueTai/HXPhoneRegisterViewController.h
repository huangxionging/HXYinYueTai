//
//  HXPhoneRegisterViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-15.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

// 手机注册
#define GET_PHONE_REGISTER (@"http://wappass.baidu.com/wp/api/reg/sms")

// 设备绑定
#define GET_DEV_TOKEN (@"http://mapi.yinyuetai.com/apns/bind.json")

@interface HXPhoneRegisterViewController : UIViewController

// 导航栏
@property (nonatomic, strong) UIImageView *navigationBar;

// 手机文本框
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

// 下一步按钮
@property (weak, nonatomic) IBOutlet UIButton *nexStep;

// 手机按钮
@property (weak, nonatomic) IBOutlet UIButton *phone;

// 下一步点击事件
- (IBAction)nextClick:(id)sender;

// 手机点击
- (IBAction)phoneClick:(UIButton *)sender;

@end
