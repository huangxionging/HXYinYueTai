//
//  HXHistoryCell.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-7.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXHistoryCell.h"
#import "HXMainDataBase.h"

@implementation HXHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) clearTable: (ClearTable) clearBlock
{
    // block赋值
    _clearTableBlock = clearBlock;
}

- (IBAction)clicked:(UIButton *)sender
{
    // 调用block
    if (_clearTableBlock)
    {
        _clearTableBlock(0);
    }
}
@end
