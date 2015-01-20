//
//  HXMVCollectionTableViewCell.m
//  HXYinYueTai
//
//  Created by huangxiong on 14/10/22.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXMVCollectionTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HXMVCollectionTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setCellWithModel: (HXVideoCollectionModel *)model
{
    [_posterImage setImageWithURL: [NSURL URLWithString: [model valueForKey: @"image"]]];
    _title.text = [model valueForKey: @"title"];
    _atrtist.text = [model valueForKey: @"artist"];
}
@end
