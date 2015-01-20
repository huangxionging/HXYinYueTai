//
//  HXVideoView.m
//  HXVideoPlayer
//
//  Created by huangxiong on 14-9-9.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXVideoView.h"

@implementation HXVideoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// 重写class方法
+ (Class) layerClass
{
    return [AVPlayerLayer class];
}

// 设置播放器
- (void) setPlayer: (AVPlayer *)player
{
    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    
    layer.player = player;
}

// 获取播放器
- (AVPlayer *) player
{
    return ((AVPlayerLayer *)self.layer).player;
}

@end
