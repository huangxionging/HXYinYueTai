//
//  HXFirstPageViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HXFirstPageViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "HXSuggestionModel.h"
#import "HXVideoCell.h"
#import "HXVideoModel.h"
#import "FMDatabaseQueue.h"
#import "HXMainDataBase.h"
#import "HXHomePageSectionHeadView.h"
#import "HXRootViewController.h"
#import "HXPlayVListViewController.h"
#import "HXMusicViewController.h"
#import "HXServiceViewController.h"
#import "HXMoreViewController.h"


@interface HXFirstPageViewController ()<HXHomePageSectionHeadViewDelegate, HXVideoCellDelegate>

// 数组
@property (nonatomic, strong) NSMutableArray *suggestionModelArray;

// MV首播
@property (nonatomic, strong) NSMutableArray *videoMV;

// MVPop
@property (nonatomic, strong) NSMutableArray *videoPop;

// 正在热播
@property (nonatomic, strong) NSMutableArray *videoHot;

// 猜你喜欢
@property (nonatomic, strong) NSMutableArray *videoGuess;

// 定时器
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation HXFirstPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _suggestionModelArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self connectNetWork];                                      // 联网
    
    // 发通知
    [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_TAB_BAR object: nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_NAVIGATION_BAR object: nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];                                        // 取消定时器
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 设置效果
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    // 并行线程
    _customQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    
    [self setHomePageTableView];                                // 设置表视图
    
    [self setHeadView];                                         // 设置头视图
    
    [self setHomePageScrollView];                               // 设置首页滚动视图
    
    [self setSubHeadView];                                      // 设置子头视图
    
    [self setSubHeadViewButton];                                // 设置子按钮
    
    [self setSubHeadImageView];                                 // 设置子图像视图
    
    [self setTitleAndDescription];                              // 设置标题和描述标签
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---联网
- (void) connectNetWork
{
    @synchronized(self)
    {
        dispatch_async(_customQueue, ^
       {
           AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
           
           // 获取推荐
           [manager GET: GET_SUGGESTIONS parameters: @{@"deviceinfo": DEVICEINFO, @"rn" : @"640*540"} success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                if ([responseObject isKindOfClass: [NSArray class]] == NO)
                {
                    return;
                }
                
                // 先清空数组
                [_suggestionModelArray removeAllObjects];
                
                for (NSDictionary *subDict in responseObject)
                {
                    HXSuggestionModel *suggestionModel = [[HXSuggestionModel alloc] init];
                    suggestionModel.type = subDict[@"type"];                    // 类型
                    suggestionModel.idNumber = subDict [@"id"];                 // id
                    suggestionModel.title = subDict[@"title"];                  // 标题
                    suggestionModel.descriptionInfo = subDict[@"description"];      // 描述
                    suggestionModel.subType = subDict[@"subType"];              // 子类型
                    suggestionModel.posterPicture = subDict[@"posterPic"];      // 海报
                    suggestionModel.thumbnailPicture = subDict[@"thumbnailPic"];// 缩略图
                    suggestionModel.url = subDict[@"url"];                      // 视频地址
                    suggestionModel.hdUrl = subDict[@"hdUrl"];                  // hd
                    suggestionModel.uhdUrl = subDict[@"uhdUrl"];                // uhd
                    suggestionModel.videoSize= subDict[@"videoSize"];           // size
                    suggestionModel.hdVideoSize = subDict[@"hdVideoSize"];      // hdSize
                    suggestionModel.uhdVideoSize = subDict[@"uhdVideoSize"];    // uhdSize
                    suggestionModel.status = subDict[@"status"];                // status
                    suggestionModel.traceUrl = subDict[@"traceUrl"];            // 痕迹地址
                    suggestionModel.clickUrl = subDict[@"clickUrl"];            // ClickUrl
                    [_suggestionModelArray addObject: suggestionModel];
                }
                
                [self refreshScrollView];
            }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
            }];
           
           // 获取MV首播栏目
           [manager GET: GET_VIDEO_LIST parameters: @{@"deviceinfo" : DEVICEINFO, @"promoTitle" : @"true", @"area" : @"ALL", @"supportBanner" : @"true", @"offset" : @"0", @"size" : @"10"}
                success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                _videoMV = [self getVideoArray: responseObject];
                [_homePageTableView reloadSections: [NSIndexSet indexSetWithIndex: 0] withRowAnimation: UITableViewRowAnimationFade];
            }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
            }];
           
           // 获取正在流行栏目
           [manager GET: GET_VIDEO_LIST parameters: @{@"deviceinfo" : DEVICEINFO, @"promoTitle" : @"true", @"area" : @"POP_ALL", @"supportBanner" : @"true", @"offset" : @"0", @"size" : @"10"}
                success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                _videoPop = [self getVideoArray: responseObject];
                [_homePageTableView reloadSections: [NSIndexSet indexSetWithIndex: 1] withRowAnimation: UITableViewRowAnimationFade];
            }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
            }];
           
           // 获取正在热播
           [manager GET: GET_VIDEO_LIST parameters: @{@"deviceinfo" : DEVICEINFO, @"promoTitle" : @"true", @"area" : @"DAYVIEW_ALL", @"supportBanner" : @"true", @"offset" : @"0", @"size" : @"10"}
                success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                _videoHot = [self getVideoArray: responseObject];
                
                [_homePageTableView reloadSections: [NSIndexSet indexSetWithIndex: 2] withRowAnimation: UITableViewRowAnimationFade];
            }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
            }];
           
           // 获取猜你喜欢栏目
           [manager GET: GET_VIDEO_GUESS parameters: @{@"deviceinfo" : DEVICEINFO, @"offset" : @"0", @"size" : @"60"}
                success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                _videoGuess = [self getVideoArray: responseObject];
                [_homePageTableView reloadSections: [NSIndexSet indexSetWithIndex: 2] withRowAnimation: UITableViewRowAnimationFade];
            }
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
            }];
       });

    }
}

