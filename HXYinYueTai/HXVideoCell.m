//
//  HXVideoCell.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-1.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXVideoCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HXVideoCell


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

- (void) setVideoCellWith: (NSArray *)videoModelArray
{
    // 为左边图像视图创建手势
    if (_leftImageView.gestureRecognizers == nil)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapLeft:)];
        
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [_leftImageView addGestureRecognizer: tap];
    }
    
    // 为右边图像视图创建手势
    if (_rightImageView.gestureRecognizers == nil)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapRight:)];
        
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [_rightImageView addGestureRecognizer: tap];
    }
    
    // 取视频模型数据
    _videoModelLeft = (HXVideoModel *)videoModelArray[0];
    
    // 设置左边视图
    [_leftImageView setImageWithURL: [NSURL URLWithString: _videoModelLeft.posterPicture]];
    _leftTitle.text = _videoModelLeft.title;
    _leftArtistName.text = _videoModelLeft.artistName;
    _leftLabel.text = _videoModelLeft.promoTitle;
    
    
    _videoModelRight = (HXVideoModel *)videoModelArray[1];
   
    // 设置右边视图
    [_rightImageView setImageWithURL: [NSURL URLWithString: _videoModelRight.posterPicture]];
    _rightTitle.text = _videoModelRight.title;
    _rightArtistName.text = _videoModelRight.artistName;
    _rightLabel.text = _videoModelRight.promoTitle;
}

// 左视图点击事件
- (void)tapLeft:(UITapGestureRecognizer *)sender
{
    // 调用代理
    if (_delegate && [_delegate respondsToSelector: @selector(tapVideoCellWith:)])
    {
        [_delegate tapVideoCellWith: _videoModelLeft];
    }
}

// 右视图点击事件
- (void)tapRight:(UITapGestureRecognizer *)sender
{
    // 调用代理
    if (_delegate && [_delegate respondsToSelector: @selector(tapVideoCellWith:)])
    {
        [_delegate tapVideoCellWith: _videoModelRight];
    }
}

@end
