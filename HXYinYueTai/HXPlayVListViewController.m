//
//  HXPlayVListViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-10.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXPlayVListViewController.h"
#import "HXServiceViewController.h"
#import "AFNetworking.h"
#import "HXRelativeVideosModel.h"
#import "HXSearchVideoCell.h"
#import "HXVideoCommentModel.h"
#import "HXVideoCommentCell.h"


#define TITLE_WIDTH (200)

@interface HXPlayVListViewController ()<UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>

@property (nonatomic, strong) AVPlayerItem *item;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, assign) BOOL isModal;

@property (nonatomic, strong) HXRelativeVideosModel *relativeModel;

@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UILabel *totalViewsLabel;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, assign) UIInterfaceOrientation orientation;

@property (nonatomic, assign) BOOL isFirstCreate;

@end

@implementation HXPlayVListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _isModal = NO;
        _page = 0;
        _commentArray = [[NSMutableArray alloc] init];
        _isFirstCreate = YES;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    if (_isModal == NO)
    {
        [self connectNetWork];
    }
    else
    {
        _isModal = NO;
    }
}

#pragma mark---联网请求区域
- (void) connectNetWork
{
    if (_relativeModel == nil)
    {
        _relativeModel = [[HXRelativeVideosModel alloc] init];
    }
    
    [_relativeModel.relativeVideos removeAllObjects];
    
    @synchronized(self)
    {
        dispatch_async(_customQueue, ^
        {
            [_manager GET: GET_VIDEO_RELATIVE parameters: @{@"deviceinfo": DEVICEINFO, @"relatedVideos" : @"true", @"id" : [NSString stringWithFormat: @"%@", _idNumber]} success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                _relativeModel.videoModel.idNumber = responseObject[@"id"];
                _relativeModel.videoModel.title = responseObject[@"title"];
                _relativeModel.videoModel.descriptionInfo = [responseObject[@"description"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                // id
                _relativeModel.videoModel.idNumber = responseObject[@"id"];
                
                // title
                _relativeModel.videoModel.title = responseObject[@"title"];
                
                // description
                _relativeModel.videoModel.descriptionInfo = responseObject[@"description"];
                
                // 艺术家
                for (NSDictionary *artistDict in responseObject[@"artists"])
                {
                    HXArtistModel *artist = [[HXArtistModel alloc] init];
                    
                    artist.artistId = artistDict[@"artistId"];
                    
                    artist.artistName = artistDict[@"artistName"];
                    
                    [_relativeModel.videoModel.artists addObject: artist];
                }
                
                // artistName
                _relativeModel.videoModel.artistName = responseObject[@"artistName"];
                
                // 海报
                _relativeModel.videoModel.posterPicture = responseObject[@"posterPic"];
                
                // 缩略图
                _relativeModel.videoModel.thumbnailPicture = responseObject[@"thumbnailPic"];
                
                // albumImg
                _relativeModel.videoModel.albumImage = responseObject[@"albumImg"];
                
                // url
                _relativeModel.videoModel.url = responseObject[@"url"];
                
                // hdUrl
                _relativeModel.videoModel.hdUrl = responseObject[@"hdUrl"];
                
                // uhdUrl
                _relativeModel.videoModel.uhdUrl = responseObject[@"uhdUrl"];
                
                // shdUrl
                _relativeModel.videoModel.shdUrl = responseObject[@"shdUrl"];
                
                // videoSize
                _relativeModel.videoModel.videoSize = responseObject[@"videoSize"];
                
                // hd
                _relativeModel.videoModel.hdVideoSize = responseObject[@"hdVideoSize"];
                
                // uhd
                _relativeModel.videoModel.uhdVideoSize = responseObject[@"uhdVideoSize"];
                
                // shd
                _relativeModel.videoModel.shdVideoSize = responseObject[@"shdVideoSize"];
                
                // status
                _relativeModel.videoModel.status = responseObject[@"status"];
                
                // duration
                _relativeModel.videoModel.duration = responseObject[@"duration"];
                
                // promoTitle
                _relativeModel.videoModel.promoTitle = responseObject[@"promoTitle"];
                
                // playListPic
                _relativeModel.videoModel.playListPicture = responseObject[@"playListPic"];
                
                _relativeModel.regdate = responseObject[@"regdate"];
                
                _relativeModel.totalViews = responseObject[@"totalViews"];
                
                _relativeModel.totalComments = responseObject[@"totalComments"];
                
                for (NSDictionary *dict in responseObject[@"relatedVideos"])
                {
                    HXVideoModel *videoModel = [[HXVideoModel alloc] init];
                    
                    // id
                    videoModel.idNumber = dict[@"id"];
                    
                    // title
                    videoModel.title = dict[@"title"];
                    
                    // description
                    videoModel.descriptionInfo = dict[@"description"];
                    
                    // 艺术家
                    for (NSDictionary *artistDict in dict[@"artists"])
                    {
                        HXArtistModel *artist = [[HXArtistModel alloc] init];
                        
                        artist.artistId = artistDict[@"artistId"];
                        
                        artist.artistName = artistDict[@"artistName"];
                        
                        [videoModel.artists addObject: artist];
                    }
                    
                    // artistName
                    videoModel.artistName = dict[@"artistName"];
                    
                    // 海报
                    videoModel.posterPicture = dict[@"posterPic"];
                    
                    // 缩略图
                    videoModel.thumbnailPicture = dict[@"thumbnailPic"];
                    
                    // albumImg
                    videoModel.albumImage = dict[@"albumImg"];
                    
                    // url
                    videoModel.url = dict[@"url"];
                    
                    // hdUrl
                    videoModel.hdUrl = dict[@"hdUrl"];
                    
                    // uhdUrl
                    videoModel.uhdUrl = dict[@"uhdUrl"];
                    
                    // shdUrl
                    videoModel.shdUrl = dict[@"shdUrl"];
                    
                    // videoSize
                    videoModel.videoSize = dict[@"videoSize"];
                    
                    // hd
                    videoModel.hdVideoSize = dict[@"hdVideoSize"];
                    
                    // uhd
                    videoModel.uhdVideoSize = dict[@"uhdVideoSize"];
                    
                    // shd
                    videoModel.shdVideoSize = dict[@"shdVideoSize"];
                    
                    // status
                    videoModel.status = dict[@"status"];
                    
                    // duration
                    videoModel.duration = dict[@"duration"];
                    
                    // promoTitle
                    videoModel.promoTitle = dict[@"promoTitle"];
                    
                    // playListPic
                    videoModel.playListPicture = dict[@"playListPic"];
                    
                    [_relativeModel.relativeVideos addObject: videoModel];
                }
                [self refreshLeftScrollView];
                
                [self setVideoPlay];
                
                [_rightTableView reloadData];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
            }];
        });
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 创建线程
    _customQueue = dispatch_queue_create("myQueue",  DISPATCH_QUEUE_CONCURRENT);
    
    _manager = [AFHTTPRequestOperationManager manager];

    [self setNavigationBar];
    
    [self setVideoView];
    
    [self setAnimation];
    
    [self setToolView];
    
    [self setPlayOrStopButton];
    
    [self setButtons];
    
    [self setPlayScrollView];
    
    [self setProgressSlider];
    
    [self setCurrentTime];
    
    [self setTotalTime];
    
    [self setTableView];
    
    [self setLeftScrollView];
}

- (void) setVideoPlay
{
    _item = [[AVPlayerItem alloc] initWithURL: [NSURL URLWithString: _relativeModel.videoModel.uhdUrl]];
    
    _player = [[AVPlayer alloc] initWithPlayerItem: _item];
    _player.allowsExternalPlayback = YES;
    
    [_videoView setPlayer: _player];
    
    [_item addObserver: self forKeyPath: @"status" options: NSKeyValueObservingOptionNew context: nil];
}

#pragma mark---设置导航栏
- (void) setNavigationBar
{
    // 初始化
    _navigationBar = [[UIImageView alloc] initWithFrame: CGRectMake(0, 20, self.view.frame.size.width, 44)];
    
    [self.view addSubview: _navigationBar];
    
    // 允许交互
    _navigationBar.userInteractionEnabled = YES;
    
    // 图片
    _navigationBar.image = [UIImage imageNamed: @"navigationBar"];
    
    // 在导航栏上放置返回按钮
    
    UIButton *back = [UIButton buttonWithType: UIButtonTypeCustom];
    
    // 设置按钮大小
    back.frame = CGRectMake(0, 0, 44, 44);
    
    // 设置图片
    [back setBackgroundImage: [UIImage imageNamed: @"back_btn"] forState: UIControlStateNormal];
    
    [back setBackgroundImage: [UIImage imageNamed: @"back_btn_p"] forState: UIControlStateHighlighted];
    
    // 添加事件
    [back addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    
    [_navigationBar addSubview: back];
    
    // 添加Label设置标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake((_navigationBar.frame.size.width - TITLE_WIDTH) / 2, 0, TITLE_WIDTH, 44)];
    
    // 字体颜色
    titleLabel.textColor = [UIColor whiteColor];
    
    // 排版
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    titleLabel.text = _titleString;
    
    [_navigationBar addSubview: titleLabel];
    
    // 口袋 Fan按钮
    UIButton *movieGameCentre = [UIButton buttonWithType: UIButtonTypeCustom];
    
    movieGameCentre.frame = CGRectMake(_navigationBar.frame.size.width - 44, 0, 44, 44);
    
    // 标记
    movieGameCentre.tag = 201;
    
    [movieGameCentre setBackgroundImage: [UIImage imageNamed:@"Movie_gamecentre"] forState: UIControlStateNormal];
    
    [movieGameCentre setBackgroundImage: [UIImage imageNamed: @"Movie_gamecentre_Sel"] forState: UIControlStateHighlighted];
    
    // 添加事件
    [movieGameCentre addTarget: self action: @selector(moveToFan) forControlEvents: UIControlEventTouchUpInside];
    
    [_navigationBar addSubview: movieGameCentre];
    
}

#pragma mark---返回按钮事件
- (void) back
{
    [_item removeObserver: self forKeyPath: @"status" context: nil];
    [_player cancelPendingPrerolls];
    [_player pause];
    _player = nil;
    _item = nil;
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark---到fan口袋
- (void) moveToFan
{
    [_player pause];
    _isModal = YES;
    _playOrStopButton.selected = NO;
    HXServiceViewController *serviceViewController = [[HXServiceViewController alloc] init];
    
    serviceViewController.url = @"http://mapi.yinyuetai.com/yyt/star?deviceinfo=%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.1%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22HUAWEI%20Y300-0000%22%2C%22cr%22%3A%2246001%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22083df690358ed0c7ca179654e8010c33%22%2C%22clid%22%3A110033000%7D";
    
    
    serviceViewController.titleString = @"口袋 ✪ Fan";
    
    serviceViewController.isModal = YES;
    
    // 出现风格
    serviceViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController: serviceViewController animated: YES completion: nil];
}

#pragma mark---实现KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"status"])
    {
        if ([change[@"new"] integerValue] == AVPlayerStatusReadyToPlay)
        {
            [_animation removeFromSuperview];
            [_player play];
            CGFloat timescale =   _item.duration.timescale;
            CGFloat total = _item.duration.value / timescale;
            _totalTime.text = [NSString stringWithFormat: @"/%02ld:%02ld", (long) total / 60, (long) total % 60];

            HXPlayVListViewController *viewContrller = self;
            [_player addPeriodicTimeObserverForInterval: CMTimeMake(1, 1) queue: nil usingBlock:^(CMTime time)
             {
                 CGFloat timescale =  viewContrller.item.currentTime.timescale;
                 if (!timescale)
                 {
                     return;
                 }
                 CGFloat current = viewContrller.item.currentTime.value / timescale;
                 viewContrller.currentTime.text = [NSString stringWithFormat: @"%02ld:%02ld", (long) current / 60, (long) current % 60];
                 viewContrller.progressSlider.value = current / total;
             }];
        }
    }
}

#pragma mark---设置视频视图
- (void) setVideoView
{
    _orientation = UIInterfaceOrientationPortrait;
    _videoView = [[HXVideoView alloc] init];
    
    [self setVideoViewFrameWith: self.interfaceOrientation];
    
    [self.view addSubview: _videoView];
    
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapOneClick:)];
    tapOne.numberOfTapsRequired = 1;
    tapOne.numberOfTouchesRequired = 1;
    [_videoView addGestureRecognizer: tapOne];
    
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapTwoClick:)];
    tapTwo.numberOfTapsRequired = 2;
    tapTwo.numberOfTouchesRequired = 1;
    [_videoView addGestureRecognizer: tapTwo];

    [tapOne requireGestureRecognizerToFail: tapTwo];
    
    _videoView.backgroundColor = [UIColor blackColor];
}

