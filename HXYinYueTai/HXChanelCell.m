//
//  HXChanelCell.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-3.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXChanelCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HXChanelCell

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

- (void) setChanelCellWith: (NSArray *) chanelModels andChanelCell: (NSInteger) chanelSelect
{
    _chanelModels = chanelModels;
    
    // 是第几个cell
    switch (chanelSelect)
    {
        // 第1个Cell
        case 0:
        {
            HXChanelModel *chanelModel = (HXChanelModel *)chanelModels[0];
            
            _cellOneLeftLabel.text = chanelModel.title;
            
            [_cellOneLeftImage setImageWithURL: [NSURL URLWithString: chanelModel.imageUrl]];
            
            if ([chanelModel.flag isEqualToString: @"hot"])
            {
                _cellOneLeftFlag.image = [UIImage imageNamed: @"channel_hot"];
            }
            else if ([chanelModel.flag isEqualToString: @"new"])
            {
                _cellOneLeftFlag.image = [UIImage imageNamed: @"channel_new"];
            }
            
            
            chanelModel = (HXChanelModel *)chanelModels[1];
           
            [_cellOneRightImage setImageWithURL: [NSURL URLWithString: chanelModel.imageUrl]];
            
            _cellOneRightLabel.text = chanelModel.title;
            
            if ([chanelModel.flag isEqualToString: @"hot"])
            {
                _cellOneRightFlag.image = [UIImage imageNamed: @"channel_hot"];
            }
            else if ([chanelModel.flag isEqualToString: @"new"])
            {
                _cellOneRightFlag.image = [UIImage imageNamed: @"channel_new"];
            }
            
            break;
        }
         
        // 第2个Cell
        case 1:
        {
            HXChanelModel *chanelModel = (HXChanelModel *)chanelModels[0];
            
            _cellTwoLeftLabel.text = chanelModel.title;
            
            [_cellTwoLeftImage setImageWithURL: [NSURL URLWithString: chanelModel.imageUrl]];
            
            if ([chanelModel.flag isEqualToString: @"hot"])
            {
                _cellTwoLeftFlag.image = [UIImage imageNamed: @"channel_hot"];
            }
            else if ([chanelModel.flag isEqualToString: @"new"])
            {
                _cellTwoLeftFlag.image = [UIImage imageNamed: @"channel_new"];
            }
            
            
            chanelModel = (HXChanelModel *)chanelModels[1];
            
            [_cellTwoMiddleImage setImageWithURL: [NSURL URLWithString: chanelModel.imageUrl]];
            
            _cellTwoMiddleLabel.text = chanelModel.title;
            
            if ([chanelModel.flag isEqualToString: @"hot"])
            {
                _cellTwoMiddleFlag.image = [UIImage imageNamed: @"channel_hot"];
            }
            else if ([chanelModel.flag isEqualToString: @"new"])
            {
                _cellTwoMiddleFlag.image = [UIImage imageNamed: @"channel_new"];
            }
            
            chanelModel = (HXChanelModel *)chanelModels[2];
            
            _cellTwoRightLabel.text = chanelModel.title;
            
            [_cellTwoRightImage setImageWithURL: [NSURL URLWithString: chanelModel.imageUrl]];
            
            if ([chanelModel.flag isEqualToString: @"hot"])
            {
                _cellTwoRightFlag.image = [UIImage imageNamed: @"channel_hot"];
            }
            else if ([chanelModel.flag isEqualToString: @"new"])
            {
                _cellTwoRightFlag.image = [UIImage imageNamed: @"channel_new"];
            }
            
            break;
        }
            
        // 第3个cell
        case 2:
        {
            HXChanelModel *chanelModel = (HXChanelModel *)chanelModels[0];
            
            _cellThreeLeftLabel.text = chanelModel.title;
            
            [_cellThreeLeftImage setImageWithURL: [NSURL URLWithString: chanelModel.imageUrl]];
            
            if ([chanelModel.flag isEqualToString: @"hot"])
            {
                _cellThreeLeftFlag.image = [UIImage imageNamed: @"channel_hot"];
            }
            else if ([chanelModel.flag isEqualToString: @"new"])
            {
                _cellThreeLeftFlag.image = [UIImage imageNamed: @"channel_new"];
            }
            
            
            chanelModel = (HXChanelModel *)chanelModels[1];
            
            [_cellThreeRightImage setImageWithURL: [NSURL URLWithString: chanelModel.imageUrl]];
            
            _cellThreeRightLabel.text = chanelModel.title;
            
            if ([chanelModel.flag isEqualToString: @"hot"])
            {
                _cellThreeRightFlag.image = [UIImage imageNamed: @"channel_hot"];
            }
            else if ([chanelModel.flag isEqualToString: @"new"])
            {
                _cellThreeRightFlag.image = [UIImage imageNamed: @"channel_new"];
            }
            
            break;
        }
            
        case 3:
        {
            HXChanelModel *chanelModel = (HXChanelModel *)chanelModels[0];
            
            _cellFourLeftLabel.text = chanelModel.title;
            
            [_cellFourLeftImage setImageWithURL: [NSURL URLWithString: chanelModel.imageUrl]];
            
            if ([chanelModel.flag isEqualToString: @"hot"])
            {
                _cellFourLeftFlag.image = [UIImage imageNamed: @"channel_hot"];
            }
            else if ([chanelModel.flag isEqualToString: @"new"])
            {
                _cellFourLeftFlag.image = [UIImage imageNamed: @"channel_new"];
            }
            
            chanelModel = (HXChanelModel *)chanelModels[1];
            
            [_cellFourRightImage setImageWithURL: [NSURL URLWithString: chanelModel.imageUrl]];
            
            _cellFourRightLabel.text = chanelModel.title;
            
            if ([chanelModel.flag isEqualToString: @"hot"])
            {
                _cellFourRightFlag.image = [UIImage imageNamed: @"channel_hot"];
            }
            else if ([chanelModel.flag isEqualToString: @"new"])
            {
                _cellFourRightFlag.image = [UIImage imageNamed: @"channel_new"];
            }
            
            break;
        }
        default:
            break;
    }
}

// 图片点击事件
- (IBAction)tapImage:(UITapGestureRecognizer *)sender
{
    // 调用代理方法
    if (_delegate && [_delegate respondsToSelector: @selector(tapImageViewToTransferWith:)])
    {
        [_delegate tapImageViewToTransferWith: _chanelModels[sender.view.tag - 400]];
    }
   
}
@end
