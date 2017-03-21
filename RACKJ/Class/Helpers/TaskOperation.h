//
//  TaskOperation.h
//  RACKJ
//
//  Created by hua on 2017/1/22.
//  Copyright © 2017年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestParamModel.h"


@interface TaskOperation : NSOperation

@property (nonatomic, strong) RequestParamModel *model;

/**
 *请求失败任务数组
 */
@property (nonatomic, weak) NSMutableArray *failureArray;

/**
 *请求任务数组
 */
@property (nonatomic, weak) NSMutableArray *taskArray;

@end