#pragma mark----单击手势
- (void)tapOneClick: (UITapGestureRecognizer *)sender
{
    _toolView.hidden = !_toolView.hidden;
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval: 3.0f target: self selector: @selector(toolViewHide) userInfo: nil repeats: NO];
    [[NSRunLoop currentRunLoop] addTimer: _timer forMode: NSRunLoopCommonModes];
}

#pragma mark---隐藏
- (void)toolViewHide
{
    [_timer invalidate];
    _toolView.hidden = YES;
}

#pragma mark----双击手势
- (void)tapTwoClick: (UITapGestureRecognizer *)sender
{
    _isFullScreen = !_isFullScreen;
    if (_isFullScreen == YES)
    {
        _videoView.frame = self.view.frame;
        _playScrollView.hidden = YES;
        _descriptionInfo.hidden = YES;
        _relate.hidden = YES;
        _comment.hidden = YES;
    }
    else
    {
        [self setVideoViewFrameWith: UIInterfaceOrientationPortrait];
        _playScrollView.hidden = NO;
        _descriptionInfo.hidden = NO;
        _relate.hidden = NO;
        _comment.hidden = NO;
    }
    
    [self setToolViewFrame];
}

#pragma mark---设置视频视图的frame
- (void) setVideoViewFrameWith: (UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        if (_orientation == UIInterfaceOrientationPortrait) {
            _videoView.frame = CGRectMake(0, 64, self.view.frame.size.width, 180);
        }
        else {
            _videoView.frame = CGRectMake(0, 64, self.view.frame.size.height, 180);
        }
        _orientation = UIInterfaceOrientationPortrait;
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        if (_orientation == UIInterfaceOrientationLandscapeRight) {
            _videoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }
        else {
            _videoView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        }
        _orientation = UIInterfaceOrientationLandscapeLeft;
        
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        if (_orientation == UIInterfaceOrientationLandscapeLeft) {
            _videoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }
        else {
            _videoView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        }
        _orientation = UIInterfaceOrientationLandscapeRight;
        
    }
    
    if (_animation != nil)
    {
        _animation.frame = _videoView.frame;
    }
}

