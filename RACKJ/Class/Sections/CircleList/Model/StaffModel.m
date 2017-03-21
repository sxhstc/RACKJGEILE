//
//  StaffModel.m
//  RACKJ
//
//  Created by hua on 2017/1/18.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "StaffModel.h"

@implementation StaffModel

/// 修改映射参数名
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"nameId" : @"id"
             };
}

@end
