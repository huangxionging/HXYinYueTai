//
//  HXVTopListViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HXVTopListViewController.h"
#import "AFNetworking.h"
#import "HXAreaModel.h"
#import "HXVChartCell.h"
#import "HXVChartModel.h"
#import "HXArtistModel.h"
#import "HXPlayVListViewController.h"


#define LABEL_WIDTH (64)

#define LABEL_COUNT (20)


@interface HXVTopListViewController ()<UIScrollViewDelegate, MJRefreshBaseViewDelegate>


// 区域列表
@property (nonatomic, strong) NSMutableArray *vAreaArray;

// 榜单列表
@property (nonatomic, strong) NSMutableArray *VTopListArray;

// 网络管理器
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

// 页码
@property (nonatomic, assign) NSInteger page;

// 是否模态
@property (nonatomic, assign) BOOL isModal;

@end

@implementation HXVTopListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        // 数组初始化
        _VTopListArray  = [[NSMutableArray alloc] init];
        
        _vAreaArray = [[NSMutableArray alloc] init];
        
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
    [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_NAVIGATION_BAR  object: nil];
    
    // 发送展示tabBar通知
    [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_TAB_BAR object: nil];
    
    if (_isModal == NO)
    {
        _area.contentOffset = CGPointMake(LABEL_WIDTH * 8, 0);
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
    
    // 设置滚动视图
    [self setArea];
    
    // 设置工具视图
    [self setToolView];
    
    // 设置表视图
    [self setVTopListTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---联网请求区域
- (void) connectNetWork
{
    // 移除所有元素
    [_vAreaArray removeAllObjects];
    
    _page = 0;
    
    for (NSInteger index = _currentHighlight; index < LABEL_COUNT; index += 5)
    {
        ((UILabel *)[_area viewWithTag: index + 600]).textColor = [UIColor colorWithRed: 81 / 256.0 green: 100 / 256.0 blue: 229 / 256.0 alpha: 1.0];
    }
    
    _currentHighlight = 0;

    [_VTopListArray removeAllObjects];
    
    dispatch_async(_customQueue, ^
    {
        _manager = [AFHTTPRequestOperationManager manager];
        
        // 获取开始页面
        [_manager GET: GET_VCHART_AREA_LIST  parameters: @{ @"deviceinfo": DEVICEINFO}  success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            
            for (NSDictionary *dict in responseObject)
            {
                HXAreaModel *areaModel = [[HXAreaModel alloc] init];
                areaModel.arearName = dict[@"name"];
                areaModel.code = dict[@"code"];
                [_vAreaArray addObject: areaModel];
            }
            [self reloadArea];
            [self requestVChartWith: ((HXAreaModel *)_vAreaArray[_currentHighlight]).code];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"%@", error);
        }];
    });
}


#pragma mark---设置表视图
- (void) setVTopListTableView
{
    _vTopListTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, _toolView.frame.origin.y + _toolView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 113 - _area.frame.size.height - _toolView.frame.size.height) style: UITableViewStylePlain];
    _vTopListTableView.dataSource = self;
    _vTopListTableView.delegate = self;
    _vTopListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: _vTopListTableView];
    
    // 注册
    [_vTopListTableView registerNib: [UINib nibWithNibName: @"HXVChartCell" bundle: nil] forCellReuseIdentifier: @"Cell"];
    
    _headRefreshView = [[MJRefreshHeaderView alloc] initWithScrollView: _vTopListTableView andDelegate: self];
    _footRefreshView = [[MJRefreshFooterView alloc] initWithScrollView: _vTopListTableView andDelegate: self];
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
    
    if (_vAreaArray.count != 0)
    {
        [self requestVChartWith: ((HXAreaModel *)_vAreaArray[_currentHighlight]).code];
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
    [_vTopListTableView reloadData];
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
        label.tag = 600 + index;
        
        label.textColor = [UIColor colorWithRed: 81 / 256.0 green: 100 / 256.0 blue: 229 / 256.0 alpha: 1.0];
        [_area addSubview: label];
        label.userInteractionEnabled = YES;
        
        // 添加点击手势
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapLabel:)];
        tapOne.numberOfTapsRequired = 1;
        tapOne.numberOfTouchesRequired = 1;
        [label addGestureRecognizer: tapOne];
    }
    
    _area.showsHorizontalScrollIndicator = NO;

}

