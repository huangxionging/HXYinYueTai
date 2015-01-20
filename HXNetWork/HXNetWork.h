//
//  HXNetWork.h
//  HXNetWorkTest
//
//  Created by huangxiong on 14-8-27.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

// 单例 网络请求
#import <Foundation/Foundation.h>

// 定义一个成功block回调
typedef void(^finishLoading)(NSData *responseData);

// 定义失败block回调
typedef void(^failWithError)(NSError *error);

// 代理协议
@protocol HXNetWorkDelegate;

@interface HXNetWork : NSOperation<NSURLConnectionDataDelegate>
{
    // 请求
    NSURLRequest *_request;
    
    // 连接
    NSURLConnection *_connection;
    
    // 接收数据
    NSMutableData *_receiveData;
    
    // 代理
    id<HXNetWorkDelegate> _delegate;
    
    // 表示是否已经发起网络请求, 已经发起则不能接收其他网络请求, 须等待请求完成才能接收下一个网络请求
    BOOL _isConected;
}

@property (nonatomic, strong) finishLoading finishBlock;

@property (nonatomic, strong) failWithError failedBlock;

// 标题
@property (nonatomic, copy) NSString *title;


+ (id) shareNetWork;

- (void) requestWithURLString: (NSString *)urlString andDelegate: (id) delegate;

- (void) requestWithURLString: (NSString *)urlString WithFinished: (finishLoading) finish orFailed: (failWithError) fail;

@end

@protocol HXNetWorkDelegate <NSObject>

@optional

// 网络请求完成后调用代理方法
- (void) netWorkConnectFinishedWithData: (NSData *)responseData;

@end
