//
//  HXMusicListCell.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-6.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXMusicListCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HXMusicListCell

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

- (void) setMusicListCellWith : (HXMusicListModel *)musicListModel
{
    // 悦单图片
    [_posterImage setImageWithURL: [NSURL URLWithString: musicListModel.playListBigPicture]];
    
    // 头像
    
    // 圆角图像
    _avatar.layer.masksToBounds = YES;
    
    _avatar.layer.cornerRadius = _avatar.frame.size.height / 2;

    
    [_avatar setImageWithURL: [NSURL URLWithString: musicListModel.creator.smallAvatar]];
    
    // mv数量
    _videoCount.frame = CGRectMake(_videoCount.frame.origin.x, _videoCount.frame.origin.y, musicListModel.videoLabelWidth, _videoCount.frame.size.height);
    
    // 重设右标签的frame
    _right.frame = CGRectMake(_videoCount.frame.origin.x + musicListModel.videoLabelWidth, _right.frame.origin.y, _right.frame.size.width, _right.frame.size.height);
    
    // 视频标签文字
    _videoCount.text = [NSString stringWithFormat: @"%@", musicListModel.videoCount];
    
    // 标题
    _title.text = musicListModel.title;
    
    // 积分
    _integral.text = [NSString stringWithFormat: @"%@",musicListModel.integral];
    
    // 昵称
    _nickName.text = musicListModel.creator.nickName;
    
}

@end