- (NSMutableArray *) getVideoArray: (id)responseObject
{
    NSMutableArray *video = [[NSMutableArray alloc] initWithCapacity: 4];
    
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
        
        [video addObject: videoModel];
    }
    
    return video;
}

#pragma mark---设置表视图
- (void) setHomePageTableView
{
    // 初始化
    _homePageTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 113) style: UITableViewStyleGrouped];
    
    // 数据源和代理
    _homePageTableView.dataSource = self;
    _homePageTableView.delegate = self;
    
    [_homePageTableView registerNib: [UINib nibWithNibName: @"HXVideoCell" bundle: nil] forCellReuseIdentifier: @"Cell"];
    
    [_homePageTableView registerNib: [UINib nibWithNibName: @"HXHomePageSectionHeadView" bundle: nil] forHeaderFooterViewReuseIdentifier: @"SectionHeadView"];
    
    [self.view addSubview: _homePageTableView];
}

#pragma mark---设置头视图
- (void) setHeadView
{
    // 初始化
    _headView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, _homePageTableView.frame.size.width, 250)];
    
    // 将其设为表视图的头视图
    _homePageTableView.tableHeaderView = _headView;
}

#pragma mark---设置滚动视图
- (void)setHomePageScrollView
{
    // 初始化
    _homePageScrollView = [[UIScrollView alloc] initWithFrame: _headView.frame];
    
    [_headView addSubview: _homePageScrollView];
    
    // 点击事件
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tap)];
    tapOne.numberOfTapsRequired = 1;
    tapOne.numberOfTouchesRequired = 1;
    [_homePageScrollView addGestureRecognizer: tapOne];
    
    // 代理
    _homePageScrollView.delegate = self;
    
    // 分页显示
    _homePageScrollView.pagingEnabled = YES;
    
    // 不要水平指示器
    _homePageScrollView.showsHorizontalScrollIndicator = NO;
    
}

