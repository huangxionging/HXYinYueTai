//
//  HXMusicListCell.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-6.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  悦单Cell
 */

#import <UIKit/UIKit.h>
#import "HXMusicListModel.h"

@interface HXMusicListCell : UITableViewCell

// 海报图片
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;

// 标题
@property (weak, nonatomic) IBOutlet UILabel *title;

// 视频数标签
@property (weak, nonatomic) IBOutlet UILabel *videoCount;

// 右标签
@property (weak, nonatomic) IBOutlet UILabel *right;

// 积分标签
@property (weak, nonatomic) IBOutlet UILabel *integral;

// 拥有者标签
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickName;

// 设置悦单Cell
- (void) setMusicListCellWith : (HXMusicListModel *)musicListModel;

@end
