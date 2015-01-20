//
//  HXHomePageSectionHeadView.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-2.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXHomePageSectionHeadView.h"

@implementation HXHomePageSectionHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// 点击按钮
- (IBAction)clickButton:(UIButton *)sender
{
    // 调用代理
    if (_delegate && [_delegate respondsToSelector: @selector(clickedButtonWith:)])
    {
        [_delegate clickedButtonWith: _indexPath];
    }
}
@end
