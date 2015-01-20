//
//  HXHomePageSectionHeadView.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-2.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  首页页面中TableView中每个section的头视图
 */

#import <UIKit/UIKit.h>

@protocol HXHomePageSectionHeadViewDelegate;

@interface HXHomePageSectionHeadView : UITableViewHeaderFooterView

// 左视图
@property (weak, nonatomic) IBOutlet UIImageView *leftHeadImage;

// 右视图
@property (weak, nonatomic) IBOutlet UIImageView *rightHeadImage;

// 按钮
@property (weak, nonatomic) IBOutlet UIButton *button;

// 索引
@property (nonatomic, strong) NSIndexPath *indexPath;

// 代理
@property (nonatomic, assign) id<HXHomePageSectionHeadViewDelegate> delegate;

// 按钮事件响应
- (IBAction)clickButton:(UIButton *)sender;

@end

// 代理协议
@protocol HXHomePageSectionHeadViewDelegate <NSObject>

@optional

// 点击按钮时被调用
- (void) clickedButtonWith: (NSIndexPath *)indexPath;

@end
