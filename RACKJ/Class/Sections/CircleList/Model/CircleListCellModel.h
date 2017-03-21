//
//  CircleListCellModel.h
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"
#import "AdModel.h"

@interface CircleListCellModel : BaseModel

@property (nonatomic, copy) NSString *headerImageStr;
@property (nonatomic, copy) NSString *peopleName;
@property (nonatomic, copy) NSNumber *articleNum;
@property (nonatomic, copy) NSString *peopleNum;
@property (nonatomic, copy) NSString *topicNum;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSArray *ads;

@end
