//
//  HXArtistDetailViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-13.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXArtistDetailViewController.h"
#import "HXSearchVideoCell.h"
#import <MediaPlayer/MediaPlayer.h>



@interface HXArtistDetailViewController ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *videos;

@property (nonatomic, strong) MPMoviePlayerViewController *videoViewController;

@end

@implementation HXArtistDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _videos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    _artistView = [[NSBundle mainBundle] loadNibNamed: @"HXArtistCell" owner: self options: nil][0];
    
    _artistView.frame = CGRectMake(0, _navigationBar.frame.origin.y + _navigationBar.frame.size.height, _navigationBar.frame.size.width, 100);
    
    [_artistView setArtistCellWith: _artistModel];
    
    [self.view addSubview: _artistView];
    
    [self setArtistTableView];
    
    [self connectNetWork];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) connectNetWork
{
    if (_manager == nil)
    {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
    }
    @synchronized(self)
    {
        // 获取视频信息
        [_manager GET: GET_ARTIST_DETAIL parameters: @{@"deviceinfo": DEVICEINFO, @"offset" : [NSString stringWithFormat: @"%ld", (long)_page], @"artistId" : [NSString stringWithFormat: @"%@", _artistModel.artistId],@"size" : @"20"} success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            if (_page == 0)
            {
                [_videos removeAllObjects];
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
                
                // playListPic
                videoModel.playListPicture = dict[@"playListPic"];
                
                [_videos addObject: videoModel];
            }
            
            NSLog(@"%ld", (long)_page);
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
    _navigationBar = [[UIImageView alloc] initWithFrame: CGRectMake(0, 20, self.view.frame.size.width, 44)];
    
    [self.view addSubview: _navigationBar];
    
    // 允许交互
    _navigationBar.userInteractionEnabled = YES;
    
    _navigationBar.image = [UIImage imageNamed: @"navigationBar"];
    
    // 在导航栏上放置返回按钮
    
    UIButton *back = [UIButton buttonWithType: UIButtonTypeCustom];
    
    back.frame = CGRectMake(0, 0, 44, 44);
    
    [back setBackgroundImage: [UIImage imageNamed: @"back_btn"] forState: UIControlStateNormal];
    
    [back setBackgroundImage: [UIImage imageNamed: @"back_btn_p"] forState: UIControlStateHighlighted];
    
    // 添加事件
    [back addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    
    [_navigationBar addSubview: back];
    
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake((_navigationBar.frame.size.width - TITLE_WIDTH) / 2, 0, TITLE_WIDTH, 44)];
    
    title.textColor = [UIColor whiteColor];
    
    title.textAlignment = NSTextAlignmentCenter;
    
    title.text = @"艺人详情";
    
    [_navigationBar addSubview: title];
}

#pragma mark---返回按钮事件
- (void) back
{
    [self.navigationController popViewControllerAnimated: NO];
}

- (void) setArtistTableView
{
    _ArtistTableView = [[UITableView alloc] initWithFrame: CGRectMake(0,  _artistView.frame.size.height + _artistView.frame.origin.y, _artistView.frame.size.width, self.view.frame.size.height - _artistView.frame.size.height - _artistView.frame.origin.y) style: UITableViewStylePlain];
    
    [self.view addSubview: _ArtistTableView];
    
    _ArtistTableView.dataSource = self;
    
    _ArtistTableView.delegate = self;
    
    [_ArtistTableView registerClass: [HXSearchVideoCell class] forCellReuseIdentifier: @"Cell"];
    
    _headRefreshView = [[MJRefreshHeaderView alloc] initWithScrollView: _ArtistTableView andDelegate: self];
    
    _footRefreshView = [[MJRefreshFooterView alloc] initWithScrollView: _ArtistTableView andDelegate: self];
    
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
    [_ArtistTableView reloadData];
}

#pragma mark---UITableView datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSearchVideoCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    
    if (_videos.count != 0)
    {
        [cell setSearchVideoCellWith: _videos[indexPath.row] With:^(BOOL hide)
        {
            HXVideoModel *videoModel = (HXVideoModel *)_videos[indexPath.row];
            
            videoModel.hide = !videoModel.hide;
            
            [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
        }];
    }
    
    return cell;
}


#pragma mark---UITableView Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _videoViewController = [[MPMoviePlayerViewController alloc] initWithContentURL: [NSURL URLWithString: ((HXVideoModel *)_videos[indexPath.row]).hdUrl]];
        
    [self.navigationController presentMoviePlayerViewControllerAnimated: _videoViewController];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_videos.count != 0 && ((HXVideoModel *)_videos[indexPath.row]).hide)
    {
        return 116;
    }
    return 80;
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