#pragma mark---UIScrollView Delegate
-(void) scrollViewWillBeginDecelerating: (UIScrollView *)scrollView
{
    if (scrollView == _vTopListTableView)
    {
        return;
    }
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
}

- (void) reloadArea
{
    for (NSInteger index1 = 0, index2 = 0; index1 < LABEL_COUNT; ++index1, ++index2)
    {
        
        if (index2 == _vAreaArray.count)
        {
            index2 = 0;
        }
        UILabel *label = (UILabel *)[_area viewWithTag: 600 + index1];
        
        label.text = ((HXAreaModel *)_vAreaArray[index2]).arearName;
    }
    
    
    // 每隔0.3s监测一次
    _timer = [NSTimer scheduledTimerWithTimeInterval: 0.2 target: self selector: @selector(monitorScrollView) userInfo: nil repeats: YES];
    
    // 加上这句话使得定时器不会滚动视图被阻塞
    [[NSRunLoop currentRunLoop] addTimer: _timer forMode: NSRunLoopCommonModes];
    
    for (NSInteger index = _currentHighlight; index < LABEL_COUNT; index += 5)
    {
        ((UILabel *)[_area viewWithTag: index + 600]).textColor = [UIColor colorWithRed: 100 / 256.0 green: 203 / 256.0 blue: 150 / 256.0 alpha: 1.0];
    }
}

#pragma mark---定时器响应
- (void) monitorScrollView
{
    NSInteger shouldHilight = (((NSInteger)_area.contentOffset.x + 160) / LABEL_WIDTH) % 5;
    if (_area.contentOffset.x == _currentLocal)
    {
        NSInteger index = (_area.contentOffset.x + LABEL_WIDTH / 2) / LABEL_WIDTH;
        
        _area.contentOffset = CGPointMake(index * LABEL_WIDTH, 0);
        
        if (_area.contentOffset.x <= LABEL_WIDTH * 5)
        {
            _area.contentOffset = CGPointMake(_area.contentOffset.x + _area.frame.size.width, 0);
        }
        
        if (_area.contentOffset.x >= LABEL_WIDTH * 10)
        {
            _area.contentOffset = CGPointMake(_area.contentOffset.x - _area.frame.size.width, 0);
        }
    }
    else if(shouldHilight != _currentHighlight)
    {
        if (_currentHighlight != shouldHilight)
        {
            _page = 0;
            [_VTopListArray removeAllObjects];
            [_vTopListTableView reloadData];
            [self requestVChartWith: ((HXAreaModel *)_vAreaArray[shouldHilight]).code];
        }
        
        for (NSInteger index = _currentHighlight; index < LABEL_COUNT; index += 5)
        {
            ((UILabel *)[_area viewWithTag: index + 600]).textColor = [UIColor colorWithRed: 81 / 256.0 green: 100 / 256.0 blue: 229 / 256.0 alpha: 1.0];
        }
        
        _currentHighlight = shouldHilight;
        
        for (NSInteger index = shouldHilight; index < LABEL_COUNT; index += 5)
        {
            ((UILabel *)[_area viewWithTag: index + 600]).textColor = [UIColor colorWithRed: 100 / 256.0 green: 203 / 256.0 blue: 150 / 256.0 alpha: 1.0];
        }
    }
    _currentLocal = _area.contentOffset.x;
    
}

// 设置工具视图
- (void) setToolView
{
    _toolView = [[UIView alloc] initWithFrame: CGRectMake(0, _area.frame.origin.y + _area.frame.size.height, self.view.frame.size.width, 30)];
    _toolView.backgroundColor = [UIColor blackColor];
    [self.view addSubview: _toolView];
}

#pragma mark---点击tapLabel
- (void) tapLabel: (UITapGestureRecognizer *)sender
{
    if (_vAreaArray.count == 0)
    {
        return;
    }
    NSInteger tag = (sender.view.tag - 600) % 5;
    
    if (_currentHighlight != tag)
    {
        _page = 0;
        [_vTopListTableView reloadData];
        [_VTopListArray removeAllObjects];
        [self requestVChartWith: ((HXAreaModel *)_vAreaArray[tag]).code];
    }
    
    for (NSInteger index = _currentHighlight; index < LABEL_COUNT; index += 5)
    {
        ((UILabel *)[[sender.view superview] viewWithTag: index + 600]).textColor = [UIColor colorWithRed: 81 / 256.0 green: 100 / 256.0 blue: 229 / 256.0 alpha: 1.0];
    }
    
    _currentHighlight = tag;
    
    for (NSInteger index = tag; index < LABEL_COUNT; index += 5)
    {
        ((UILabel *)[[sender.view superview] viewWithTag: index + 600]).textColor = [UIColor colorWithRed: 100 / 256.0 green: 203 / 256.0 blue: 150 / 256.0 alpha: 1.0];
    }
    NSInteger number = 128 - [_area convertPoint: sender.view.frame.origin toView: self.view].x;
    // 移动到中间去
    _area.contentOffset = CGPointMake(_area.contentOffset.x - number , 0);
    
    
}