#pragma mark----setSubHeadView
- (void) setSubHeadView
{
    _subHeadView = [[UIView alloc] initWithFrame: CGRectMake(0, _headView.frame.size.height  - 70, _headView.frame.size.width, 70)];
    _subHeadView.backgroundColor = [UIColor blackColor];
    _subHeadView.alpha = 0.8;
    [_headView addSubview: _subHeadView];
}

#pragma mark----setHomePageControl
- (void) setHomePageControl
{
    _homePageControl = [[UIPageControl alloc] initWithFrame: CGRectMake(0, _subHeadView.frame.size.height - 15, _subHeadView.frame.size.width, 15)];
    [_subHeadView addSubview: _homePageControl];
    _homePageControl.numberOfPages = _suggestionModelArray.count;
    _homePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _homePageControl.pageIndicatorTintColor = [UIColor grayColor];
    [_homePageControl addTarget: self action: @selector(changePage:) forControlEvents: UIControlEventValueChanged];
}

- (void) changePage: (UIPageControl *)sender
{
    _homePageScrollView.contentOffset = CGPointMake((sender.currentPage + 1) * _homePageScrollView.frame.size.width , 0);
    [self changeContent];
}

#pragma mark---设置子头视图上的按钮
- (void) setSubHeadViewButton
{
    _subHeadViewButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _subHeadViewButton.frame = CGRectMake(_subHeadView.frame.size.width - 49, (_subHeadView.frame.size.height - 49) / 2, 49, 49);
    [_subHeadViewButton addTarget: self action: @selector(tap) forControlEvents: UIControlEventTouchUpInside];
    [_subHeadView addSubview: _subHeadViewButton];
}

#pragma mark---设置子头视图上的ImageView
- (void) setSubHeadImageView
{
    // 初始化
    _subHeadImageView = [[UIImageView alloc] initWithFrame: CGRectMake(10, -43 / 2, 43, 43)];
    
    [_subHeadView addSubview: _subHeadImageView];
}

#pragma mark---设置标题和描述信息
- (void) setTitleAndDescription
{
    // 初始化
    _labelTitle = [[UILabel alloc] initWithFrame: CGRectMake(10, _subHeadImageView.frame.origin.y + _subHeadImageView.frame.size.height + 2 , _subHeadView.frame.size.width - _subHeadViewButton.frame.size.width - 10, 10)];
    
    // 排版
    _labelTitle.textAlignment = NSTextAlignmentLeft;
    
    // 字体颜色
    _labelTitle.textColor = [UIColor whiteColor];
    
    // 字体大小
    _labelTitle.font = [UIFont systemFontOfSize: 11.0];
    
    [_subHeadView addSubview: _labelTitle];
    
    // 描述信息
    _labelDescription = [[UILabel alloc] initWithFrame: CGRectMake(10, _labelTitle.frame.origin.y + _labelTitle.frame.size.height + 5, _subHeadView.frame.size.width - _subHeadViewButton.frame.size.width - 10, 10)];
    
    // 排版
    _labelDescription.textAlignment = NSTextAlignmentLeft;
    
    // 颜色
    _labelDescription.textColor = [UIColor colorWithRed: 55 / 256.0 green: 223 / 256.0 blue: 150 / 256.0 alpha: 1.0];
    
    // 字体大小
    _labelDescription.font = [UIFont systemFontOfSize: 12.0];
    
    [_subHeadView addSubview: _labelDescription];
    
}

