//
//  HXChanelVideoListViewController.h
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-3.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXChanelVideoListViewController.h"
#import "HXServiceViewController.h"
#import "HXSearchVideoCell.h"
#import "AFNetworking.h"
#import "HXVideoModel.h"
#import "HXPlayVListViewController.h"

#define TITLE_WIDTH (200)

#define TITLE_HEIGHT (44)

// 获取悦单列表

@interface HXChanelVideoListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) NSMutableArray *playListDetailArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation HXChanelVideoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _playListDetailArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    // 发送展示导航栏通知
    [[NSNotificationCenter defaultCenter] postNotificationName: HIDE_NAVIGATION_BAR  object: nil];
    
    // 发送展示tabBar通知
    [[NSNotificationCenter defaultCenter] postNotificationName: HIDE_TAB_BAR object: nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    [self setPlayListTableView];
    
    _manager = [[AFHTTPRequestOperationManager alloc] init];
    
    [self connectNetWork];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) connectNetWork
{
    @synchronized(self)
    {
        [_manager GET: GET_CHANEL_Detail_LIST parameters: @{@"deviceinfo" : DEVICEINFO, @"detail" : @"true", @"offset" : [NSString stringWithFormat: @"%ld", (long)_page], @"channelId" : [NSString stringWithFormat: @"%@", _chanelID], @"size" : @"20"} success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
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
                 
                 // playListPic
                 videoModel.playListPicture = dict[@"playListPic"];
                 
                 [_playListDetailArray addObject: videoModel];
             }
             [self endRefreshing];
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"%@", error);
             [self endRefreshing];
         }];
    }
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

- (void) setPlayListTableView
{
    _playListTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style: UITableViewStylePlain];
    [self.view addSubview: _playListTableView];
    _playListTableView.dataSource = self;
    _playListTableView.delegate = self;
    
    _headRefreshView = [[MJRefreshHeaderView alloc] initWithScrollView: _playListTableView andDelegate: self];
    _footRefreshView = [[MJRefreshFooterView alloc] initWithScrollView: _playListTableView andDelegate: self];
    [_headRefreshView endRefreshing];
    [_footRefreshView endRefreshing];
    _playListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_playListTableView registerClass: [HXSearchVideoCell class] forCellReuseIdentifier: @"Cell"];
}

#pragma mark---MJRefreshBaseViewDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    _baseView = refreshView;
    
    if (refreshView == _headRefreshView)
    {
        _page = 0;
        [_playListDetailArray removeAllObjects];
    }
    else
    {
        _page += 20;
    }
    [self connectNetWork];
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
    [_playListTableView reloadData];
}

#pragma mark---UITableView Datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_playListDetailArray.count == 0)
    {
        return 5;
    }
    else
    {
        return _playListDetailArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSearchVideoCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    
    if (_playListDetailArray.count != 0)
    {
        [cell setSearchVideoCellWith: _playListDetailArray[indexPath.row] With:^(BOOL hide)
         {
             HXVideoModel *videoModel = (HXVideoModel *)_playListDetailArray[indexPath.row];
             
             videoModel.hide = !videoModel.hide;
             
             [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
         }];
    }
    return cell;
}

#pragma mark---UITableView Delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_playListDetailArray.count != 0 && ((HXVideoModel *)_playListDetailArray[indexPath.row]).hide)
    {
        return 116;
    }
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_playListDetailArray.count == 0)
    {
        return;
    }
    HXPlayVListViewController *playVListViewController = [[HXPlayVListViewController alloc] init];
    playVListViewController.idNumber = ((HXVideoModel *)_playListDetailArray[indexPath.row]).idNumber;
    playVListViewController.titleString = ((HXVideoModel *)_playListDetailArray[indexPath.row]).title;
    [self presentViewController:playVListViewController animated: NO completion: nil];
}

- (void)dealloc
{
    // 移除监听
    [_headRefreshView free];
    
    // 移除监听
    [_footRefreshView free];
    [self.view removeFromSuperview];
    
}

@end
