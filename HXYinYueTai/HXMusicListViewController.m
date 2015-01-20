//
//  HXMusicListViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXMusicListViewController.h"
#import "AFNetworking.h"
#import "HXMusicListCell.h"
#import "HXMusicListModel.h"
#import "HXCreatorModel.h"
#import "HXMusicViewController.h"

// 按钮宽度
#define BUTTON_WIDTH (101)

// 按钮高度
#define BUTTON_HEIGHT (30)

@interface HXMusicListViewController ()<MJRefreshBaseViewDelegate>

// 标签
@property (nonatomic, strong) UILabel *label;

// 当前按钮
@property (nonatomic, assign) NSInteger currentIndex;

// 悦单数组
@property (nonatomic, strong) NSMutableArray *playList;

// 网络请求管理器
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

// 网络请求参数
@property (nonatomic, strong) NSArray *requestArray;

// 请求页
@property (nonatomic, assign) NSInteger page;

@end

@implementation HXMusicListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        // 并行线程
        _customQueue = dispatch_queue_create("MusicListQueue", DISPATCH_QUEUE_CONCURRENT);
        
        _currentIndex = 0;
        
        _playList = [[NSMutableArray alloc] init];
        
        _manager = [[AFHTTPRequestOperationManager alloc] init];
        
        _requestArray = @[@"CHOICE", @"HOT", @"NEW"];
        
        _page = 0;
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    // 发送展示导航栏通知
    [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_NAVIGATION_BAR  object: nil];
    
    // 发送展示tabBar通知
    [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_TAB_BAR object: nil];
    
    [self connectNetWork];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setChoiceButton];
    
    [self setHotButton];
    
    [self setNewButton];
    
    [self setLabel];
    
    [self setMusicListTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setChoiceButton
{
    // 初始化
    _choiceButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    _choiceButton.frame = CGRectMake(9, 64 + 5, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    [_choiceButton setBackgroundImage: [UIImage imageNamed: @"yd_choiceness"] forState: UIControlStateNormal];
    
    [_choiceButton setBackgroundImage: [UIImage imageNamed: @"yd_choiceness_p"] forState: UIControlStateSelected];
    
    _choiceButton.tag = 700;
    
    [_choiceButton addTarget: self action: @selector(clickButton:) forControlEvents: UIControlEventTouchUpInside];
    
    _choiceButton.selected = YES;
    
    [self.view addSubview: _choiceButton];
}

- (void) setHotButton
{
    // 初始化
    _hotButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    _hotButton.frame = CGRectMake(_choiceButton.frame.origin.x + _choiceButton.frame.size.width, _choiceButton.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    [_hotButton setBackgroundImage: [UIImage imageNamed: @"yd_hot"] forState: UIControlStateNormal];
    
    [_hotButton setBackgroundImage: [UIImage imageNamed: @"yd_hot_p"] forState: UIControlStateSelected];
    
    _hotButton.tag = 701;
    
    [_hotButton addTarget: self action: @selector(clickButton:) forControlEvents: UIControlEventTouchUpInside];
    
    [self.view addSubview: _hotButton];
}

- (void) setNewButton
{
    // 初始化
    _newsButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
 
    _newsButton.frame = CGRectMake(_hotButton.frame.origin.x + _hotButton.frame.size.width, _choiceButton.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    [_newsButton setBackgroundImage: [UIImage imageNamed: @"yd_new"] forState: UIControlStateNormal];
    
    [_newsButton setBackgroundImage: [UIImage imageNamed: @"yd_new_p"] forState: UIControlStateSelected];
    
    _newsButton.tag = 702;
    
   [_newsButton addTarget: self action: @selector(clickButton:) forControlEvents: UIControlEventTouchUpInside];
    
    [self.view addSubview: _newsButton];
    
}

- (void) setLabel
{
    _label = [[UILabel alloc] initWithFrame: CGRectMake(0, _choiceButton.frame.origin.y + _choiceButton.frame.size.height + 5, self.view.frame.size.width, 1)];
    
    _label.backgroundColor = [UIColor colorWithRed: 61 / 256.0 green: 70 / 256.0 blue: 232 / 256.0 alpha: 1.0];
    
    [self.view addSubview: _label];
}

#pragma mark---按钮点击事件

- (void) clickButton: (UIButton *)sender
{
    ((UIButton *)[self.view viewWithTag: _currentIndex + 700]).selected = NO;
    
    sender.selected = YES;
    
    if (sender.tag - 700 != _currentIndex)
    {
        _currentIndex = sender.tag - 700;
        
        [_playList removeAllObjects];
        
        [self connectNetWork];
    }
}

#pragma 网络连接
- (void) connectNetWork
{
    // 加互斥锁
    @synchronized(self)
    {
        dispatch_async(_customQueue, ^
        {
            if (_page == 0)
            {
                [_playList removeAllObjects];
            }
            [_manager GET: GET_PLAY_LIST parameters: @{@"deviceinfo": DEVICEINFO, @"category" : _requestArray[_currentIndex], @"offset" : [NSString stringWithFormat: @"%ld", (long)_page], @"size" : @"20"} success:^(AFHTTPRequestOperation *operation, id responseObject)
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
                    
                    [_playList addObject: musicListModel];
                }
                
                [self endRefreshing];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"%@", error);
                [self endRefreshing];
            }];
        });
    }
}

#pragma mark---设置表视图
- (void) setMusicListTableView
{
    _musicListTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, _label.frame.origin.y + 4, _label.frame.size.width, self.view.frame.size.height - 126 - BUTTON_HEIGHT) style: UITableViewStylePlain];
    
    [self.view addSubview: _musicListTableView];
    
    _musicListTableView.dataSource = self;
    
    _musicListTableView.delegate = self;
    
    [_musicListTableView registerNib: [UINib nibWithNibName: @"HXMusicListCell" bundle: nil] forCellReuseIdentifier: @"Cell"];
    
    _headRefreshView = [[MJRefreshHeaderView alloc] initWithScrollView: _musicListTableView andDelegate: self];
    
    _footRefreshView = [[MJRefreshFooterView alloc] initWithScrollView: _musicListTableView andDelegate: self];
    
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
    [_musicListTableView reloadData];
}
#pragma mark---UITableView Datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_playList.count == 0)
    {
        return 20;
    }
    return _playList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXMusicListCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    
    if (_playList.count != 0)
    {
        [cell setMusicListCellWith: _playList[indexPath.row]];
    }
    
    return cell;
}

#pragma mark---UITableView Delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_playList.count == 0)
    {
        return;
    }
    HXMusicViewController *musicViewController = [[HXMusicViewController alloc] init];
    
    // 悦单id
    musicViewController.playListID = ((HXMusicListModel *)_playList[indexPath.row]).idNumber;
    
    musicViewController.titleString = ((HXMusicListModel *)_playList[indexPath.row]).title;

    
    [self.navigationController pushViewController: musicViewController animated: NO];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