#pragma mark---设置gif动画
- (void) setAnimation
{
    _animation = [[FLAnimatedImageView alloc] initWithFrame: _videoView.frame];
    
    _animation.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData: [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"loadingplay" ofType: @"gif"]]];
    
    [self.view addSubview: _animation];
}

#pragma mark---设置工具视图
- (void) setToolView
{
    _toolView = [[UIView alloc] init];
    [_videoView addSubview: _toolView];
    _toolView.backgroundColor = [UIColor blackColor];
    _toolView.alpha = 0.8;
    
    _toolView.hidden = YES;
    
    [self setToolViewFrame];
}

#pragma mark---设置工具视图的frame
- (void) setToolViewFrame
{
    _toolView.frame = CGRectMake(0, _videoView.frame.size.height - 40, _videoView.frame.size.width, 40);
}

- (void) setProgressSlider
{
    _progressSlider = [[UISlider alloc] init];
    
    [_toolView addSubview: _progressSlider];
    
    [_progressSlider setMaximumTrackImage: [UIImage imageNamed: @"mv_maximumtrackImage"] forState: UIControlStateNormal];

    [_progressSlider setMinimumTrackImage: [UIImage imageNamed: @"mv_minimumtrackImage"] forState: UIControlStateNormal];
    
    [_progressSlider setThumbImage: [UIImage imageNamed: @"mv_thumbImage"] forState: UIControlStateNormal];
    
    [_progressSlider addTarget: self action: @selector(changeProgress) forControlEvents: UIControlEventValueChanged];
    
    _progressSlider.minimumValue = 0.0;
    
    _progressSlider.maximumValue = 1.0;
    
    _progressSlider.value = 0;
    
    [self setProgressSliderFrame];
}

