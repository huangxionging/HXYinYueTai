//
//  HXMoreViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-14.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HXMoreViewController.h"
#import "AFNetworking.h"
#import "HXAreaModel.h"
#import "HXVChartCell.h"
#import "HXSearchVideoCell.h"
#import "HXArtistModel.h"
#import "HXPlayVListViewController.h"
#import "HXServiceViewController.h"
#define TITLE_WIDTH (150)                                       // 标题宽度
#define LABEL_WIDTH (64)                                        // 标签宽度
#define LABEL_COUNT (24)                                        // 标签个数

@interface HXMoreViewController ()<UIScrollViewDelegate, MJRefreshBaseViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *videoAreaArray;   // 区域列表
@property (nonatomic, strong) NSMutableArray *videoListArray;   // 榜单列表
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;          // 网络管理器
@property (nonatomic, assign) NSInteger page;                   // 页码
@property (nonatomic, assign) BOOL isModal;
@property (nonatomic, strong) UIImageView *navigationBar;       // 导航条
@property (nonatomic, strong) MPMoviePlayerViewController *videoViewController;// 视频播放器

@end

@implementation HXMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        // 数组初始化
        _videoListArray  = [[NSMutableArray alloc] init];
        
        _videoAreaArray = [[NSMutableArray alloc] init];
        
        _currentHighlight = 0;
        
        // 页码
        _page = 0;
        
        _isModal = NO;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    // 发送展示导航栏通知
    [[NSNotificationCenter defaultCenter] postNotificationName: HIDE_NAVIGATION_BAR  object: nil];
    
    // 发送展示tabBar通知
    [[NSNotificationCenter defaultCenter] postNotificationName: HIDE_TAB_BAR object: nil];
    
    if (_isModal == NO)
    {
        _area.contentOffset = CGPointMake(LABEL_WIDTH * 10, 0);
        [self connectNetWork];
    }
    else
    {
        _isModal = NO;
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    // 注销定时器
    if (!_isModal)
    {
        [_timer invalidate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 创建线程
    _customQueue = dispatch_queue_create("myQueue",  DISPATCH_QUEUE_CONCURRENT);
    
    // 设置导航条
    [self setNavigationBar];
    
    // 设置滚动视图
    [self setArea];
    
    
    // 设置表视图
    [self setMoreTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark---到fan口袋
- (void) moveToFan
{
    HXServiceViewController *serviceViewController = [[HXServiceViewController alloc] init];
    
    serviceViewController.url = @"http://mapi.yinyuetai.com/yyt/star?deviceinfo=%7B%22aid%22%3A%2210201024%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.1%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22HUAWEI%20Y300-0000%22%2C%22cr%22%3A%2246001%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%22083df690358ed0c7ca179654e8010c33%22%2C%22clid%22%3A110033000%7D";
    
    
    serviceViewController.titleString = @"口袋 ✪ Fan";
    
    serviceViewController.isModal = YES;
    
    // 出现风格
    serviceViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController: serviceViewController animated: YES completion: nil];
}

#pragma mark---返回按钮事件
- (void) back
{
    [self.navigationController popViewControllerAnimated: NO];
}

#pragma mark---联网请求区域
- (void) connectNetWork
{
    _page = 0;
    
    for (NSInteger index = _currentHighlight; index < LABEL_COUNT; index += 5)
    {
        ((UILabel *)[_area viewWithTag: index + 1200]).textColor = [UIColor colorWithRed: 81 / 256.0 green: 100 / 256.0 blue: 229 / 256.0 alpha: 1.0];
    }
    
    _currentHighlight = 0;
    
   
    
    dispatch_async(_customQueue, ^
   {
       _manager = [AFHTTPRequestOperationManager manager];
       
       // 获取开始页面
       [_manager GET: GET_AREA  parameters: @{ @"deviceinfo": DEVICEINFO, @"type" : _parameter}  success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            // 移除所有元素
            [_videoAreaArray removeAllObjects];
            
            for (NSDictionary *dict in responseObject)
            {
                HXAreaModel *areaModel = [[HXAreaModel alloc] init];
                
                areaModel.arearName = dict[@"name"];
                
                areaModel.code = dict[@"code"];
                
                [_videoAreaArray addObject: areaModel];
            }
            
            [self reloadArea];
            
            [self requestVChartWith: ((HXAreaModel *)_videoAreaArray[_currentHighlight]).code];
        }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"%@", error);
        }];
   });
}


