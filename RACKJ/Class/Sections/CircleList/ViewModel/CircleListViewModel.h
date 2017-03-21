//
//  CircleListViewModel.h
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#import "BaseViewModel.h"

@interface CircleListViewModel : BaseViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *refreshUI;

/// 刷新单个用户信息
@property (nonatomic, strong) RACSubject *refreshUserinfo;

/// 获得用户信息
@property (nonatomic, strong) RACSubject *getUserinfoSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) RACSubject *cellClickSubject;


@end
