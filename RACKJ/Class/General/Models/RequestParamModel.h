//
//  RequestParamModel.h
//  RACKJ
//
//  Created by hua on 2017/1/22.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "BaseModel.h"
#import "XHNetworking.h"

@interface RequestParamModel : BaseModel

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSDictionary *params;

@property (nonatomic, assign) XHRequestCachePolicy policy;

@property (nonatomic, assign) NSInteger trimTime;

@property (nonatomic, copy) XHResponseSuccess success;

@property (nonatomic, copy) XHResponseFail fail;

@property (nonatomic, weak) NSURLSessionDataTask *task;

/**
 *请求失败任务数组
 */
@property (nonatomic, weak) NSMutableArray *failureArray;

/**
 *请求任务数组
 */
@property (nonatomic, weak) NSMutableArray *taskArray;

@end