#pragma mark---设置表视图
- (void) setMoreTableView
{
    _moreTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, _area.frame.origin.y + _area.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _area.frame.origin.y - _area.frame.size.height) style: UITableViewStylePlain];
    
    
    _moreTableView.dataSource = self;
    
    _moreTableView.delegate = self;
    
    _moreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview: _moreTableView];
    
    // 注册
    [_moreTableView registerClass: [HXSearchVideoCell class] forCellReuseIdentifier: @"Cell"];
    
    _headRefreshView = [[MJRefreshHeaderView alloc] initWithScrollView: _moreTableView andDelegate: self];
    
    _footRefreshView = [[MJRefreshFooterView alloc] initWithScrollView: _moreTableView andDelegate: self];
    
    [_headRefreshView endRefreshing];
    
    [_footRefreshView endRefreshing];
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
        _page += 20;
    }
    
    if (_videoAreaArray.count != 0)
    {
        [self requestVChartWith: ((HXAreaModel *)_videoAreaArray[_currentHighlight]).code];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector: @selector(endRefreshing) userInfo: nil repeats: NO];
    }
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
    [_moreTableView reloadData];
}


#pragma mark---设置滚动视图
- (void) setArea
{
    // 初始化
    _area = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, 40)];
    
    // 添加到视图
    [self.view addSubview: _area];
    
    // 背景颜色
    _area.backgroundColor = [UIColor colorWithRed: 235 / 256.0 green: 235 / 256.0 blue: 246 / 256.0 alpha: 0.8];
    
    _area.delegate = self;
    
    _area.contentSize = CGSizeMake(LABEL_COUNT * LABEL_WIDTH, _area.frame.size.height);
    
    
    for (NSInteger index = 0; index < LABEL_COUNT; ++index)
    {
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(index * LABEL_WIDTH, 0, LABEL_WIDTH, _area.frame.size.height)];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.tag = 1200 + index;
        
        // 添加点击手势
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapLabel:)];
        
        tapOne.numberOfTapsRequired = 1;
        
        tapOne.numberOfTouchesRequired = 1;
        
        [label addGestureRecognizer: tapOne];
        
        label.textColor = [UIColor colorWithRed: 81 / 256.0 green: 100 / 256.0 blue: 229 / 256.0 alpha: 1.0];
        
        [_area addSubview: label];
        
        label.userInteractionEnabled = YES;
    }
    
    _area.showsHorizontalScrollIndicator = NO;
    
}

#pragma mark---UIScrollView Delegate
-(void) scrollViewWillBeginDecelerating: (UIScrollView *)scrollView
{
    if (scrollView == _moreTableView)
    {
        return;
    }
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
}

- (void) reloadArea
{
    for (NSInteger index1 = 0, index2 = 0; index1 < LABEL_COUNT; ++index1, ++index2)
    {
        
        if (index2 == _videoAreaArray.count)
        {
            index2 = 0;
        }
        UILabel *label = (UILabel *)[_area viewWithTag: 1200 + index1];
        
        label.text = ((HXAreaModel *)_videoAreaArray[index2]).arearName;
    }
    
    
    // 每隔0.3s监测一次
    _timer = [NSTimer scheduledTimerWithTimeInterval: 0.2 target: self selector: @selector(monitorScrollView) userInfo: nil repeats: YES];
    
    // 加上这句话使得定时器不会滚动视图被阻塞
    [[NSRunLoop currentRunLoop] addTimer: _timer forMode: NSRunLoopCommonModes];
    
    for (NSInteger index = _currentHighlight; index < LABEL_COUNT; index += 6)
    {
        ((UILabel *)[_area viewWithTag: index + 1200]).textColor = [UIColor colorWithRed: 100 / 256.0 green: 203 / 256.0 blue: 150 / 256.0 alpha: 1.0];
    }
}

