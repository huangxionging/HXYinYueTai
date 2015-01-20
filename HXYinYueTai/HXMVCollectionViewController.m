//
//  HXMVCollectionViewController.m
//  HXYinYueTai
//
//  Created by huangxiong on 14/10/21.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXMVCollectionViewController.h"
#import "HXAppDelegate.h"
#import "HXVideoCollectionModel.h"
#import "HXMVCollectionTableViewCell.h"
#import "HXPlayVListViewController.h"

#define TITLE_WIDTH (200)

// 按钮宽度
#define BUTTON_WIDTH (101)

// 按钮高度
#define BUTTON_HEIGHT (30)

@interface HXMVCollectionViewController ()
{
    @private
    HXAppDelegate *_app;
}

@end

@implementation HXMVCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _collectonArray = [[NSMutableArray alloc]init];
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
    _app = (HXAppDelegate *) [UIApplication sharedApplication].delegate;
    
    [self setNavigationBar];
    
    [self setCollectionTableView];
    
    [self searchCollectionFromCoreData];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    title.text = @"MV收藏";
    
    [_navigationBar addSubview: title];
    
    // 在导航栏上放置返回按钮
    
    UIButton *rightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(self.view.frame.size.width - 50, 0, 44, 44);
    
    [rightButton setTitle: @"编辑" forState: UIControlStateNormal];
    [rightButton setTitle: @"完成" forState: UIControlStateSelected];
    
    // 添加事件
    [rightButton addTarget: self action: @selector(edit:) forControlEvents: UIControlEventTouchUpInside];
    
    [_navigationBar addSubview: rightButton];
}

#pragma mark---返回按钮事件
- (void) back
{
    [self.navigationController popViewControllerAnimated: NO];
}

- (void) edit: (UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES)
    {
        [_collectionTableView setEditing: YES animated: YES];
    }
    else
    {
        [_collectionTableView setEditing: NO animated: YES];
    }
}

- (void) setCollectionTableView
{
    _collectionTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, _navigationBar.frame.origin.y + _navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _navigationBar.frame.origin.y - _navigationBar.frame.size.height) style: UITableViewStylePlain];
    
    [self.view addSubview: _collectionTableView];
    
    _collectionTableView.dataSource = self;
    _collectionTableView.delegate = self;
    [_collectionTableView registerNib: [UINib nibWithNibName: @"HXMVCollectionTableViewCell" bundle: nil] forCellReuseIdentifier: @"CellID"];
}

#pragma mark---UITableViewDatasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collectonArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HXMVCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CellID"];
    
    [cell setCellWithModel: _collectonArray[indexPath.row]];
    
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark---UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXVideoCollectionModel *model = _collectonArray[indexPath.row];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"HXVideoCollectionModel"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"hdurl = %@", model.hdurl];
    [request setPredicate: predicate];
    
    NSArray *array = [_app.managedObjectContext executeFetchRequest: request error: nil];
    
    for (HXVideoCollectionModel *model in array)
    {
        [_app.managedObjectContext deleteObject: model];
    }
    [_app saveContext];
    
    [_collectonArray removeObjectAtIndex: indexPath.row];
    [_collectionTableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXVideoCollectionModel *model = _collectonArray[indexPath.row];
    HXPlayVListViewController *playViewController = [[HXPlayVListViewController alloc] init];
    playViewController.idNumber = [model valueForKey: @"number"];
    playViewController.titleString = [model valueForKey: @"title"];
    [self.navigationController presentViewController: playViewController animated: NO completion: nil];
}

#pragma mark---数据库查询
- (void) searchCollectionFromCoreData
{
    
    if (_collectonArray == nil)
    {
        _collectonArray = [[NSMutableArray alloc] init];
    }
    
    [_collectonArray removeAllObjects];
    
    NSFetchRequest *requst = [NSFetchRequest fetchRequestWithEntityName: @"HXVideoCollectionModel"];
    
    NSArray *array = [_app.managedObjectContext executeFetchRequest: requst error: nil];
    
    for (HXVideoCollectionModel *videoCollectionModel in array)
    {
        [_collectonArray addObject: videoCollectionModel];
    }
    
    [_collectionTableView reloadData];
}



@end