#pragma mark---UITableView Datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_VTopListArray.count == 0)
    {
        return 5;
    }
    return _VTopListArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXVChartCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    if (_VTopListArray.count != 0)
    {
        [cell setVChartCellWith: _VTopListArray[indexPath.row]];
    }
    return cell;
}

#pragma mark---UITableView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_VTopListArray.count == 0)
    {
        return;
    }
    _isModal = YES;
    
    HXPlayVListViewController *playVListViewController = [[HXPlayVListViewController alloc] init];
    playVListViewController.idNumber = ((HXVChartModel *)_VTopListArray[indexPath.row]).idNumber;
    playVListViewController.titleString = ((HXVChartModel *)_VTopListArray[indexPath.row]).title;
    [self presentViewController:playVListViewController animated: NO completion: nil];
}

#pragma mark网络请求打榜数据
- (void) requestVChartWith: (NSString *)area
{
    // 移除所有元素
    @synchronized(self)
    {
        dispatch_async(_customQueue, ^
       {
           
           [_manager GET: GET_VCHART_TREND_LIST parameters: @{@"deviceinfo": DEVICEINFO, @"area" : area, @"offset" : [NSString stringWithFormat: @"%ld", (long)_page], @"size" : @"20"} success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                if (_page == 0)
                {
                    [_VTopListArray removeAllObjects];
                }
                NSInteger index = _page;
                for (NSDictionary *dict in responseObject[@"videos"])
                {
                    HXVChartModel *vCharModel = [[HXVChartModel alloc] init];
                    
                    // rank
                    vCharModel.rank = [NSString stringWithFormat: @"%ld", (long)++index];
                    
                    // id
                    vCharModel.idNumber = dict[@"id"];
                    
                    // title
                    vCharModel.title = dict[@"title"];
                    
                    // description
                    vCharModel.descriptionInfo = dict[@"description"];
                    
                    // 艺术家
                    for (NSDictionary *artistDict in dict[@"artists"])
                    {
                        HXArtistModel *artist = [[HXArtistModel alloc] init];
                        
                        artist.artistId = artistDict[@"artistId"];
                        
                        artist.artistName = artistDict[@"artistName"];
                        
                        [vCharModel.artists addObject: artist];
                    }
                    
                    // artistName
                    vCharModel.artistName = dict[@"artistName"];
                    
                    // 海报
                    vCharModel.posterPicture = dict[@"posterPic"];
                    
                    // 缩略图
                    vCharModel.thumbnailPicture = dict[@"thumbnailPic"];
                    
                    // albumImg
                    vCharModel.albumImage = dict[@"albumImg"];
                    
                    // url
                    vCharModel.url = dict[@"url"];
                    
                    // hdUrl
                    vCharModel.hdUrl = dict[@"hdUrl"];
                    
                    // uhdUrl
                    vCharModel.uhdUrl = dict[@"uhdUrl"];
                    
                    // shdUrl
                    vCharModel.shdUrl = dict[@"shdUrl"];
                    
                    // videoSize
                    vCharModel.videoSize = dict[@"videoSize"];
                    
                    // hd
                    vCharModel.hdVideoSize = dict[@"hdVideoSize"];
                    
                    // uhd
                    vCharModel.uhdVideoSize = dict[@"uhdVideoSize"];
                    
                    // shd
                    vCharModel.shdVideoSize = dict[@"shdVideoSize"];
                    
                    // status
                    vCharModel.status = dict[@"status"];
                    
                    // duration
                    vCharModel.duration = dict[@"duration"];
                    
                    // promoTitle
                    vCharModel.score = dict[@"score"];
                    
                    // playListPic
                    vCharModel.playListPicture = dict[@"playListPic"];
                    
                    // 加入到数组
                    [_VTopListArray addObject: vCharModel];
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
