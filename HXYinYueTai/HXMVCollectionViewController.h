//
//  HXMVCollectionViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14/10/21.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMVCollectionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// 收藏表视图
@property (nonatomic, strong) UITableView *collectionTableView;

// 导航条
@property (nonatomic, strong) UIImageView *navigationBar;

// 收藏数组
@property (nonatomic, strong) NSMutableArray *collectonArray;

@end
