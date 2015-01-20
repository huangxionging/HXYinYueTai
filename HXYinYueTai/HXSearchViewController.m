//
//  HXSearchViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-9-7.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HXSearchViewController.h"
#import "AFNetworking.h"
#import "HXSearchModel.h"
#import "HXMainDataBase.h"
#import "HXHistoryCell.h"
#import "HXVideoModel.h"
#import "HXSearchVideoCell.h"
#import "HXMusicListCell.h"
#import "HXMusicListModel.h"
#import "HXArtistCell.h"
#import "HXSearchArtistModel.h"
#import "HXMusicViewController.h"
#import "HXArtistDetailViewController.h"


#define TITLE_WIDTH (200)

// 按钮宽度
#define BUTTON_WIDTH (101)

// 按钮高度
#define BUTTON_HEIGHT (30)

static NSInteger once = 0;

@interface HXSearchViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *navigationBar;

// 自定义线程
@property (nonatomic, strong) dispatch_queue_t customQueue;

// 网络请求管理器
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic, strong) NSArray *searchTypeArray;

@property (nonatomic, strong) NSMutableArray *searchResult;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSString *searchString;

@property (nonatomic, strong) NSMutableArray *history;

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSIndexPath *indexPath;


@end

@implementation HXSearchViewController

#pragma mark---类方法插入数据库
+ (void) insertIntoDatabaseWith: (NSString *)string andWithIndex: (NSInteger) index;
{
    // 先打开数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] open];
    
    // 获取单例对象的数据库队列
    FMDatabaseQueue *dataBaseQueue =  [[HXMainDataBase shareDatabase] databaseQueue];
    
    // 第一次先创建表
    if (once++ == 0)
    {
        [dataBaseQueue inDatabase:^(FMDatabase *db)
         {
             NSString *sqlString = [NSString stringWithFormat: @"create table if not exists History%ld(ID integer primary key autoincrement, string text unique)", (long)index];
             
             if (![db executeUpdate: sqlString])
             {
                 NSLog(@"创建表失败");
             }
         }];
    }
    
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat: @"select *from History%ld where string=?", (long)index];
         
         FMResultSet *result = [db executeQuery: sqlString, string];
         
         [result next];
         
         if ([result stringForColumn: @"string"])
         {
             [result close];
             return;
         }
         
         sqlString = [NSString stringWithFormat: @"insert into History%ld (string) values(?)", (long)index];
         if (![db executeUpdate: sqlString, string])
         {
             NSLog(@"插入失败");
         }
     }];
    
    // 关闭数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] close];
}

#pragma mark---使用类方法查询数据
+ (NSMutableArray *) selectFromDatabaseWithID: (NSInteger) index
{
    // 先打开数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] open];
    
    // 获取单例对象的数据库队列
    FMDatabaseQueue *dataBaseQueue =  [[HXMainDataBase shareDatabase] databaseQueue];
    
    // 创建动态数组
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    [dataBaseQueue inDatabase:^(FMDatabase *db)
     {
         NSString *sqlString = [NSString stringWithFormat: @"select *from History%ld", (long)index];
         
         FMResultSet *result = [db executeQuery: sqlString];
         
         while ([result next])
         {
             [temp addObject: [result stringForColumn: @"string"]];
         }
         
         [result close];
     }];
    
    // 关闭数据库
    [(HXMainDataBase *)[HXMainDataBase shareDatabase] close];
    
    return temp;
}

#pragma mark---初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _customQueue = dispatch_queue_create("searchQueue", DISPATCH_QUEUE_CONCURRENT);
        
        _manager = [[AFHTTPRequestOperationManager alloc] init];
        
        _searchTypeArray = @[@"search_type_mv", @"playlist", @"search_type_artist"];
        
        _history = [HXSearchViewController selectFromDatabaseWithID: _currentIndex];
        
        _searchResult = [[NSMutableArray alloc] init];
        
        _resultArray = [[NSMutableArray alloc] init];
        
        _currentIndex = 0;
        
        _page = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setNavigationBar];
    
    [self setTopView];
    
    [self setSearchScrollView];
    
    [self setSearchTableView];
    
    [self setSearchResultTableView];
    
    [self setSearchView];
    
    [self setSearchBar];
    
    [self setVideoButton];
    
    [self setPlayListButton];
    
    [self setArtistButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    title.text = @"搜索";
    
    [_navigationBar addSubview: title];
}

#pragma mark---返回按钮事件
- (void) back
{
    [self dismissViewControllerAnimated: NO completion: nil];
}