#pragma mark---刷新滚动视图
- (void) refreshScrollView
{
    // 大小
    [self setHomePageControl];                                  // 设置分页控件
    
    for (UIView *sub in _homePageScrollView.subviews)
    {
        [sub removeFromSuperview];
    }
    
    _homePageScrollView.contentSize = CGSizeMake((_suggestionModelArray.count + 2) * _homePageScrollView.frame.size.width, _homePageScrollView.frame.size.height);
    
    _homePageScrollView.contentOffset = CGPointMake(_homePageScrollView.frame.size.width, 0);
    
    for (NSInteger index = 0; index < _suggestionModelArray.count ; ++index)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake((index + 1) * _homePageScrollView.frame.size.width, 0, _homePageScrollView.frame.size.width, _homePageScrollView.frame.size.height)];
        imageView.tag = index + 301;
        HXSuggestionModel *suggestionModel = (HXSuggestionModel *)_suggestionModelArray[index];
        [imageView setImageWithURL: [NSURL URLWithString: suggestionModel.posterPicture]];
        [_homePageScrollView addSubview: imageView];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake((_suggestionModelArray.count + 1) * _homePageScrollView.frame.size.width, 0, _homePageScrollView.frame.size.width, _homePageScrollView.frame.size.height)];
    imageView.tag = _suggestionModelArray.count + 301;
    
    [imageView setImageWithURL: [NSURL URLWithString: ((HXSuggestionModel *)[_suggestionModelArray firstObject]).posterPicture]];

    [_homePageScrollView addSubview: imageView];
    
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0 * _homePageScrollView.frame.size.width, 0, _homePageScrollView.frame.size.width, _homePageScrollView.frame.size.height)];
    
    imageView.tag = 300;
    
    [imageView setImageWithURL: [NSURL URLWithString: ((HXSuggestionModel *)[_suggestionModelArray lastObject]).posterPicture]];
    
    [_homePageScrollView addSubview: imageView];
    
    @synchronized(self)
    {
        if (_timer)
        {
            [_timer invalidate];
            _timer = nil;
        }

        _timer = [NSTimer scheduledTimerWithTimeInterval: 3.0f target: self selector: @selector(autoRefresh) userInfo: nil repeats: YES];
        [[NSRunLoop currentRunLoop] addTimer: _timer forMode: NSRunLoopCommonModes];
    }
    [self changeContent];
    
    
    _homePageScrollView.contentOffset = CGPointMake(_homePageScrollView.frame.size.width, 0);
}

#pragma mark---UIScrollViewDeletegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _homePageScrollView)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 只响应滚动视图
    if (scrollView != _homePageScrollView)
    {
        return;
    }
    
    if (_homePageScrollView.contentOffset.x == (_suggestionModelArray.count + 1 )* _homePageScrollView.frame.size.width)
    {
        _homePageScrollView.contentOffset = CGPointMake(_homePageScrollView.frame.size.width, 0);
    }
    if (_homePageScrollView.contentOffset.x == 0 * _homePageScrollView.frame.size.width)
    {
        _homePageScrollView.contentOffset = CGPointMake(_suggestionModelArray.count * _homePageScrollView.frame.size.width, 0);
    }
    [self changeContent];
    _timer = [NSTimer scheduledTimerWithTimeInterval: 3.0f target: self selector: @selector(autoRefresh) userInfo: nil repeats: YES];
    [[NSRunLoop currentRunLoop] addTimer: _timer forMode: NSRunLoopCommonModes];
}

