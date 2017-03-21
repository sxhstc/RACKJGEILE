//
//  StaffModel.h
//  RACKJ
//
//  Created by hua on 2017/1/18.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "BaseModel.h"

@interface StaffModel : BaseModel

@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSNumber *nameId;
@property (nonatomic, copy) NSNumber *sex;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *photourl;
@property (nonatomic, copy) NSString *note;

@end