#pragma mark---设置顶视图
- (void) setTopView
{
    // 初始化
    _topView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, 80)];
    
    // 添加到self.view上
    [self.view addSubview: _topView];
    
    // 允许用户交互
    _topView.userInteractionEnabled = YES;
    
    // 添加图片
    _topView.image = [UIImage imageNamed: @"bg"];
    
}

#pragma mark---设置searchView
- (void) setSearchView
{
    _searchView = [[UIImageView alloc] initWithFrame: CGRectMake(20, 5, 280, 30)];
    
    // 添加到self.view上
    [_topView addSubview: _searchView];
    
    // 允许用户交互
    _searchView.userInteractionEnabled = YES;
    
    // 添加图片
    _searchView.image = [UIImage imageNamed: @"SearchInputBackground"];
}

#pragma mark---设置搜索框
- (void) setSearchBar
{
    _searchBar = [[UITextField alloc] initWithFrame: CGRectMake(36, 0, 220, 30)];
   
    _searchBar.placeholder = @"输入艺人、MV、或悦单名称";
    

    
    _searchBar.keyboardType = UIKeyboardAppearanceDefault;
    
    _searchBar.returnKeyType = UIReturnKeyDone;
    
    _searchBar.delegate = self;
    
    [_searchBar addTarget: self action: @selector(beginSearch) forControlEvents: UIControlEventEditingChanged];
    
    [_searchView addSubview: _searchBar];
}

- (void) setVideoButton
{
    // 初始化
    _videoButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    _videoButton.frame = CGRectMake(9, _searchView.frame.origin.y + _searchView.frame.size.height + 10, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    [_videoButton setBackgroundImage: [UIImage imageNamed: @"search_mv_item_btn"] forState: UIControlStateNormal];
    
    [_videoButton setBackgroundImage: [UIImage imageNamed: @"search_mv_item_btn_sel"] forState: UIControlStateSelected];
    
    _videoButton.tag = 800;
    
    [_videoButton addTarget: self action: @selector(clickButton:) forControlEvents: UIControlEventTouchUpInside];
    
    _videoButton.selected = YES;
    
    [_topView addSubview: _videoButton];
}

- (void) setPlayListButton
{
    // 初始化
    _playListButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    _playListButton.frame = CGRectMake(_videoButton.frame.origin.x + _videoButton.frame.size.width, _videoButton.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    [_playListButton setBackgroundImage: [UIImage imageNamed: @"search_mvList_item_btn"] forState: UIControlStateNormal];
    
    [_playListButton setBackgroundImage: [UIImage imageNamed: @"search_mvList_item_btn_sel"] forState: UIControlStateSelected];
    
    _playListButton.tag = 801;
    
    [_playListButton addTarget: self action: @selector(clickButton:) forControlEvents: UIControlEventTouchUpInside];
    
    [_topView addSubview: _playListButton];
}

- (void) setArtistButton
{
    // 初始化
    _artistButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    
    _artistButton.frame = CGRectMake(_playListButton.frame.origin.x + _playListButton.frame.size.width, _playListButton.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    [_artistButton setBackgroundImage: [UIImage imageNamed: @"search_artist_item_btn"] forState: UIControlStateNormal];
    
    [_artistButton setBackgroundImage: [UIImage imageNamed: @"search_artist_item_btn_sel"] forState: UIControlStateSelected];
    
    _artistButton.tag = 802;
    
    [_artistButton addTarget: self action: @selector(clickButton:) forControlEvents: UIControlEventTouchUpInside];
    
    [_topView addSubview: _artistButton];
    
}

#pragma mark---按钮事件
- (void) clickButton: (UIButton *)sender
{
    ((UIButton *)[self.view viewWithTag: _currentIndex + 800]).selected = NO;
    
    sender.selected = YES;
    
    once = 0;
    
    if (_searchScrollView.contentOffset.x == 0)
    {
        if (sender.tag - 800 != _currentIndex)
        {
            _currentIndex = sender.tag - 800;
            
            if ([_searchBar.text isEqualToString: @""])
            {
                _history = [HXSearchViewController selectFromDatabaseWithID: _currentIndex];
                
                [_searchResult removeAllObjects];
                
                [_searchTableView reloadData];
            }
            else
            {
                [self connectNetWork];
            }
        }
    }
    else
    {
        _currentIndex = sender.tag - 800;
        [_resultArray removeAllObjects];
        [self requstWithKeyword:_searchBar.text];
    }
}

#pragma mark---设置滚动视图
- (void) setSearchScrollView
{
    _searchScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, _topView.frame.size.width, self.view.frame.size.height - _topView.frame.origin.y - _topView.frame.size.height)];
    
    _searchScrollView.contentSize = CGSizeMake(_searchScrollView.frame.size.width * 2, _searchScrollView.frame.size.height);
   
    _searchScrollView.scrollEnabled = NO;
    
    [self.view addSubview: _searchScrollView];
}

#pragma mark---设置表视图
- (void) setSearchTableView
{
    _searchTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, _searchScrollView.frame.size.width, _searchScrollView.frame.size.height) style: UITableViewStylePlain];
    
    _searchTableView.dataSource = self;
    
    _searchTableView.delegate = self;
    
    [_searchScrollView addSubview: _searchTableView];
    
    [_searchTableView registerNib: [UINib nibWithNibName: @"HXHistoryCell" bundle: nil] forCellReuseIdentifier: @"CellHistory"];
}

