//
//  HXMyMusicViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMyMusicViewController : UIViewController

@property (nonatomic, strong) UIImageView *topView;

@property (nonatomic, strong) UIImageView *headImage;


// 顶部视图
- (void) setTopView;

// 头像
- (void) setHeadImage;

// 设置所有按钮
- (void) setButtons;

// 按钮事件响应
- (void) clickedButton: (UIButton *)sender;

@end
