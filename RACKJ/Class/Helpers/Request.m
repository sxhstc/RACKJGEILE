//
//  Request.m
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#import "Request.h"
#import "TaskOperation.h"
#import "RequestParamModel.h"


@implementation Request

+ (instancetype)request {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.operationManager= [XHNetworking httpsSessionManager];
        self.taskArray=[NSMutableArray array];
        
        ///监测网络情况
        [self monitoringNetwork];
        
    }
    return self;
}

///发起网络请求，不使用缓存
- (NSURLSessionDataTask *)getWithPath:(NSString *)path
                               params:(NSDictionary *)params
                              success:(XHResponseSuccess)success
                                 fail:(XHResponseFail)fail
{
    WS(weakSelf)
    NSURLSessionDataTask * currentTask = [XHNetworking getWithPath:path params:params success:^(NSURLSessionDataTask *task, id responseObject, BOOL fromCache){
        
        [weakSelf.taskArray removeObject:task];
        success(task,responseObject,fromCache);
        
    } fail:^(NSURLSessionDataTask *task, NSError *error, BOOL fromCache){
        
        [weakSelf.taskArray removeObject:task];
        fail(task,error,fromCache);
        
    }];
    //添加到请求任务数组
    if (currentTask!=nil) {
        [_taskArray addObject:currentTask];
    }
    return currentTask;
}

///发起网络请求，使用缓存
- (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
        cachePolicy:(XHRequestCachePolicy)policy
           trimTime:(NSInteger)trimTime
            success:(XHResponseSuccess)success
               fail:(XHResponseFail)fail
{
    WS(weakSelf)
    [XHNetworking getWithPath:path params:params cachePolicy:policy trimTime:trimTime success:^(NSURLSessionDataTask *task, id responseObject, BOOL fromCache){

        [weakSelf.taskArray removeObject:task];
        success(task,responseObject,fromCache);
        
    } fail:^(NSURLSessionDataTask *task, NSError *error, BOOL fromCache){
        
        [weakSelf.taskArray removeObject:task];
        fail(task,error,fromCache);
        
    } addTask:^(NSURLSessionDataTask *task) {
        //添加到请求任务数组
        if (task!=nil) {
            [weakSelf.taskArray addObject:task];
        }
    }];
    
}

/// 发起网络请求，使用缓存，网络失败重发
- (void)getRetransmissionWithPath:(NSString *)path
                           params:(NSDictionary *)params
                      cachePolicy:(XHRequestCachePolicy)policy
                         trimTime:(NSInteger)trimTime
                          success:(XHResponseSuccess)success
                             fail:(XHResponseFail)fail
{
    WS(weakSelf)
    
    //保存请求操作
    RequestParamModel *model = [[RequestParamModel alloc] init];
    model.path=path;
    model.params=params;
    model.policy=policy;
    model.trimTime=trimTime;
    model.success=success;
    model.fail=fail;
    model.failureArray=self.failureArray;
    model.taskArray=self.taskArray;
    [self.failureArray addObject:model];
    
    [XHNetworking getWithPath:path params:params cachePolicy:policy trimTime:trimTime success:^(NSURLSessionDataTask *task, id responseObject, BOOL fromCache){
        
        [weakSelf.failureArray removeObject:model];
        [weakSelf.taskArray removeObject:task];
        success(task,responseObject,fromCache);
    
    } fail:^(NSURLSessionDataTask *task, NSError *error, BOOL fromCache){
    
        [weakSelf.taskArray removeObject:task];
        fail(task,error,fromCache);
    
    } addTask:^(NSURLSessionDataTask *task) {
        //添加到请求任务数组
        if (task!=nil) {
            [weakSelf.taskArray addObject:task];
        }
    }];
}


- (void)POST:(NSString *)path
  parameters:(NSDictionary*)parameters
     success:(void (^)(Request *request, NSString* responseString))success
     failure:(void (^)(Request *request, NSError *error))failure{
    
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.operationManager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString* responseJson = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"[Request]: %@",responseJson);
        success(self,responseJson);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"[Request]: %@",error.localizedDescription);
        failure(self,error);
        
    }];
    
}

#pragma mark 网络请求失败，有网络时重发

- (NSMutableArray *)failureArray
{

    if (!_failureArray) {
        _failureArray = [NSMutableArray array];
    }
    return _failureArray;
}

- (NSOperationQueue *)opQueue {
    
    if (!_opQueue) {
        _opQueue = [[NSOperationQueue alloc] init];
        //设置线程池中的线程数
        _opQueue.maxConcurrentOperationCount=5;
    }
    return _opQueue;
}


///监测网络
-(void)monitoringNetwork
{
    WS(weakSelf)
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [RACObserve(manager, networkReachabilityStatus) subscribeNext:^(id x) {
        AFNetworkReachabilityStatus status =((NSNumber *)x).integerValue;
        
        if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable)
        {
            DLog(@"无网络");
            
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            DLog(@"有网络，重连");
            if (weakSelf.failureArray.count!=0) {
                [weakSelf.opQueue cancelAllOperations];
                for (RequestParamModel *model in weakSelf.failureArray) {
                    TaskOperation *op =[[TaskOperation alloc] init];
                    op.model=model;
                    [weakSelf.opQueue addOperation:op];
                }
            }
        }

    }];

}

#pragma mark 取消所有请求
- (void)cancelAllOperations{
    for (NSURLSessionDataTask *task in _taskArray) {
        [task cancel];
    }
}

- (void)dealloc {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}

@end
