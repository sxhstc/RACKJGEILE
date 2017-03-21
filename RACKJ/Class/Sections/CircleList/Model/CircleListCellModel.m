//
//  CircleListCellModel.m
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#import "CircleListCellModel.h"
#import "AdModel.h"
@implementation CircleListCellModel

/// 修改映射参数名
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"peopleName" : @"name"
             };
}

/// 数组中需要转换的模型类
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"ads" : [AdModel class]
             };
}


@end