- (void) setProgressSliderFrame
{
    _progressSlider.frame = CGRectMake(_playOrStopButton.frame.origin.x + _playOrStopButton.frame.size.width + 5, 3, _toolView.frame.size.width - _playOrStopButton.frame.origin.x - _playOrStopButton.frame.size.width - 5 - 100, 34);
}

#pragma makr---滑块滑动事件
- (void)changeProgress
{
    CGFloat progress = _progressSlider.value * _item.duration.value;
    
    [_item seekToTime: CMTimeMake(progress, _item.duration.timescale)];
}

- (void) setTotalTime
{
    _totalTime = [[UILabel alloc] init];
    [_toolView addSubview: _totalTime];
    _totalTime.font = [UIFont systemFontOfSize: 13.0];
    _totalTime.textColor = [UIColor whiteColor];
    _totalTime.textAlignment = NSTextAlignmentCenter;
    [self setTotalTimeFrame];
}

- (void) setTotalTimeFrame
{
    _totalTime.frame = CGRectMake(_currentTime.frame.origin.x + _currentTime.frame.size.width , 10, 40, 20);
}

- (void) setCurrentTime
{
    _currentTime = [[UILabel alloc] init];
    [_toolView addSubview: _currentTime];
    _currentTime.font = [UIFont systemFontOfSize: 13.0];
    _currentTime.textColor = [UIColor whiteColor];
    _currentTime.textAlignment = NSTextAlignmentCenter;
    [self setCurrentTimeFrame];
}

