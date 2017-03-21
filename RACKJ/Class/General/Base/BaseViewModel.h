//
//  BaseViewModel.h
//  RACKJ
//
//  Created by hua on 2017/1/4.
//  Copyright © 2017年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

typedef enum : NSUInteger {
    HeaderRefresh_HasMoreData = 1, //下拉还有更多数据
    HeaderRefresh_HasNoMoreData,   //下拉没有更多数据
    FooterRefresh_HasMoreData,     //上拉还有更多数据
    FooterRefresh_HasNoMoreData,   //上拉没有更多数据
    RefreshError,                  //刷新出错
    RefreshUI,                     //仅仅刷新UI布局
} RefreshDataStatus;

@interface BaseViewModel : NSObject

//- (instancetype)initWithModel:(id)model;

@property (nonatomic, strong) Request *request;

/**
 *  初始化
 */
- (void)initialize;

@end
