//
//  HXLoginViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-4.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

// 登陆接口
#define LOGIN (@"http://mapi.yinyuetai.com/account/login.json")

@interface HXLoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *navigationBar;

@property (weak, nonatomic) IBOutlet UIButton *acount;

@property (weak, nonatomic) IBOutlet UITextField *acountTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *password;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)accountClick:(UIButton *)sender;


- (IBAction)passwordClick:(UIButton *)sender;

- (IBAction)registerAccount:(UIButton *)sender;

- (IBAction)login:(UIButton *)sender;

- (IBAction)lookPassword:(UIButton *)sender;



- (void) setNavigationBar;

@end
