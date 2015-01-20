//
//  HXChanelViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14-8-31.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXChanelViewController.h"
#import "HXChanelCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "HXChanelModel.h"
#import "HXChanelVideoListViewController.h"
#import "HXTabBarController.h"

@interface HXChanelViewController ()<HXChanelCellDelegate>

@property (nonatomic, strong) NSMutableArray *chanelModels;

@property (nonatomic, strong) NSArray *nibArray;

@end

@implementation HXChanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
        _chanelModels = [[NSMutableArray alloc] initWithCapacity: 25];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self connectNetWork];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_TAB_BAR object: nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: SHOW_NAVIGATION_BAR object: nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _customQueue = dispatch_queue_create("Chanel", DISPATCH_QUEUE_CONCURRENT);
    
    self.navigationController.navigationBar.translucent = NO;
    
    // 隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setChanelTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---设置表视图
- (void) setChanelTableView
{
    // 初始化
    _chanelTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 113) style: UITableViewStylePlain];
    
    // 分割样式
    _chanelTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 分配代理
    _chanelTableView.dataSource = self;
    
    _chanelTableView.delegate = self;
    
    [self.view addSubview: _chanelTableView];
}


#pragma mark---UITableViewDatasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXChanelCell *cell = nil;
    
    _nibArray = [[NSBundle mainBundle] loadNibNamed: @"HXChanelCell" owner: self options: nil];
    
    if (indexPath.row % 2 != 0)
    {
        NSInteger index = (indexPath.row + 1) / 2 * 5 - 3;
        
        cell = _nibArray[1];
        
        if (_chanelModels.count > 0)
        {
            [cell setChanelCellWith: [_chanelModels subarrayWithRange: NSMakeRange(index, 3)] andChanelCell: 1];
        }
        
    }
    else if (indexPath.row == 0 || indexPath.row == 6 )
    {
        cell = _nibArray[0];
        
        NSInteger index = (indexPath.row) / 2 * 5;
        
        if (_chanelModels.count > 0)
        {
            [cell setChanelCellWith: [_chanelModels subarrayWithRange: NSMakeRange(index, 2)] andChanelCell: 0];
        }
    }
    else if (indexPath.row == 2 || indexPath.row == 8)
    {
        cell = _nibArray[2];
        
        if (_chanelModels.count > 0)
        {
            NSInteger index = (indexPath.row) / 2 * 5;
            
            if (_chanelModels.count > 0)
            {
                [cell setChanelCellWith: [_chanelModels subarrayWithRange: NSMakeRange(index, 2)] andChanelCell: 2];
            }
        }
    }
    else
    {
        cell = _nibArray[3];
        if (_chanelModels.count > 0)
        {
            NSInteger index = (indexPath.row) / 2 * 5;
            if (_chanelModels.count > 0)
            {
                [cell setChanelCellWith: [_chanelModels subarrayWithRange: NSMakeRange(index, 2)] andChanelCell: 3];
            }
        }
    }
    cell.delegate = self;
    return cell;
}

#pragma mark---UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}

#pragma mark---联网
- (void) connectNetWork
{
    dispatch_async(_customQueue, ^
    {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        
        [manager GET: GET_CHANEL_LIST parameters: @{@"deviceinfo": DEVICEINFO} success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [_chanelModels removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"])
            {
                HXChanelModel *chanelModel = [[HXChanelModel alloc] init];
                chanelModel.type = dict[@"type"];
                chanelModel.chanelID = dict[@"id"];
                chanelModel.title = dict[@"title"];
                chanelModel.imageUrl = dict[@"img"];
                chanelModel.flag = dict[@"flag"];
                [_chanelModels addObject: chanelModel];
            }
            
            NSInteger random = arc4random() % _chanelModels.count;
            
            for (NSInteger index = _chanelModels.count; index < 25; ++index)
            {
                [_chanelModels addObject: _chanelModels[random]];
            }
            
            [_chanelTableView reloadData];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"%@", error);
        }];
    });
}

#pragma mark---点击手势转移页面
- (void)tapImageViewToTransferWith:(HXChanelModel *)chanelModel
{
    HXChanelVideoListViewController *videoListViewController = [[HXChanelVideoListViewController alloc] init];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    videoListViewController.chanelID = chanelModel.chanelID;
    videoListViewController.titleString = chanelModel.title;
    [self.navigationController pushViewController: videoListViewController animated: NO];
}

@end
