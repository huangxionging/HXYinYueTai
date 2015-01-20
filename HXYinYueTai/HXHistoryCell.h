//
//  HXHistoryCell.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-7.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  清除历史记录Cell
 */

#import <UIKit/UIKit.h>

// 定义清除Cell block
typedef void(^ClearTable) (NSInteger index);

@interface HXHistoryCell : UITableViewCell

// block
@property (nonatomic, strong) ClearTable clearTableBlock;

// 按钮点击事件
- (IBAction)clicked:(UIButton *)sender;

// 设置清除表
- (void) clearTable: (ClearTable) clearBlock;

@end