- (void) setCurrentTimeFrame
{
    _currentTime.frame = CGRectMake(_progressSlider.frame.origin.x + _progressSlider.frame.size.width + 5, 10, 40, 20);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---设置滚动视图
- (void) setPlayScrollView
{
    _playScrollView = [[UIScrollView alloc] init];

    [self.view addSubview: _playScrollView];
    
    _playScrollView.scrollEnabled = NO;
    
    _playScrollView.contentSize = CGSizeMake(_playScrollView.frame.size.width *3, _playScrollView.frame.size.height);
    
    [self setPlayScrollViewFrameWith: UIInterfaceOrientationPortrait];
}

- (void) setPlayScrollViewFrameWith: (UIInterfaceOrientation)interfaceOrientation
{
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        
        if (_isFirstCreate == YES) {
            _isFirstCreate = NO;
            _playScrollView.frame = CGRectMake(0, _videoView.frame.origin.y + _videoView.frame.size.height + 40, self.view.frame.size.width, self.view.frame.size.height - 64 - _videoView.frame.size.height - 40);
            
            _playScrollView.contentOffset = CGPointMake(_playScrollView.frame.size.width * _currentPage, 0);
        }
        else {
            _playScrollView.hidden = NO;
        }
    }
    else {
        _playScrollView.hidden = YES;
    }
    
    NSLog(@"%@", NSStringFromCGRect(_playScrollView.frame));
}

