//
//  HXVideoCell.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-1.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  视频Cell，放置视频信息
 */

#import <UIKit/UIKit.h>

#import "HXVideoModel.h"

// 代理协议
@protocol  HXVideoCellDelegate;

@interface HXVideoCell : UITableViewCell

// 左图片
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

// 右图片
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

// 左标签
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

// 右标签
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

// 左标题
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;

// 左边视频艺术家名字
@property (weak, nonatomic) IBOutlet UILabel *leftArtistName;

// 右标题
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;

// 右视频
@property (weak, nonatomic) IBOutlet UILabel *rightArtistName;

@property (nonatomic, assign) id<HXVideoCellDelegate> delegate;

// 左模型
@property (nonatomic, strong) HXVideoModel *videoModelLeft;

// 右模型
@property (nonatomic, strong) HXVideoModel *videoModelRight;

// 设置cell 一个cell有两个东西
- (void) setVideoCellWith: (NSArray *)videoModelArray;

// 图片点击事件
- (void)tapLeft:(UITapGestureRecognizer *)sender;
- (void)tapRight:(UITapGestureRecognizer *)sender;

@end

// HXVideoCellDelegate
@protocol HXVideoCellDelegate <NSObject>

@optional

// 点击图片，传递视频模型
- (void) tapVideoCellWith: (HXVideoModel *) videoModel;

@end
