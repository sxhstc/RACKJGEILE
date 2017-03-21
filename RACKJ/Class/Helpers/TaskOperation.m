//
//  TaskOperation.m
//  RACKJ
//
//  Created by hua on 2017/1/22.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "TaskOperation.h"

@implementation TaskOperation


- (void)main{

    [XHNetworking getWithPath:self.model.path params:self.model.params cachePolicy:self.model.policy trimTime:self.model.trimTime success:^(NSURLSessionDataTask *task, id responseObject, BOOL fromCache){
//        @strongify(self);
        _model.success(task,responseObject,fromCache);
        [_model.failureArray removeObject:self.model];
        [_model.taskArray removeObject:task];
    } fail:^(NSURLSessionDataTask *task, NSError *error, BOOL fromCache){
        
        [_taskArray removeObject:task];
        _model.fail(task,error,fromCache);
        
    } addTask:^(NSURLSessionDataTask *task) {
        //添加到请求任务数组
//        @strongify(self);
        if (task!=nil) {
            [_model.taskArray addObject:task];
        }
    }];
    
}


@end
