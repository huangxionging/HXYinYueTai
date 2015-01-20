//
//  HXMusicViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-12.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMusicViewController : UIViewController

// 悦单ID
@property(nonatomic, copy) NSNumber *playListID;

@property (nonatomic, strong) UITableView *playListTableView;

// 自定义导航栏
@property (nonatomic, strong) UIImageView *navigationBar;

@property (nonatomic, copy) NSString *titleString;


@end
