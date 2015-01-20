//
//  HXMVCollectionTableViewCell.h
//  HXYinYueTai
//
//  Created by huangxiong on 14/10/22.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXVideoCollectionModel.h"

@interface HXMVCollectionTableViewCell : UITableViewCell

// 海报
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;

// 标题
@property (weak, nonatomic) IBOutlet UILabel *title;

// 艺术家
@property (weak, nonatomic) IBOutlet UILabel *atrtist;

- (void) setCellWithModel: (HXVideoCollectionModel *)model;

@end