- (void) changeContent
{
    NSInteger index = _homePageScrollView.contentOffset.x / _homePageScrollView.frame.size.width;
    if (index == 0)
    {
        index = 9;
    }
    else if (index == 10)
    {
        index = 1;
    }
    _homePageControl.currentPage = index - 1;
    
    if (_suggestionModelArray.count == 0)
    {
        return;
    }
    
    // 获取推荐模型
    HXSuggestionModel *suggestion = _suggestionModelArray[index - 1];
    _labelTitle.text = suggestion.title;
    _labelDescription.text = suggestion.descriptionInfo;
    
    if ([suggestion.type isEqualToString: @"VIDEO"])
    {
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"PlayButton"] forState: UIControlStateNormal];
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"PlayButtonLight"] forState: UIControlStateHighlighted];
        _subHeadImageView.image = [UIImage imageNamed: @"HomePagePlay"];
    }
    else if ([suggestion.type isEqualToString: @"ACTIVITY"])
    {
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"HomePageReadDetail"] forState: UIControlStateNormal];
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"HomePageReadDetail_p"] forState: UIControlStateHighlighted];
        _subHeadImageView.image = [UIImage imageNamed: @"HomePageActivety"];
    }
    else if ([suggestion.type isEqualToString: @"AD"])
    {
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"HomePageDetail"] forState: UIControlStateNormal];
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"HomePageDetail_Light"] forState: UIControlStateHighlighted];
        _subHeadImageView.image = [UIImage imageNamed: @"HomePageAD"];
    }
    else if ([suggestion.type isEqualToString: @"PROGRAM"])
    {
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"HomePageReadDetail"] forState: UIControlStateNormal];
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"HomePageReadDetail_p"] forState: UIControlStateHighlighted];
        
        _subHeadImageView.image = [UIImage imageNamed: @"HomePagePROGRAM"];
    }
    else if ([suggestion.type isEqualToString: @"PLAYLIST"])
    {
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"HomePageReadDetail"] forState: UIControlStateNormal];
        
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"HomePageReadDetail_p"] forState: UIControlStateHighlighted];
        
        _subHeadImageView.image = [UIImage imageNamed: @"HomePagePlayList"];
    }
    else if ([suggestion.type isEqualToString: @"WEEK_MAIN_STAR"])
    {
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"PlayButton"] forState: UIControlStateNormal];
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"PlayButtonLight"] forState: UIControlStateHighlighted];
        
        _subHeadImageView.image = [UIImage imageNamed: @"HomePagWeek_Star"];
    }
    else if ([suggestion.type isEqualToString: @"LIVE"])
    {
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"PlayButton"] forState: UIControlStateNormal];
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"PlayButtonLight"] forState: UIControlStateHighlighted];
        _subHeadImageView.image = [UIImage imageNamed: @"HomePageLIVE"];
    }
    else if ([suggestion.type isEqualToString: @"ANNOUNCEMENT"])
    {
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"HomePageDetail"] forState: UIControlStateNormal];
        [_subHeadViewButton setBackgroundImage: [UIImage imageNamed: @"HomePageDetail_Light"] forState: UIControlStateHighlighted];
        _subHeadImageView.image = [UIImage imageNamed: @"HomePageAnnouncement"];
    }
}

