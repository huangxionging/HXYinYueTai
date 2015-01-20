//
//  HXNetWork.m
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-27.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "HXNetWork.h"

static HXNetWork *netWork = nil;

@implementation HXNetWork

#pragma mark---共享网络
+ (id)shareNetWork
{
    if (netWork == nil)
    {
        netWork = [[HXNetWork alloc] init];
    }
    
    return netWork;
}

#pragma mark---重写构造函数
- (id) init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        netWork = [super init];
        _isConected = NO;
    });
    
    return netWork;
}

#pragma mark---重写allocWithZone
+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (netWork == nil)
    {
        netWork = [super allocWithZone:zone];
    }
    
    return netWork;
}

#pragma mark---回调block
- (void) requestWithURLString: (NSString *)urlString WithFinished: (finishLoading) finish orFailed: (failWithError) fail
{
    [self requestWithURLString: urlString andDelegate: nil];
    _finishBlock = finish;
    _failedBlock = fail;
}

#pragma mark---发起网络请求

- (void) requestWithURLString: (NSString *)urlString andDelegate: (id) delegate
{
    if (_isConected == NO)
    {
        // 表示已发起网络请求
        _isConected = YES;
        
        _request = [NSURLRequest requestWithURL: [NSURL URLWithString: urlString]];
        
        _connection = [NSURLConnection connectionWithRequest: _request delegate: self];
        
        _delegate = delegate;
        
    }
}

#pragma mark---NSURLConnectionDataDelegate
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"已经发起网络请求");
    
    if (_receiveData == nil)
    {
        _receiveData = [[NSMutableData alloc] init];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData: data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"请求完成");
    
    
    // 回调和block方法
    if (_finishBlock)
    {
        _finishBlock(_receiveData);
    }
    
    else if (_delegate && [_delegate respondsToSelector: @selector(netWorkConnectFinishedWithData:)])
    {
        // 通知代理
        [_delegate netWorkConnectFinishedWithData: _receiveData];
    }
    
    // 请求结束, 可以接收新网络请求
    _isConected = NO;
    
    // 代理指向空
    _delegate = nil;
    
    // 释放请求
    _request = nil;
    
    // 只在需要的时候才分配内存
    _receiveData = nil;
    
    // 立即断开连接
    [_connection cancel];
    
    _connection = nil;
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"网络请求错误");
    
    // 请求结束, 可以接收新网络请求
    _isConected = NO;
    
    // 代理指向空
    _delegate = nil;
    
    // 释放请求
    _request = nil;
    
    // 只在需要的时候才分配内存
    _receiveData = nil;
    
    // 立即断开连接
    [_connection cancel];
    
    _connection = nil;
    
    if (_failedBlock)
    {
        _failedBlock(error);
    }
}

- (void) dealloc
{
    // 释放内存
    _delegate = nil;
    
    _receiveData = nil;
    
    _connection = nil;
    
    _request = nil;
    
    free(&_isConected);
}


@end