#pragma mark---设置结果表视图
- (void) setSearchResultTableView
{
    _searchResultTableView = [[UITableView alloc] initWithFrame: CGRectMake(_searchScrollView.frame.size.width, 0, _searchScrollView.frame.size.width, _searchScrollView.frame.size.height) style: UITableViewStylePlain];
    _searchResultTableView.dataSource = self;
    _searchResultTableView.delegate = self;
    _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_searchScrollView addSubview: _searchResultTableView];
    
    
    _headRefreshView = [[MJRefreshHeaderView alloc] initWithScrollView: _searchResultTableView andDelegate: self];
    
    _footRefreshView = [[MJRefreshFooterView alloc] initWithScrollView: _searchResultTableView andDelegate: self];
    
    [_headRefreshView endRefreshing];
    
    [_footRefreshView endRefreshing];
    
    [_searchResultTableView registerNib: [UINib nibWithNibName: @"HXMusicListCell" bundle: nil] forCellReuseIdentifier: @"Cell2"];
    
    [_searchResultTableView registerNib: [UINib nibWithNibName: @"HXArtistCell" bundle: nil] forCellReuseIdentifier: @"Cell3"];
    
}

#pragma mark---MJRefreshBaseViewDelegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    _baseView = refreshView;
    
    if (refreshView == _headRefreshView)
    {
        _page = 0;
        [_resultArray removeAllObjects];
    }
    else
    {
        _page += 20;
    }
    
    [self requstWithKeyword: _searchBar.text];
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
    [_searchResultTableView reloadData];
}

#pragma mark---联网
- (void) connectNetWork
{
    if ([_searchBar.text isEqualToString: _searchString])
    {
        return;
    }
    else
    {
        _searchString = [_searchBar.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        if ([_searchString isEqualToString: @""])
        {
            return;
        }
    }
    @synchronized(self)
    {
        [_searchResult removeAllObjects];
        
        [_searchTableView reloadData];
        
        dispatch_async(_customQueue, ^
        {
            [_manager GET: GET_SEARCH_LIST parameters: @{@"deviceinfo": DEVICEINFO, @"type" : _searchTypeArray[_currentIndex], @"keyword" :_searchString} success:^(AFHTTPRequestOperation *operation, id responseObject)
            {   
                for (NSDictionary *dict in responseObject)
                {
                    
                    if ([dict[@"type"] isEqualToString: @"video"] && _currentIndex != 0)
                    {
                        continue;
                    }
                    HXSearchModel *searchModel = [[HXSearchModel alloc] init];
                    
                    searchModel.word = dict[@"word"];
                    
                    searchModel.idNumber = dict[@"id"];
                    
                    searchModel.type = dict[@"type"];
                    
                    [_searchResult addObject: searchModel];
                }
                
                [_searchTableView reloadData];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
            }];
        });
    }
}

#pragma mark-UITableView Datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchTableView)
    {
        if (_searchResult.count == 0)
        {
            return _history.count + 1;
        }
        return _searchResult.count;
    }
    else
    {
        if (_resultArray.count == 0)
        {
            return 20;
        }
        else
        {
            return _resultArray.count;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchTableView)
    {
        static NSString *cellID = @"Cell0";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (_searchResult.count == 0)
        {
            if (indexPath.row != _history.count)
            {
                cell.textLabel.text = _history[indexPath.row];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier: @"CellHistory"];
                
                [((HXHistoryCell *)cell) clearTable:^(NSInteger index)
                 {
                     [[HXMainDataBase shareDatabase] clearTableWithName: [NSString stringWithFormat: @"History%ld", (long)_currentIndex]];
                     
                     _history = [HXSearchViewController selectFromDatabaseWithID: _currentIndex];
                     
                     [_searchTableView reloadData];
                 }];
            }
        }
        else
        {
            HXSearchModel *searchModel = ((HXSearchModel *)_searchResult[indexPath.row]);
            
            cell.textLabel.text = searchModel.word;
        }
        
        return cell;
    }
    else
    {
        static NSString *cellID = @"Cell1";
        
        UITableViewCell *cell = nil;
        
        switch (_currentIndex)
        {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier: cellID];
                
                if (cell == nil)
                {
                    cell = [[HXSearchVideoCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                if (_resultArray.count != 0)
                {
                    HXSearchVideoCell *cell1 = (HXSearchVideoCell *)cell;
                   
                    cell1.indexPath = indexPath;
                    
                    [cell1 setSearchVideoCellWith: _resultArray[indexPath.row] With:^(BOOL hide)
                     {
                         HXVideoModel *videoModel = (HXVideoModel *)_resultArray[indexPath.row];
                         
                         videoModel.hide = !videoModel.hide;
                         
                         [tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
                         
                     }];

                }
                break;
            }
                
            case 1:
            {
                cell = [tableView dequeueReusableCellWithIdentifier: @"Cell2"];
                if (_resultArray.count != 0)
                {
                    [(HXMusicListCell *)cell setMusicListCellWith: _resultArray[indexPath.row]];
                }
                break;
            }
                
            case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier: @"Cell3"];
                
                if (_resultArray.count != 0)
                {
                    [(HXArtistCell *)cell setArtistCellWith:  _resultArray[indexPath.row]];
                }
            }
            default:
                break;
        }
        return cell;
    }
}

