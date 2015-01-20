//
//  HXArtistCell.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-9.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  艺术家Cell
 */

#import <UIKit/UIKit.h>
#import "HXSearchArtistModel.h"

@interface HXArtistCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

// 艺术家名字
@property (weak, nonatomic) IBOutlet UILabel *artistName;

// 视频数量标签
@property (weak, nonatomic) IBOutlet UILabel *mvNumber;

// 排名
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;

// 点击事件
- (IBAction)clickOrder:(UIButton *)sender;

// 设置cell
- (void)setArtistCellWith: (HXSearchArtistModel *)searchArtistModel;

@end
