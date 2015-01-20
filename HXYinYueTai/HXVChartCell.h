//
//  HXVChartCell.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-5.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  V榜Cell
 */

#import <UIKit/UIKit.h>
#import "HXVChartModel.h"

@interface HXVChartCell : UITableViewCell

// V榜视图
@property (weak, nonatomic) IBOutlet UIImageView *vChartImage;

// 排名
@property (weak, nonatomic) IBOutlet UILabel *rank;

// 评分
@property (weak, nonatomic) IBOutlet UILabel *score;

// 标题
@property (weak, nonatomic) IBOutlet UILabel *title;

// 艺术家名字
@property (weak, nonatomic) IBOutlet UILabel *artistName;

// 设置V榜Cell
- (void) setVChartCellWith: (HXVChartModel *)vChartModel;

@end