#pragma mark---设置三个按钮
- (void) setButtons
{
    _currentPage = 0;
    
    _descriptionInfo = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [_descriptionInfo setBackgroundImage: [UIImage imageNamed:@"MV_describe"] forState: UIControlStateNormal];
    
    [_descriptionInfo setBackgroundImage: [UIImage imageNamed:@"MV_describe_p"] forState: UIControlStateSelected];
    
    _descriptionInfo.selected = YES;
    
    [self.view addSubview: _descriptionInfo];
    
    [_descriptionInfo
     addTarget: self action: @selector(clickMV:) forControlEvents: UIControlEventTouchUpInside];
    
    _descriptionInfo.tag = 1000;
    
    _comment = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [_comment setBackgroundImage: [UIImage imageNamed:@"MV_reply"] forState: UIControlStateNormal];
    
    [_comment setBackgroundImage: [UIImage imageNamed:@"MV_reply_p"] forState: UIControlStateSelected];
    [self.view addSubview: _comment];

    [_comment addTarget: self action: @selector(clickMV:) forControlEvents: UIControlEventTouchUpInside];
    
    _comment.tag = 1001;
    
    
    _relate = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [_relate setBackgroundImage: [UIImage imageNamed:@"MV_related"] forState: UIControlStateNormal];
    
    [_relate setBackgroundImage: [UIImage imageNamed:@"MV_related_p"] forState: UIControlStateSelected];
    
    [self.view addSubview: _relate];

    [_relate addTarget: self action: @selector(clickMV:) forControlEvents: UIControlEventTouchUpInside];
    
    _relate.tag = 1002;
    
    [self setButtonFrame];
}

- (void) clickMV: (UIButton *)sender
{
    if (sender == _comment && _comment.selected == NO)
    {
        _page = 0;
        [self requestNetWork];
    }
    
    _descriptionInfo.selected = NO;
    
    _comment.selected = NO;
    
    _relate.selected = NO;
    
    sender.selected = YES;
    
    _currentPage = sender.tag - 1000;
    
    _playScrollView.contentOffset = CGPointMake(_playScrollView.frame.size.width * _currentPage, 0);
    
   
}

- (void) setButtonFrame
{
    _descriptionInfo.frame = CGRectMake(10, _videoView.frame.origin.y + _videoView.frame.size.height + 5, 100, 30);
    
    _comment.frame = CGRectMake(_descriptionInfo.frame.origin.x + _descriptionInfo.frame.size.width, _videoView.frame.origin.y + _videoView.frame.size.height + 5, 100, 30);
    
    _relate.frame = CGRectMake(_comment.frame.origin.x + _comment.frame.size.width, _videoView.frame.origin.y + _videoView.frame.size.height + 5, 100, 30);
}

#pragma mark---设左边的滚动视图
- (void) setLeftScrollView
{
    _leftScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, _playScrollView.frame.size.width, _playScrollView.frame.size.height)];
    [_playScrollView addSubview: _leftScrollView];
    
    _titleLabel = [[UILabel alloc] init];
    [_leftScrollView addSubview: _titleLabel];
    
    _timeLabel = [[UILabel alloc] init];
    [_leftScrollView addSubview: _timeLabel];
    
    _timeLabel = [[UILabel alloc] init];
    [_leftScrollView addSubview: _timeLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    [_leftScrollView addSubview: _descriptionLabel];
    
    _totalViewsLabel = [[UILabel alloc] init];
    [_leftScrollView addSubview: _totalViewsLabel];
}

- (void) refreshLeftScrollView
{
    _titleLabel.font = [UIFont systemFontOfSize: 14.0];
    _titleLabel.frame = CGRectMake(10, 10, _leftScrollView.frame.size.width - 20, 20);
    _titleLabel.text =  _relativeModel.videoModel.title;
    
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize: 12.0];
    _timeLabel.frame = CGRectMake(10, 35, _leftScrollView.frame.size.width - 20, 20);
    _timeLabel.text = _relativeModel.regdate;
    
    _totalViewsLabel.textColor = [UIColor colorWithRed: 55 / 256.0 green: 223 / 256.0 blue: 150 / 256.0 alpha: 1.0];
    _totalViewsLabel.font = [UIFont systemFontOfSize: 12.0];
    _totalViewsLabel.frame = CGRectMake(10, 60, _leftScrollView.frame.size.width - 20, 20);
    _totalViewsLabel.text = [NSString stringWithFormat: @"播放次数: %@", _relativeModel.totalViews];
    
    _descriptionLabel.font = [UIFont systemFontOfSize: 13.0];
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize: 13.0]};
    
    CGSize size = [_relativeModel.videoModel.descriptionInfo boundingRectWithSize: CGSizeMake(300, 10000) options: NSStringDrawingUsesLineFragmentOrigin attributes: dict context: nil].size;
    
    _descriptionLabel.frame = CGRectMake(10, 90, 300, size.height);
    _descriptionLabel.text = _relativeModel.videoModel.descriptionInfo;
    _descriptionLabel.numberOfLines = 0;
    
    _leftScrollView.contentSize = CGSizeMake(0, _descriptionLabel.frame.size.height + _descriptionLabel.frame.origin.y + 30);
}

