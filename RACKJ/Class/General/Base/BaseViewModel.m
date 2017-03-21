//
//  BaseViewModel.m
//  RACKJ
//
//  Created by hua on 2017/1/4.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    
//    BaseViewModel *viewModel = [super allocWithZone:zone];
//    
//    if (viewModel) {
//        
////        [viewModel initialize];
//    }
//    return viewModel;
//}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (Request *)request {
    
    if (!_request) {
        
        _request = [Request request];
    }
    return _request;
}

- (void)initialize {}

//释放时，取消网络请求
- (void)dealloc {
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    if (_request) {
        [_request cancelAllOperations];
    }
}

@end
