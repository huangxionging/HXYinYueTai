//
//  HXVideoCommentCell.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-11.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXVideoCommentCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HXVideoCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // 头像
        _userHeadImage = [[UIImageView alloc] initWithFrame: CGRectMake(0, 5, 50, 50)];
        _userHeadImage.layer.masksToBounds = YES;
        _userHeadImage.layer.cornerRadius = _userHeadImage.frame.size.height / 2;
        [self.contentView addSubview: _userHeadImage];
        
        // 名字
        _userName = [[UILabel alloc] initWithFrame: CGRectMake(_userHeadImage.frame.origin.x + _userHeadImage.frame.size.width + 5, 5, 130, 20)];
        _userName.font = [UIFont systemFontOfSize: 13.0];
        _userName.textColor = [UIColor lightGrayColor];
        _userName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview: _userName];
        
        // 评论日期
        _dateCreated = [[UILabel alloc] initWithFrame: CGRectMake(_userName.frame.size.width + _userName.frame.origin.x, _userName.frame.origin.y, self.contentView.frame.size.width - _userName.frame.size.width - _userName.frame.origin.x, 20)];
        _dateCreated.font = [UIFont systemFontOfSize: 13.0];
        _dateCreated.textColor = [UIColor lightGrayColor];
        _dateCreated.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview: _dateCreated];
        
        // 内容
        _content = [[UILabel alloc] init];
        _content.font = [UIFont systemFontOfSize: 14.0];
        _content.textColor = [UIColor blackColor];
        _content.textAlignment = NSTextAlignmentLeft;
        _content.numberOfLines = 0;
        [self.contentView addSubview: _content];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setVideoCommentCellWith: (HXVideoCommentModel *)videoCommentModel
{
    [_userHeadImage setImageWithURL: [NSURL URLWithString: videoCommentModel.headImage]];
    
    _userName.text = videoCommentModel.userName;
    
    _dateCreated.text = videoCommentModel.dateCreated;
    
    _content.frame = CGRectMake(55, 60, 260, videoCommentModel.contentHeight);
    
    _content.text = videoCommentModel.content;
}

@end
