//
//  HXRegisterViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-4.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

// 注册接口
#define POST_REGISTER (@"http://mapi.yinyuetai.com/account/register.json")

@interface HXRegisterViewController : UIViewController<UITextFieldDelegate>

// 导航栏
@property (nonatomic, strong) UIImageView *navigationBar;

// 账户按钮
@property (weak, nonatomic) IBOutlet UIButton *acount;

// 账户文本框
@property (weak, nonatomic) IBOutlet UITextField *acountTextField;

// 昵称按钮
@property (weak, nonatomic) IBOutlet UIButton *nickName;

// 昵称文本框
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

// 密码
@property (weak, nonatomic) IBOutlet UIButton *password;

// 密码文本框
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

// 手机注册按钮
@property (weak, nonatomic) IBOutlet UIButton *phoneRegister;

// 完成
@property (weak, nonatomic) IBOutlet UIButton *complete;

// 点击按钮
- (IBAction)ClickButton:(UIButton *)sender;

// 点击手机注册
- (IBAction)phoneRegisterClick:(id)sender;

// 点击完成按钮
- (IBAction)completeClick:(id)sender;

// 设置导航栏
- (void) setNavigationBar;

@end
