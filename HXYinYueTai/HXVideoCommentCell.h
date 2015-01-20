//
//  HXVideoCommentCell.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-11.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  视频评论Cell
 */

#import <UIKit/UIKit.h>
#import "HXVideoCommentModel.h"

@interface HXVideoCommentCell : UITableViewCell

// 名字
@property (nonatomic, strong) UILabel *userName;

// 头像
@property (nonatomic, strong) UIImageView *userHeadImage;

// 评论日期
@property (nonatomic, strong) UILabel *dateCreated;

// 评论内容
@property (nonatomic, strong) UILabel *content;

// 设置cell
- (void) setVideoCommentCellWith: (HXVideoCommentModel *)videoCommentModel;

@end