#pragma mark---UITableView Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchTableView)
    {
        [_searchBar resignFirstResponder];
        _searchScrollView.contentOffset = CGPointMake(_searchScrollView.frame.size.width, 0);
        if (_searchResult.count != 0)
        {
            HXSearchModel *searchModel = _searchResult[indexPath.row];
            
            [HXSearchViewController insertIntoDatabaseWith: searchModel.word andWithIndex: _currentIndex];
            
            [self requstWithKeyword: searchModel.word];
            
            _searchBar.text = searchModel.word;
        }
        else if(indexPath.row != _history.count)
        {
            [self requstWithKeyword: _history[indexPath.row]];
            
            [HXSearchViewController insertIntoDatabaseWith: _history[indexPath.row] andWithIndex: _currentIndex];
            
            _searchBar.text = _history[indexPath.row];
        }
    }
    else if (tableView == _searchResultTableView)
    {
        if (_resultArray.count == 0)
        {
            return;
        }
        switch (_currentIndex)
        {
            case 0:
            {
                MPMoviePlayerViewController *_moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL: [NSURL URLWithString: ((HXVideoModel *)_resultArray[indexPath.row]).url]];
                
                [self presentMoviePlayerViewControllerAnimated: _moviePlayer];
                break;
            }
                
            case 1:
            {
                HXMusicViewController *musicViewController = [[HXMusicViewController alloc] init];
                
                musicViewController.playListID = ((HXMusicListModel *)_resultArray[indexPath.row]).idNumber;
                
                musicViewController.titleString = ((HXMusicListModel *)_resultArray[indexPath.row]).title;
                
                [self.navigationController pushViewController: musicViewController animated: NO];
                break;
            }
                
            case 2:
            {
                HXArtistDetailViewController *artistDetailViewController = [[HXArtistDetailViewController alloc] init];
                
                artistDetailViewController.artistModel = (HXSearchArtistModel *)_resultArray[indexPath.row];
                
                [self.navigationController pushViewController: artistDetailViewController animated: NO];
            }
            
     
            default:
                break;
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchTableView)
    {
        return 44;
    }
    else
    {
        switch (_currentIndex)
        {
            case 0:
            {
                if (_resultArray.count != 0 && ((HXVideoModel *)_resultArray[indexPath.row]).hide)
                {
                    return 116;
                }
                return 80;
                break;
            }
            
            case 1:
            {
                return 120;
                break;
            }
                
            case 2:
            {
                return 100;
                break;
            }
            default:
                break;
        }
        return 0;
    }
}

#pragma mark---搜索框编辑事件
- (void) beginSearch
{
    [self connectNetWork];
}

#pragma mark---UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    _searchScrollView.contentOffset = CGPointMake(0, 0);
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [_searchBar resignFirstResponder];
    return YES;
}

#pragma mark---放弃第一响应
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
}

#pragma mark---不让屏幕旋转
- (BOOL) shouldAutorotate
{
    return NO;
}

