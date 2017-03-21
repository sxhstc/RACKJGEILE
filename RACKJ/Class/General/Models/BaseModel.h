//
//  BaseModel.h
//  RACKJ
//
//  Created by hua on 2016/12/27.
//  Copyright © 2016年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StatusModel;

@interface BaseModel : NSObject

/// 修改映射参数名 子类重写
+ (NSDictionary *)mj_replacedKeyFromPropertyName;

/// 数组中需要转换的模型类 子类重写
+ (NSDictionary *)mj_objectClassInArray;

/// 映射方法 字典对象，rs对应的是哪个类
+ (StatusModel *)statusModelFromJSONObject:(id)object class:(Class)class;

#pragma mark - DB
//重载选择 使用的LKDBHelper
+ (LKDBHelper *)getUsingLKDBHelper;

//在类 初始化的时候
+(void)initialize;

@end
