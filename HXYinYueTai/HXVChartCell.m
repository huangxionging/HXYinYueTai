//
//  HXVChartCell.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-5.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXVChartCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HXVChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setVChartCellWith: (HXVChartModel *)vChartModel
{
    
    // 排名
    _rank.text = vChartModel.rank;
    
    // 艺术家
    _artistName.text = vChartModel.artistName;
    
    // 图片
    [_vChartImage setImageWithURL: [NSURL URLWithString: vChartModel.posterPicture]];
    
    // 评分
    _score.text = [NSString stringWithFormat: @"%@", vChartModel.score];
    
    // 标题
    _title.text = vChartModel.title;
}

@end
