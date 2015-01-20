//
//  HXVideoView.h
//  HXVideoPlayer
//
//  Created by huangxiong on 14-9-9.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

/**
 *  播放器
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HXVideoView : UIView

- (void) setPlayer: (AVPlayer *)player;

- (AVPlayer *) player;

@end
