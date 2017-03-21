//
//  StatusModel.h
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#import "BaseModel.h"

@interface StatusModel : BaseModel

/// 状态码，成功或失败
@property (nonatomic, assign) NSInteger flag;

/// 状态信息，提示语
@property (nonatomic, copy) NSString *msg;

/// 当前页
@property (nonatomic, assign) NSInteger curpage;

/// 总数量
@property (nonatomic, assign) NSInteger total;

/// 结果数组，需指定模型类
@property (nonatomic, strong) id list;

@end
