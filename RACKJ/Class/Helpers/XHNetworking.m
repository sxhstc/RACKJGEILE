//
//  XHNetworking.m
//  RACKJ
//
//  Created by hua on 2017/1/9.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "XHNetworking.h"
#import "NSObject+MJKeyValue.h"
static NSString * const CacheTrimDateKey = @"cacheTrimDate";


@implementation XHNetworking



/// 请求单列
+ (AFHTTPSessionManager *)httpsSessionManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       manager = [AFHTTPSessionManager manager];
        
        /**
         AFSecurityPolicy分三种验证模式：
         AFSSLPinningModeNone:只是验证证书是否在信任列表中
         AFSSLPinningModeCertificate：该模式会验证证书是否在信任列表中，然后再对比服务端证书和客户端证书是否一致
         AFSSLPinningModePublicKey：只验证服务端证书与客户端证书的公钥是否一致
         */
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = NO;//是否允许使用自签名证书
        securityPolicy.validatesDomainName = YES;//是否需要验证域名，默认YES
        manager.securityPolicy=securityPolicy;
        
        
        //申明返回的结果是json类型
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        manager.requestSerializer= [AFJSONRequestSerializer serializer];
        
//        manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
//        //关闭缓存避免干扰测试
//        manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;

//        //请求队列的最大并发数
        manager.operationQueue.maxConcurrentOperationCount = 5;
//        //请求超时的时间
//        manager.requestSerializer.timeoutInterval = 5;
        
//        manager.requestSerializer.HTTPShouldUsePipelining=YES;
//        //请求头加内容
//        [manager.requestSerializer setValue:@"Connection" forHTTPHeaderField:@"Keep-Alive"];
//        [manager.requestSerializer setValue:@"timeout=10, max=1000" forHTTPHeaderField:@"Keep-Alive"];
    

    });
    return manager;
}

///发起网络请求，不使用缓存
+ (NSURLSessionDataTask *)getWithPath:(NSString *)path
                               params:(NSDictionary *)params
                              success:(XHResponseSuccess)success
                                 fail:(XHResponseFail)fail
{
    return [XHNetworking getWithPath:path params:params useCache:NO trimTime:0 success:success fail:fail];
}


///发起网络请求，使用缓存
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
        cachePolicy:(XHRequestCachePolicy)policy
           trimTime:(NSInteger)trimTime
            success:(XHResponseSuccess)success
               fail:(XHResponseFail)fail
            addTask:(XHAddTaskToArray)addTask

