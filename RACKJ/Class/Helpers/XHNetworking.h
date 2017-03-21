//
//  XHNetworking.h
//  RACKJ
//
//  Created by hua on 2017/1/9.
//  Copyright © 2017年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XHRequestCachePolicy)
{
    XHRequestUseProtocolCachePolicy = 0, //默认的缓存策略， 如果缓存不存在，直接从服务端获取。如果缓存存在，判断是否过期，不过期用缓存，过期再取服务器。
    XHRequestReloadIgnoringLocalCacheData = 1, //忽略本地缓存数据，直接请求服务端。
    XHRequestReturnCacheDataDontLoad = 2, //加载本地缓存，没有就失败。 (确定当前无网络时使用)
};

typedef void(^XHResponseSuccess)(NSURLSessionDataTask *task, id responseObject, BOOL fromCache);
typedef void(^XHResponseFail)(NSURLSessionDataTask *task, NSError *error, BOOL fromCache);
/// 请求加到数组中Block
typedef void(^XHAddTaskToArray)(NSURLSessionDataTask *task);


@interface XHNetworking : NSObject

/**
 *  @brief 网络请求单列
 */
+ (AFHTTPSessionManager *)httpsSessionManager;

/**
 *
 *  @brief 发起网络请求，不使用缓存
 *
 *  @param path     网络请求路径
 *  @param params   网络请求参数
 *  @param success  请求成功回调
 *  @param fail     请求失败回调
 */
+ (NSURLSessionDataTask *)getWithPath:(NSString *)path
                               params:(NSDictionary *)params
                              success:(XHResponseSuccess)success
                                 fail:(XHResponseFail)fail;

/**
 *
 *  @brief 发起网络请求，使用缓存
 *
 *  @param path     网络请求路径
 *  @param params   网络请求参数
 *  @param policy   缓存策略
 *  @param trimTime 缓存时间
 *  @param success  请求成功回调
 *  @param fail     请求失败回调
 *  @param addTask  请求添加到数组回调
 */
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
        cachePolicy:(XHRequestCachePolicy)policy
           trimTime:(NSInteger)trimTime
            success:(XHResponseSuccess)success
               fail:(XHResponseFail)fail
            addTask:(XHAddTaskToArray)addTask;

/**
 *
 *  @brief 检测网络
 *
 */
+ (void)AFNetworkStatus;

@end