#pragma mark---UITableViewDatasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";

    HXVideoCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    
    if (cell.delegate == nil)
    {
        cell.delegate = self;
    }
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            if (_videoMV)
            {
                [cell setVideoCellWith: @[_videoMV[indexPath.row * 2], _videoMV[indexPath.row * 2 + 1]]];
            }
            
            break;
        }
            
        case 1:
        {
            if (_videoPop)
            {
                [cell setVideoCellWith: @[_videoPop[indexPath.row * 2], _videoPop[indexPath.row * 2 + 1]]];
            }
            
            break;

        }
            
        case 2:
        {
            if (_videoHot)
            {
                [cell setVideoCellWith: @[_videoHot[indexPath.row * 2], _videoHot[indexPath.row * 2 + 1]]];
            }
            
            break;
        }
            
        case 3:
        {
            if (_videoGuess)
            {
                [cell setVideoCellWith: @[_videoGuess[_row * 2], _videoGuess[_row * 2 + 1]]];
                _row++;
            }
            
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark---UITableViewDelegate
- (UITableViewHeaderFooterView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HXHomePageSectionHeadView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier: @"SectionHeadView"];
    
    sectionView.delegate = self;
    sectionView.contentView.backgroundColor = [UIColor clearColor];
    sectionView.indexPath = [NSIndexPath indexPathWithIndex: section];
    
    switch (section)
    {
        case 0:
        {
            sectionView.leftHeadImage.image = [UIImage imageNamed: @"MVPremiere"];
            sectionView.rightHeadImage.image = [UIImage imageNamed: @"HomePageMore"];
            break;
        }
            
        case 1:
        {
            sectionView.leftHeadImage.image = [UIImage imageNamed: @"HomePage_Editor"];
            sectionView.rightHeadImage.image = [UIImage imageNamed: @"HomePageMore"];
            break;
        }
            
        case 2:
        {
            sectionView.leftHeadImage.image = [UIImage imageNamed: @"HomePage_hot"];
            sectionView.rightHeadImage.image = [UIImage imageNamed: @"HomePageMore"];
            break;
        }
            
        case 3:
        {
            sectionView.leftHeadImage.image = [UIImage imageNamed: @"HomePage_guess"];
            sectionView.rightHeadImage.image = [UIImage imageNamed: @"HomePage_change"];
            break;
        }
            
        default:
            break;
    }
    
    
    return sectionView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

#pragma mark---手势点击事件
- (void) tap
{
    if (_suggestionModelArray.count > 0)
    {
        NSInteger index = _homePageScrollView.contentOffset.x / _homePageScrollView.frame.size.width;
        HXSuggestionModel *suggestion = ((HXSuggestionModel *) _suggestionModelArray[index - 1]);
        
        if ([suggestion.type isEqualToString: @"VIDEO"] || [suggestion.type isEqualToString: @"PROGRAM"])
        {
            HXPlayVListViewController *playViewController = [[HXPlayVListViewController alloc] init];
            playViewController.idNumber = suggestion.idNumber;
            playViewController.titleString = suggestion.title;
            [self.navigationController presentViewController: playViewController animated: NO completion: nil];
        }
        else if ([suggestion.type isEqualToString: @"PLAYLIST"] || [suggestion.type isEqualToString: @"WEEK_MAIN_STAR"])
        {
            HXMusicViewController *musicViewController = [[HXMusicViewController alloc] init];
            musicViewController.playListID = suggestion.idNumber;
            musicViewController.titleString = suggestion.title;
            [self.navigationController pushViewController: musicViewController animated: NO];
            
        }
        else if ([suggestion.type isEqualToString: @"AD"])
        {
            HXServiceViewController *serviceViewController = [[HXServiceViewController alloc] init];
            serviceViewController.url = suggestion.url;
            serviceViewController.titleString = suggestion.title;
            [self.navigationController pushViewController: serviceViewController animated: NO];
        }
        else if ([suggestion.type isEqualToString: @"ACTIVITY"])
        {
            
        }
        
    }
}

#pragma mark---HXHomePageSectionHeadViewDelegate
- (void) clickedButtonWith:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (_videoMV)
            {
                HXMoreViewController *moreViewController = [[HXMoreViewController alloc] init];
                moreViewController.parameter = @"fs";
                moreViewController.titleString = @"MV首播";
                [self.navigationController pushViewController: moreViewController animated: NO];
            }
            
            break;
        }
            
        case 1:
        {
            if (_videoPop)
            {
                HXMoreViewController *moreViewController = [[HXMoreViewController alloc] init];
                moreViewController.parameter = @"pop";
                moreViewController.titleString = @"正在流行";
                [self.navigationController pushViewController: moreViewController animated: NO];
            }
            
            break;
            
        }
            
        case 2:
        {
            if (_videoHot)
            {
                HXMoreViewController *moreViewController = [[HXMoreViewController alloc] init];
                moreViewController.parameter = @"dv";
                moreViewController.titleString = @"今日热播";
                [self.navigationController pushViewController: moreViewController animated: NO];
            }
            
            break;
        }
            
        case 3:
        {
            if (_videoGuess)
            {
                if (_row * 2 >= _videoGuess.count - 2)
                {
                    _row = 0;
                }
                [_homePageTableView reloadSections: [NSIndexSet indexSetWithIndex: 3] withRowAnimation: UITableViewRowAnimationFade];
            }
            
            break;
        }
        default:
            break;
    }

}

#pragma mark---HXVideoCellDelegate
- (void) tapVideoCellWith:(HXVideoModel *)videoModel
{
    HXPlayVListViewController *playViewController = [[HXPlayVListViewController alloc] init];
    playViewController.idNumber = videoModel.idNumber;
    playViewController.titleString = videoModel.title;
    [self.navigationController presentViewController: playViewController animated: NO completion: nil];
}


#pragma mark--autoRefresh
- (void) autoRefresh
{
    _homePageScrollView.contentOffset = CGPointMake((_homePageControl.currentPage + 2) * _homePageScrollView.frame.size.width , 0);
}

- (BOOL) shouldAutorotate
{
    
    return NO;
    
}

@end