{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //无网络时，缓存策略改为缓存加载
    if (manager.networkReachabilityStatus==AFNetworkReachabilityStatusNotReachable) {
        policy=XHRequestReturnCacheDataDontLoad;
    }
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",REQUEST_URL,path];

    switch (policy) {
        case XHRequestUseProtocolCachePolicy:
            //默认的缓存策略，如果缓存不存在，直接从服务端获取。如果缓存存在，判断是否过期，不过期用缓存，过期再取服务器。
        {
            
            [[PINCache sharedCache] objectForKey:urlStr.MD5
                                           block:^(PINCache *cache, NSString *key, id object) {
                                               
                                               NSDictionary *dic=object;
                                               
                                               if (object) {
                                                   //存在缓存
                                                   
                                                   NSDate *trimDate=dic[CacheTrimDateKey];
                                                   
                                                   if (trimDate) {
                                                       //存在缓存时间
                                                       
                                                       if ([trimDate compare:[NSDate date]] == NSOrderedAscending) {
                                                           //升序  trimDate 小于 现在  过期
                                                           
                                                           DLog(@"缓存已过期，删除过期缓存");
                                                           [cache removeObjectForKey:key];
                                                           //重新发起请求
                                                           NSURLSessionDataTask * task = [XHNetworking getWithPath:path params:params useCache:YES trimTime:trimTime success:success fail:fail];
                                                           if (addTask) {
                                                               addTask(task);
                                                           }
                                                           
                                                       } else {
                                                           //未过期
                                                           
                                                           DLog(@"缓存未过期，可使用");
                                                           dispatch_async(dispatch_get_main_queue(), ^(){
                                                               success(nil,object,YES);
                                                           });
                                                       }
                                                       
                                                   } else {
                                                       //不存在缓存时间，加上缓存时间，保存
                                                       
                                                       [XHNetworking saveRequestWithUrl:urlStr params:params trimTime:trimTime responseObject:object];
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^(){
                                                           success(nil,object,YES);
                                                       });
                                                       
                                                   }
                                                   
                                               } else {
                                                   //不存在缓存
                                                   
                                                   //重新发起请求
                                                   NSURLSessionDataTask * task = [XHNetworking getWithPath:path params:params useCache:YES trimTime:trimTime success:success fail:fail];
                                                   if (addTask) {
                                                       addTask(task);
                                                   }
                                               }
                                           }];
        }
            break;
        case XHRequestReloadIgnoringLocalCacheData:
            //忽略本地缓存数据，直接请求服务端。
        {
            NSURLSessionDataTask * task = [XHNetworking getWithPath:path params:params useCache:NO trimTime:trimTime success:success fail:fail];
            if (addTask) {
                addTask(task);
            }
        }
            break;
        case XHRequestReturnCacheDataDontLoad:
            //加载本地缓存， 没有就失败。 (确定当前无网络时使用)
        {
            [[PINCache sharedCache] objectForKey:urlStr.MD5
                                           block:^(PINCache *cache, NSString *key, id object) {
                                               
                                               NSDictionary *dic=object;
                                               
                                               if (object) {
                                                   //存在缓存
                                                   
                                                   NSDate *trimDate=dic[CacheTrimDateKey];
                                                   
                                                   if (trimDate) {
                                                       //存在缓存时间
                                                       
                                                       if ([trimDate compare:[NSDate date]] == NSOrderedAscending) {
                                                           //升序  trimDate 小于 现在  过期
                                                           
                                                           DLog(@"缓存已过期，删除过期缓存");
                                                           [cache removeObjectForKey:key];
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^(){
                                                               fail(nil,nil,YES);
                                                           });
                                                           
                                                           
                                                       } else {
                                                           //未过期
                                                           DLog(@"缓存未过期，可使用");
                                                           dispatch_async(dispatch_get_main_queue(), ^(){
                                                               success(nil,object,YES);
                                                           });
                                                       }
                                                       
                                                   } else {
                                                       //不存在缓存时间，加上缓存时间，保存
                                                       
                                                       [XHNetworking saveRequestWithUrl:urlStr params:params trimTime:trimTime responseObject:object];
                                                       dispatch_async(dispatch_get_main_queue(), ^(){
                                                           success(nil,object,YES);
                                                       });
                                                       
                                                   }
                                                   
                                               } else {
                                                   //不存在缓存
                                                   dispatch_async(dispatch_get_main_queue(), ^(){
                                                       fail(nil,nil,YES);
                                                   });
                                               }
                                           }];
            
        }
            break;
        default:
            break;
    }
    
    
}


+ (NSURLSessionDataTask *)getWithPath:(NSString *)path
                               params:(NSDictionary *)params
                             useCache:(BOOL)useCache
                             trimTime:(NSInteger)trimTime
                              success:(XHResponseSuccess)success
                                 fail:(XHResponseFail)fail
{
    
    AFHTTPSessionManager *manager = [XHNetworking httpsSessionManager];
    NSURLSessionDataTask * currentTask = nil;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",REQUEST_URL,path];
    //打印请求参数
    [XHNetworking logWithPath:path params:params];
    
    __block  UInt64 startTime = [NSDate nowTimeStamp];
    currentTask=[manager GET:urlStr parameters:params progress:
                 ^(NSProgress * _Nonnull downloadProgress) {
                     
                 }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
//                         NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//                         NSDictionary *allHeaders = response.allHeaderFields;
//                         DLog(@"请求头：%@\n",allHeaders);
                         
                         UInt64 successTime = [NSDate nowTimeStamp];
                         DLog(@"请求时间间隔%lld毫秒",successTime-startTime);
                         
                         //打印请求成功结果
                         [XHNetworking logSuccessWithTask:task responseObject:responseObject];
                         
                         if (useCache==YES) {
                             //保存请求缓存
                             [XHNetworking saveRequestWithUrl:urlStr params:params trimTime:trimTime responseObject:responseObject];
                             
                         }
                         
                         success(task,responseObject,NO);
                         
                     }
                 
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                         
                         //打印请求失败内容
                         [XHNetworking logFailWithTask:task error:error];
                         
                         fail(task,error,NO);
                         
                     }];
    
    return currentTask;
//    manager.requestSerializer.HTTPRequestHeaders
//    NSHTTPURLResponse *response = (NSHTTPURLResponse *)currentTask.response;
//    NSDictionary *allHeaders = response.allHeaderFields;

