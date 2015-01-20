//
//  HXArtistCell.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-9.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXArtistCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HXArtistCell

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

- (IBAction)clickOrder:(UIButton *)sender
{
    
}

- (void)setArtistCellWith: (HXSearchArtistModel *)searchArtistModel
{
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = _headImage.frame.size.height / 2;
    [_headImage setImageWithURL: [NSURL URLWithString: searchArtistModel.smallAvatar]];
    
    _artistName.text = searchArtistModel.artistName;
    
    _mvNumber.text = [NSString stringWithFormat: @"%@", searchArtistModel.videoCount];
    
    _orderNumber.text = [NSString stringWithFormat: @"%@", searchArtistModel.subCount];
    
}

@end