#pragma mark---定时器响应
- (void) monitorScrollView
{
    NSInteger shouldHilight = (((NSInteger)_area.contentOffset.x + 160) / LABEL_WIDTH) % 6;
    if (_area.contentOffset.x == _currentLocal)
    {
        NSInteger index = (_area.contentOffset.x + LABEL_WIDTH / 2) / LABEL_WIDTH;
        
        _area.contentOffset = CGPointMake(index * LABEL_WIDTH, 0);
        
        if (_area.contentOffset.x <= LABEL_WIDTH * 6)
        {
            _area.contentOffset = CGPointMake(_area.contentOffset.x + _area.frame.size.width, 0);
        }
        
        if (_area.contentOffset.x >= LABEL_WIDTH * 12)
        {
            _area.contentOffset = CGPointMake(_area.contentOffset.x - _area.frame.size.width, 0);
        }
    }
    else if(shouldHilight != _currentHighlight)
    {
        if (_currentHighlight != shouldHilight)
        {
            _page = 0;
            
            [_moreTableView reloadData];
            
            
            [self requestVChartWith: ((HXAreaModel *)_videoAreaArray[shouldHilight]).code];
        }
        
        for (NSInteger index = _currentHighlight; index < LABEL_COUNT; index += 6)
        {
            ((UILabel *)[_area viewWithTag: index + 1200]).textColor = [UIColor colorWithRed: 81 / 256.0 green: 100 / 256.0 blue: 229 / 256.0 alpha: 1.0];
        }
        
        _currentHighlight = shouldHilight;
        
        
        for (NSInteger index = shouldHilight; index < LABEL_COUNT; index += 6)
        {
            ((UILabel *)[_area viewWithTag: index + 1200]).textColor = [UIColor colorWithRed: 100 / 256.0 green: 203 / 256.0 blue: 150 / 256.0 alpha: 1.0];
        }
    }
    _currentLocal = _area.contentOffset.x;
    
}


#pragma mark---点击tapLabel
- (void) tapLabel: (UITapGestureRecognizer *)sender
{
    NSInteger tag = (sender.view.tag - 1200) % 6;
    
    if (_currentHighlight != tag)
    {
        _page = 0;
        
        [_moreTableView reloadData];
        
        
        [self requestVChartWith: ((HXAreaModel *)_videoAreaArray[tag]).code];
    }
    
    
    for (NSInteger index = _currentHighlight; index < LABEL_COUNT; index += 6)
    {
        ((UILabel *)[[sender.view superview] viewWithTag: index + 1200]).textColor = [UIColor colorWithRed: 81 / 256.0 green: 100 / 256.0 blue: 229 / 256.0 alpha: 1.0];
    }
    
    _currentHighlight = tag;
    
    for (NSInteger index = tag; index < LABEL_COUNT; index += 6)
    {
        ((UILabel *)[[sender.view superview] viewWithTag: index + 1200]).textColor = [UIColor colorWithRed: 100 / 256.0 green: 203 / 256.0 blue: 150 / 256.0 alpha: 1.0];
    }
    
    
    NSInteger number = 128 - [_area convertPoint: sender.view.frame.origin toView: self.view].x;
    
    // 移动到中间去
    _area.contentOffset = CGPointMake(_area.contentOffset.x - number , 0);
    
    
}

#pragma mark---UITableView Datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_videoListArray.count == 0)
    {
        return 5;
    }
    return _videoListArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSearchVideoCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    
    if (_videoListArray.count != 0)
    {
        [cell setSearchVideoCellWith: _videoListArray[indexPath.row] With:^(BOOL hide)
        {
            HXVideoModel *videoModel = (HXVideoModel *)_videoListArray[indexPath.row];
            
            videoModel.hide = !videoModel.hide;
            
            [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
        }];
    }
    
    
    return cell;
}

#pragma mark---UITableView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_videoListArray.count != 0 && ((HXVideoModel *)_videoListArray[indexPath.row]).hide)
    {
        return 116;
    }
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果数组长度为0，则不做任何操作
    if (_videoListArray.count == 0)
    {
        return;
    }
    
    // 表示是模态出来的
    _isModal = YES;
    
    // 创建视频播放控制器
    _videoViewController = [[MPMoviePlayerViewController alloc] initWithContentURL: [NSURL URLWithString: ((HXVideoModel *)_videoListArray[indexPath.row]).hdUrl]];
    [self.navigationController presentMoviePlayerViewControllerAnimated: _videoViewController];
}

#pragma mark网络请求打榜数据
- (void) requestVChartWith: (NSString *)area
{
    // 添加线程锁
    @synchronized(self)
    {
        dispatch_async(_customQueue, ^
       {
           
           [_manager GET: GET_VIDEO_LIST parameters: @{@"deviceinfo": DEVICEINFO, @"area" : area, @"supportBanner" : @"true", @"offset" : [NSString stringWithFormat: @"%ld", (long)_page], @"size" : @"20"} success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                if (_page == 0)
                {
                    [_videoListArray removeAllObjects];
                }
                
                for (NSDictionary *dict in responseObject[@"videos"])
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
                    
                    // 加入到数组
                    [_videoListArray addObject: videoModel];
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


#pragma mark---析构
- (void)dealloc
{
    // 移除监听
    [_headRefreshView free];
    
    // 移除监听
    [_footRefreshView free];
    
    [self.view removeFromSuperview];
    
}

@end