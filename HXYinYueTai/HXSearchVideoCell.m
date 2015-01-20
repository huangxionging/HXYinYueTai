//
//  HXSearchVideoCell.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-8.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXSearchVideoCell.h"
#import "UIImageView+AFNetworking.h"
#import "HXNetWork.h"
#import "WXApi.h"
#import "HXVideoCollectionModel.h"

@implementation HXSearchVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (_app == nil)
        {
             _app = (HXAppDelegate *)[UIApplication sharedApplication].delegate;
        }
        
        // 图片
        _image = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 140, 80)];
        [self.contentView addSubview: _image];
        _image.image = [UIImage imageNamed: @"HomePageBackgroundView"];
        
        // 标题
        _title = [[UILabel alloc] initWithFrame: CGRectMake(_image.frame.size.width + 2, 10, 140, 21)];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.textColor = [UIColor lightGrayColor];
        _title.font = [UIFont systemFontOfSize: 13.0];
        [self.contentView addSubview: _title];
        
        // 艺人
        _artist = [[UILabel alloc] initWithFrame: CGRectMake(_image.frame.size.width + 2, 30, 140, 21)];
        _artist.textAlignment = NSTextAlignmentLeft;
        _artist.textColor = [UIColor colorWithRed: 50 / 256.0 green: 232 / 256.0 blue: 150 / 256.0 alpha: 1];
        _artist.font = [UIFont systemFontOfSize: 13.0];
        [self.contentView addSubview: _artist];
        
        // more按钮
        _more = [UIButton buttonWithType: UIButtonTypeCustom];
        _more.frame = CGRectMake(280, 20, 40, 40);
        [_more setImage: [UIImage imageNamed: @"operation_mv"] forState: UIControlStateNormal];
        [_more setImage: [UIImage imageNamed: @"operation_mv_sel"] forState: UIControlStateHighlighted];
        [_more addTarget: self action: @selector(clickMore) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: _more];
        
        // 分割线
        _separator = [[UILabel alloc] initWithFrame: CGRectMake(0, 79, 320, 1)];
        _separator.backgroundColor = [UIColor colorWithRed: 61 / 256.0 green: 70 / 256.0 blue: 232 / 256.0 alpha: 1.0];
        [self.contentView addSubview: _separator];
        
        
        // subView
        _subView = [[UIView alloc] initWithFrame: CGRectMake(0, 80, 320, 36)];
        [self.contentView addSubview: _subView];
        _subView.userInteractionEnabled = YES;
        
        // 添加按钮
        NSArray *subButtonName = @[@[@"down_mv", @"down_mv_sel"], @[@"addfav_mv", @"addfav_mv_sel"], @[@"share_mv", @"share_mv_sel"], @[@"addyuedan_mv", @"addyuedan_mv_sel"]];
        
        for (NSInteger index = 0; index < 4; ++index)
        {
            UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
            button.frame = CGRectMake(index *80, 0, 80, 36);
            [button setBackgroundImage: [UIImage imageNamed: subButtonName[index][0]] forState: UIControlStateNormal];
            [button setBackgroundImage: [UIImage imageNamed: subButtonName[index][1]] forState: UIControlStateHighlighted];
            [button addTarget: self action: @selector(clickMV:) forControlEvents: UIControlEventTouchUpInside];
            button.tag = 900 + index;
            [_subView addSubview: button];
        }
        
        // 设置分割线
        _separator = [[UILabel alloc] initWithFrame: CGRectMake(0, 35, 320, 1)];
        _separator.backgroundColor = [UIColor colorWithRed: 61 / 256.0 green: 70 / 256.0 blue: 232 / 256.0 alpha: 1.0];
        [_subView addSubview: _separator];
        
        _subView.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) clickMore
{
    if (_videoBlock != nil)
    {
        _videoBlock(YES);
    }
}

- (void) setSearchVideoCellWith: (HXVideoModel *)videoModel With:(SearchVideoBlock)videoblock
{
    [_image setImageWithURL: [NSURL URLWithString: videoModel.posterPicture]];
    _title.text = videoModel.title;
    _artist.text = videoModel.artistName;
    
    _hdurl = videoModel.hdUrl;
    
    _videoBlock = videoblock;
    
    _videoModel = videoModel;
    
    // 隐藏
    _subView.hidden = !videoModel.hide;
}

- (void) clickMV: (UIButton *)sender
{
    NSString *message = nil;
    NSLog(@"%ld", (long)sender.tag);
    
    switch (sender.tag - 900)
    {
        case 0:
        {
            message = @"加入下载队列";
            break;
        }
            
        case 1:
        {
            message = @"收藏成功";
            // 搜索请求
            NSFetchRequest *requst = [[NSFetchRequest alloc] initWithEntityName: @"HXVideoCollectionModel"];
            
            // 过滤条件
            NSPredicate *predicate = [NSPredicate predicateWithFormat: @"number=%@", _videoModel.idNumber];
            
            [requst setPredicate: predicate];
            
            NSArray *dataArray = [_app.managedObjectContext executeFetchRequest: requst error: nil];
            
            if (dataArray.count != 0)
            {
                return;
            }
            
            HXVideoCollectionModel * videoCollectionModel = [NSEntityDescription insertNewObjectForEntityForName: @"HXVideoCollectionModel" inManagedObjectContext: _app.managedObjectContext];
            
            [videoCollectionModel setValue: _videoModel.posterPicture forKey: @"image"];
            [videoCollectionModel setValue: _videoModel.hdUrl forKey: @"hdurl"];
            [videoCollectionModel setValue: _videoModel.title forKey: @"title"];
            [videoCollectionModel setValue: _videoModel.idNumber forKey: @"number"];
            [videoCollectionModel setValue: _videoModel.artistName forKey: @"artist"];
    
            [_app saveContext];
            
            break;
        }
            
        case 2:
        {
            message = @"微信分享";
            // 微信分享
            WXMediaMessage *mediaMesaage = [WXMediaMessage message];
            mediaMesaage.title = _title.text;
            mediaMesaage.description = _artist.text;
            
            NSLog(@"%@", mediaMesaage.description);
            [mediaMesaage setThumbImage: _image.image];
            
            WXVideoObject *videoObject = [WXVideoObject object];
            videoObject.videoUrl = _hdurl;
            
            mediaMesaage.mediaObject = videoObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = mediaMesaage;
            req.scene = 1;
            
            [WXApi sendReq: req];
            break;
        }
            
        case 3:
        {
            message = @"加入悦单";
            break;
        }
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示" message: message delegate: nil cancelButtonTitle: nil otherButtonTitles: @"确定", nil];
    [alert show];
}

@end