//    DLog(@"发送请求头：%@\n",manager.requestSerializer.HTTPRequestHeaders);
    
}

///保存请求
+ (void)saveRequestWithUrl:(NSString *)url
                    params:(NSDictionary *)params
                  trimTime:(NSInteger)trimTime
            responseObject:(id)responseObject
{
    NSDictionary *dict = responseObject;
//    NSMutableDictionary *mdict=[dict mutableCopy];
//    [mdict setObject:[NSDate dateWithTimeIntervalSinceNow:trimTime] forKey:CacheTrimDateKey];
//    [[PINCache sharedCache] setObject:mdict forKey:url.MD5 block:nil];
    
    
//    dict = @{
//             @"flag": @1,
//             @"totalSize": @18,
//             @"msg": @"查找成功!",
//             @"rs": @[
//                     @{
//                         @"name": @"财税培训圈子",
//                         @"content": @"自己交保险是不是只能交养老和医疗，费用是多少?",
//                         @"articleNum": @1568,
//                         @"peopleNum": @"568",
//                         @"topicNum": @"5749",
//                         @"headerImageStr": @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5",
//                         @"user" : @{
//                                 @"name" : @"Jack",
//                                 @"icon" : @"lufy.png"
//                                 },
//                         @"ads" : @[
//                                 @{
//                                     @"image" : @"ad01.png",
//                                     @"url" : @"http://www.ad01.com"
//                                     },
//                                 @{
//                                     @"image" : @"ad02.png",
//                                     @"url" : @"http://www.ad02.com"
//                                     }
//                                 ]
//                         }
//                     ]
//             };
    
    NSMutableDictionary *mdict=[dict mutableCopy];
    [mdict setObject:[NSDate dateWithTimeIntervalSinceNow:trimTime] forKey:CacheTrimDateKey];
    [[PINCache sharedCache] setObject:mdict forKey:url.MD5 block:nil];


}

#pragma mark -- 网络监测
/// 检测网络
+ (void)AFNetworkStatus {
    //创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                DLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}
#pragma mark -- 打印请求内容

///打印请求参数
+(void)logWithPath:(NSString *)path
           params:(NSDictionary *)params
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n"];
    [logString appendFormat:@"**************************************************************\n"];
    [logString appendFormat:@"*                       Request Start                        *\n"];
    [logString appendFormat:@"**************************************************************\n\n"];
    [logString appendFormat:@"请求URL：\n%@\n",[NSString stringWithFormat:@"%@%@",REQUEST_URL,path]];
    [logString appendFormat:@"请求参数：%@", [params mj_keyValues]];
    [logString appendFormat:@"\n\n"];
    [logString appendFormat:@"**************************************************************\n"];
    [logString appendFormat:@"*                       Request Start                        *\n"];
    [logString appendFormat:@"**************************************************************\n\n"];
    DLog(@"%@",logString);
}

///打印请求成功结果
+(void)logSuccessWithTask:(NSURLSessionDataTask *)task
           responseObject:(id)responseObject
{
    NSDictionary* resultDic = responseObject;
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n"];
    [logString appendFormat:@"==============================================================\n"];
    [logString appendFormat:@"=                            Response                        =\n"];
    [logString appendFormat:@"==============================================================\n\n"];
    [logString appendFormat:@"URL: %@\n\n", task.originalRequest.URL.absoluteString];
    [logString appendFormat:@"%@", resultDic.mj_JSONString];
    [logString appendFormat:@"\n\n"];
    [logString appendFormat:@"==============================================================\n"];
    [logString appendFormat:@"=                            Response                        =\n"];
    [logString appendFormat:@"==============================================================\n\n\n"];
    DLog(@"%@",logString);
}


///打印请求失败内容
+(void)logFailWithTask:(NSURLSessionDataTask *)task
                 error:(NSError *)error
{
    NSMutableString *logStr = [NSMutableString stringWithString:@"\n\n"];
    [logStr appendFormat:@"################################################################\n"];
    [logStr appendFormat:@"#                             Error                            #\n"];
    [logStr appendFormat:@"################################################################\n\n"];
    [logStr appendFormat:@"URL: %@\n\n", task.originalRequest.URL.absoluteString];
    [logStr appendFormat:@"%@\n\n", error.localizedDescription];
    [logStr appendFormat:@"################################################################\n"];
    [logStr appendFormat:@"#                             Error                            #\n"];
    [logStr appendFormat:@"################################################################\n\n"];
    DLog(@"%@",logStr);
}


@end