#pragma mark-再次发起网络请求
- (void) requstWithKeyword: (NSString *)keyword
{
    // 线程锁
    @synchronized(self)
    {
        NSString *getString = (_currentIndex == 0) ? GET_SEARCH_VIDEO : _currentIndex == 1 ? GET_SEARCH_PALYLIST : GET_SEARCH_ARTIST;
        
        dispatch_async(_customQueue, ^
        {
            [_manager GET: getString parameters: @{@"deviceinfo": DEVICEINFO, @"offset" : [NSString stringWithFormat: @"%ld", (long)_page ], @"size" : @"20", @"keyword" : keyword}
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                if (_page == 0)
                {
                    [_resultArray removeAllObjects];
                }
                switch (_currentIndex)
                {
                    case 0:
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
                            
                            [_resultArray addObject: videoModel];
                            
                            NSLog(@"%lu", (unsigned long)_resultArray.count);
                        }
                        break;
                    }
                        
                    case 1:
                    {
                        for (NSDictionary *dict in responseObject[@"playLists"])
                        {
                            HXMusicListModel *musicListModel = [[HXMusicListModel alloc] init];
                            
                            // 编号
                            musicListModel.idNumber = dict[@"id"];
                            
                            // 标题
                            musicListModel.title = dict[@"title"];
                            
                            // 缩略图
                            musicListModel.thumbnailPicture = dict[@"thumbnailPic"];
                            
                            // 悦单图片
                            musicListModel.playListPicture = dict[@"playListPic"];
                            
                            // 悦单大图
                            musicListModel.playListBigPicture = dict[@"playListBigPic"];;
                            
                            // 视频总数
                            musicListModel.videoCount = dict[@"videoCount"];
                            
                            NSDictionary *fontDict = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0]};
                            
                            CGSize size = [[musicListModel.videoCount stringValue] boundingRectWithSize: CGSizeMake(100, 21) options: NSStringDrawingUsesLineFragmentOrigin attributes: fontDict context: nil].size;
                            //
                            musicListModel.videoLabelWidth = size.width;
                            
                            // 描述
                            musicListModel.descriptionInfo = dict[@"description"];
                            
                            // 分类
                            musicListModel.category = dict[@"category"];
                            
                            // 创建者
                            musicListModel.creator.userID = dict[@"creator"][@"uid"];
                            
                            musicListModel.creator.nickName = dict[@"creator"][@"nickName"];
                            
                            musicListModel.creator.smallAvatar = dict[@"creator"][@"smallAvatar"];
                            
                            musicListModel.creator.largeAvatar = dict[@"creator"][@"largeAvatar"];
                            
                            // 状态
                            musicListModel.status = dict[@"status"];
                            
                            // 总视频数
                            musicListModel.totalViews = dict[@"totalViews"];
                            
                            // 总喜欢数
                            musicListModel.totalFavorites = dict[@"totalFavorites"];
                            
                            // 更新时间
                            musicListModel.updateTime = dict[@"updateTime"];
                            
                            // 创建时间
                            musicListModel.createTime = dict[@"createTime"];
                            
                            // 积分
                            musicListModel.integral = dict[@"integral"];
                            
                            // 周积分
                            musicListModel.weekIntegral = dict[@"weekIntegral"];
                            
                            // 总使用者
                            musicListModel.totalUser = dict[@"totalUser"];
                            
                            // 排名
                            musicListModel.rank = dict[@"rank"];
                            
                            [_resultArray addObject: musicListModel];
                        }
                        break;
                    }
                        
                    case 2:
                    {
                        for (NSDictionary *dict in responseObject[@"artist"])
                        {
                            HXSearchArtistModel *searchArtistModel = [[HXSearchArtistModel alloc] init];
                            
                            searchArtistModel.artistId = dict[@"id"];
                            
                            searchArtistModel.artistName = dict[@"name"];
                            
                            searchArtistModel.aliasName = dict[@"aliasName"];
                            
                            searchArtistModel.smallAvatar = dict[@"smallAvatar"];
                            
                            searchArtistModel.area = dict[@"area"];
                            
                            searchArtistModel.videoCount = dict[@"videoCount"];
                            
                            searchArtistModel.fanCount = dict[@"fanCount"];
                            
                            searchArtistModel.subCount = dict[@"subCount"];
                            
                            searchArtistModel.isSub = dict[@"sub"];
                            
                            [_resultArray addObject: searchArtistModel];
                        }
                    }
                    default:
                        break;
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

- (void)dealloc
{
    // 移除监听
    [_headRefreshView free];
    
    // 移除监听
    [_footRefreshView free];
    
    [self.view removeFromSuperview];
    
    once = 0;
}


@end