#pragma mark---设置表视图
- (void)setTableView
{
    _middleTableView = [[UITableView alloc] initWithFrame: CGRectMake(_playScrollView.frame.size.width, 0, _playScrollView.frame.size.width, _playScrollView.frame.size.height) style: UITableViewStylePlain];
    [_playScrollView addSubview: _middleTableView];
    _middleTableView.tag = 1100;
    _middleTableView.dataSource = self;
    _middleTableView.delegate = self;
    
    _headRefreshView = [[MJRefreshHeaderView alloc] initWithScrollView: _middleTableView andDelegate: self];
    
    _footRefreshView = [[MJRefreshFooterView alloc] initWithScrollView: _middleTableView andDelegate: self];
    
    [_headRefreshView endRefreshing];
    
    [_footRefreshView endRefreshing];
    
    
    _rightTableView = [[UITableView alloc] initWithFrame: CGRectMake(_playScrollView.frame.size.width * 2, 0, _playScrollView.frame.size.width, _playScrollView.frame.size.height) style: UITableViewStylePlain];
    _rightTableView.tag = 1101;
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    [_playScrollView addSubview: _rightTableView];
}

#pragma mark---MJRefreshBaseViewDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    _baseView = refreshView;
    
    if (refreshView == _headRefreshView)
    {
        _page = 0;
    }
    else
    {
        _page += 10;
    }
    
    [self requestNetWork];
}

- (void) endRefreshing
{
    if (_baseView == _headRefreshView)
    {
        [_headRefreshView endRefreshing];
    }
    else
    {
        [_footRefreshView endRefreshing];
    }
    [_middleTableView reloadData];
}

- (void) requestNetWork
{
    @synchronized(self)
    {
        dispatch_async(_customQueue, ^
        {
            [_manager GET: GET_VIDEO_COMMENT parameters: @{@"deviceinfo":  DEVICEINFO, @"offset" : [NSString stringWithFormat: @"%ld", (long)_page], @"videoId" : [NSString stringWithFormat: @"%@",_relativeModel.videoModel.idNumber], @"size" : @"10"}
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                if (_page == 0)
                {
                    [_commentArray removeAllObjects];
                }
                
                NSLog(@"%lu", (unsigned long)_commentArray.count);
                for (NSDictionary *dict in responseObject[@"comments"])
                {
                    HXVideoCommentModel *commentModel = [[HXVideoCommentModel alloc] init];
                    commentModel.commentID = dict[@"commentId"];
                    
                    commentModel.content = dict[@"content"];
                    
                    NSDictionary *fontDict = @{NSFontAttributeName: [UIFont systemFontOfSize: 17.0]};
                    
                    CGSize size = [commentModel.content boundingRectWithSize: CGSizeMake(260, 1000) options: NSStringDrawingUsesLineFragmentOrigin attributes: fontDict context: nil].size;
                    
                    commentModel.contentHeight = size.height;
                    
                    commentModel.userName = dict[@"userName"];
                    
                    commentModel.dateCreated = dict[@"dateCreated"];
                    
                    commentModel.headImage = dict[@"userHeadImg"];
                    
                    commentModel.floorInt = dict[@"floorInt"];
                    
                    commentModel.floor = dict[@"floor"];
                    
                    commentModel.userID = dict[@"userId"];
                    
                    [_commentArray addObject: commentModel];
                }
                [self endRefreshing];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
                [self endRefreshing];
            }];
        });
    }
}

