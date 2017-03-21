//
//  BaseModel.m
//  RACKJ
//
//  Created by hua on 2016/12/27.
//  Copyright © 2016年 hua. All rights reserved.
//

#import "BaseModel.h"
#import "StatusModel.h"

@implementation BaseModel

/// 修改映射参数名 子类重写
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return nil;
}

/// 数组中需要转换的模型类 子类重写
+ (NSDictionary *)mj_objectClassInArray {
    return nil;
}

/// 映射方法 字典对象
+ (StatusModel *)statusModelFromJSONObject:(id)object class:(Class)class {
    
    // Tell MJExtension what type model will be contained in rs.
    [StatusModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"list" : class
                 };
    }];
    // JSON -> StatusResult
    StatusModel *result = [StatusModel mj_objectWithKeyValues:object];
    return result;
}

#pragma mark - DB

//重载选择 使用的LKDBHelper
+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSString* dbpath = [NSHomeDirectory() stringByAppendingPathComponent:@"asd/asd.db"];
//        db = [[LKDBHelper alloc]initWithDBPath:dbpath];
//or
        db = [[LKDBHelper alloc]init];
    });
    return db;
}

//在类 初始化的时候
+(void)initialize
{
    //remove unwant property
    //比如 getTableMapping 返回nil 的时候   会取全部属性  这时候 就可以 用这个方法  移除掉 不要的属性
    [self removePropertyWithColumnName:@"error"];
    
    
    //simple set a column as "LKSQL_Mapping_UserCalculate"
    //根据 属性名  来启用自己计算
    //[self setUserCalculateForCN:@"error"];
    
    
    //根据 属性类型  来启用自己计算
    //[self setUserCalculateForPTN:@"NSDictionary"];
    
    //enable own calculations
    //[self setUserCalculateForCN:@"address"];
    
    //enable the column binding property name
    //[self setTableColumnName:@"MyAge" bindingPropertyName:@"age"];
    //[self setTableColumnName:@"MyDate" bindingPropertyName:@"date"];
}

////主键
//+(NSString *)getPrimaryKey
//{
//    return @"name";
//}

////表名
//+(NSString *)getTableName
//{
//    return @"LKTestTable";
//}


@end
