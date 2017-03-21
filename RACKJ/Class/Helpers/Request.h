//
//  Request.h
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHNetworking.h"

@interface Request : NSObject

/**
 *[AFNetWorking]的operationManager对象
 */
@property (nonatomic, strong) AFHTTPSessionManager* operationManager;


/**
 *请求任务数组
 */
@property (nonatomic, strong) NSMutableArray *taskArray;


/**
 *请求失败任务数组
 */
@property (nonatomic, strong) NSMutableArray *failureArray;

/**
 *需重发请求队列
 */
@property (nonatomic, strong) NSOperationQueue *opQueue;



/**
 *功能: 创建CMRequest的对象方法
 */
+ (instancetype)request;

/**
 *
 *  @brief 发起网络请求，不使用缓存
 *
 *  @param path     网络请求路径
 *  @param params   网络请求参数
 *  @param success  请求成功回调
 *  @param fail     请求失败回调
 */
- (NSURLSessionDataTask *)getWithPath:(NSString *)path
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
 */
- (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
        cachePolicy:(XHRequestCachePolicy)policy
           trimTime:(NSInteger)trimTime
            success:(XHResponseSuccess)success
               fail:(XHResponseFail)fail;


/**
 *
 *  @brief 发起网络请求，使用缓存，网络失败重发
 *
 *  @param path            网络请求路径
 *  @param params          网络请求参数
 *  @param policy          缓存策略
 *  @param trimTime        缓存时间
 *  @param success         请求成功回调
 *  @param fail            请求失败回调
 */
- (void)getRetransmissionWithPath:(NSString *)path
                           params:(NSDictionary *)params
                      cachePolicy:(XHRequestCachePolicy)policy
                         trimTime:(NSInteger)trimTime
                          success:(XHResponseSuccess)success
                             fail:(XHResponseFail)fail;


/**
 *功能：POST请求
 *参数：(1)请求的路径: urlString
 *     (2)POST请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */
- (void)POST:(NSString *)path
  parameters:(NSDictionary*)parameters
     success:(void (^)(Request *request, NSString* responseString))success
     failure:(void (^)(Request *request, NSError *error))failure;


/**
 *取消当前请求队列的所有请求
 */
- (void)cancelAllOperations;


@end