#pragma mark---UITableView Datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    switch (tableView.tag - 1100)
    {
        case 0:
        {
            numberOfRows = _commentArray.count;
            break;
        }
        
        case 1:
        {
            numberOfRows = _relativeModel.relativeVideos.count;
            break;
        }
        default:
            break;
    }
    
    NSLog(@"%ld", (long)numberOfRows);
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (tableView.tag - 1100)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier: @"Cell0"];
            
            if (cell == nil)
            {
                cell = [[HXVideoCommentCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"Cell0"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            HXVideoCommentCell *cell1 = (HXVideoCommentCell *)cell;
            
            [cell1 setVideoCommentCellWith: _commentArray[indexPath.row]];
            
            break;
        }
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier: @"Cell1"];
            
            if (cell == nil)
            {
                cell = [[HXSearchVideoCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"Cell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            HXSearchVideoCell *cell1 = (HXSearchVideoCell *)cell;
            
            cell1.indexPath = indexPath;
            
            [cell1 setSearchVideoCellWith: _relativeModel.relativeVideos[indexPath.row] With:^(BOOL hide)
             {
                 HXVideoModel *videoModel = (HXVideoModel *)_relativeModel.relativeVideos[indexPath.row];
                 
                 videoModel.hide = !videoModel.hide;
                 
                 [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
             }];

        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark---UITableView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (tableView.tag - 1100)
    {
        case 0:
        {
            height = ((HXVideoCommentModel *)_commentArray[indexPath.row]).contentHeight + 90.0;
            break;
        }
            
        case 1:
        {
            if (_relativeModel.relativeVideos.count != 0 && ((HXVideoModel *)_relativeModel.relativeVideos[indexPath.row]).hide)
            {
                height = 116;
            }
            else
            {
                height = 80;
            }
            break;
        }
        default:
            break;
    }
    
    return height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag - 1100)
    {
        case 0:
            break;
            
        case 1:
        {
            [_player pause];
            [_player cancelPendingPrerolls];
            [_item removeObserver: self forKeyPath: @"status"];
            
            _item = [[AVPlayerItem alloc] initWithURL: [NSURL URLWithString: ((HXVideoModel *)_relativeModel.relativeVideos[indexPath.row]).hdUrl]];
            [_player replaceCurrentItemWithPlayerItem: _item];
            [_item addObserver: self forKeyPath: @"status" options: NSKeyValueObservingOptionNew context: nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark---屏幕支持的方向
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;//支持转屏
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setVideoViewFrameWith: toInterfaceOrientation];
    
    [self setToolViewFrame];
    
    if (_animation != nil)
    {
        _animation.frame = _videoView.frame;
    }
    
    [self setPlayScrollViewFrameWith: toInterfaceOrientation];
    
    [self setButtonFrame];
    
    [self setProgressSliderFrame];
    
    [self setCurrentTimeFrame];
    
    [self setTotalTimeFrame];
    
    if (toInterfaceOrientation != UIInterfaceOrientationPortrait)
    {
        _playScrollView.hidden = NO;
        _descriptionInfo.hidden = NO;
        _relate.hidden = NO;
        _comment.hidden = NO;
        ((UITapGestureRecognizer *)_videoView.gestureRecognizers[1]).enabled = NO;
        _isFullScreen = NO;
    }
    else
    {
        ((UITapGestureRecognizer *)_videoView.gestureRecognizers[1]).enabled = YES;
    }
}


- (void) setPlayOrStopButton
{
    _playOrStopButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    _playOrStopButton.frame = CGRectMake(3, 3, 34, 34);
    
    [_playOrStopButton setImage: [UIImage imageNamed: @"mv_stop"] forState: UIControlStateNormal];
    
    [_playOrStopButton setImage: [UIImage imageNamed: @"mv_play"] forState: UIControlStateSelected];
    
    [_playOrStopButton addTarget: self action: @selector(playOrStop) forControlEvents: UIControlEventTouchUpInside];
    
    [_toolView addSubview: _playOrStopButton];
}

#pragma mark--播放或暂停
- (void) playOrStop
{
    _playOrStopButton.selected = !_playOrStopButton.selected;
    if (_playOrStopButton.selected)
    {
        [_player pause];
    }
    else
    {
        [_player play];
    }
}

- (void) dealloc
{
    [_item removeObserver: self forKeyPath: @"status" context: nil];
    [_player cancelPendingPrerolls];
    [_player pause];
    _player = nil;
    _item = nil;
}

@end
