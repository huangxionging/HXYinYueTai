//
//  HXSearchVideoCell.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-8.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  搜索视频Cell
 */

#import <UIKit/UIKit.h>
#import "HXVideoModel.h"
#import "HXAppDelegate.h"

// 回调block
typedef void (^SearchVideoBlock) (BOOL hide);

@interface HXSearchVideoCell : UITableViewCell
{
    HXAppDelegate *_app;
}

// 海报
@property (nonatomic, strong) UIImageView *image;

// 标题
@property (nonatomic, strong) UILabel *title;

// 艺术家
@property (nonatomic, strong) UILabel *artist;

// 更多按钮
@property (nonatomic, strong) UIButton *more;

// 分割线
@property (nonatomic, strong) UILabel *separator;

// 子视图
@property (nonatomic, strong) UIView *subView;

// 索引路径
@property (nonatomic, weak) NSIndexPath *indexPath;

// block 回调
@property (nonatomic, copy) SearchVideoBlock videoBlock;

// 模型
@property (nonatomic, weak) HXVideoModel *videoModel;

// 高清地址
@property (nonatomic, copy) NSString *hdurl;




- (void) setSearchVideoCellWith: (HXVideoModel *)videoModel With: (SearchVideoBlock) videoblock;

@end
