//
//  CircleListViewModel.m
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#import "CircleListViewModel.h"
#import "StatusModel.h"
#import "CircleListCellModel.h"
#import "StaffModel.h"

@interface CircleListViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation CircleListViewModel

- (void)initialize {
    
    @weakify(self);
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        
        @strongify(self);
        
        //请求失败
        if (dict == nil) {
            [self.refreshEndSubject sendNext:@(RefreshError)];
            DismissHud();
            return;
        }
    
        StatusModel *statusModel=[StatusModel statusModelFromJSONObject:dict class:[StaffModel class]];
        self.dataArray=[statusModel.list mutableCopy];

        //是否还有更多
        RefreshDataStatus stauts=HeaderRefresh_HasMoreData;
        if (self.dataArray.count<statusModel.total) {
            stauts=FooterRefresh_HasMoreData;
        } else {
            stauts=FooterRefresh_HasNoMoreData;
        }
        
        //列表刷新
        [self.refreshEndSubject sendNext:@(stauts)];
        DismissHud();
        
        [self.getUserinfoSubject sendNext:statusModel.list];
        
        
    }];
    
    //skip 1 表示跳过第一次信号， take 1 表示从开始只取1次信号
    [[[self.refreshDataCommand.executing skip:1] take:1] subscribeNext:^(id x) {
        
        if ([x isEqualToNumber:@(YES)]) {
            ShowMaskStatus(@"正在加载");
        }
    }];
    
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        
        @strongify(self);
        
        //请求失败
        if (dict == nil) {
            [self.refreshEndSubject sendNext:@(RefreshError)];
            DismissHud();
            return;
        }

        StatusModel *statusModel=[StatusModel statusModelFromJSONObject:dict class:[StaffModel class]];
        [self.dataArray addObjectsFromArray:statusModel.list];
        
        //是否还有更多
        RefreshDataStatus stauts=HeaderRefresh_HasMoreData;
        if (self.dataArray.count<statusModel.total) {
            stauts=FooterRefresh_HasMoreData;
        } else {
            stauts=FooterRefresh_HasNoMoreData;
        }
        
        [self.refreshEndSubject sendNext:@(stauts)];
        DismissHud();
    
        [self.getUserinfoSubject sendNext:statusModel.list];
        
    }];
    
    
//    ///获取单个用户信息
//    [self.userinfoCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
//        
//        @strongify(self);
//        StaffModel *staffModel = [StaffModel mj_objectWithKeyValues:dict];
//
//        for (int i=0; i<self.dataArray.count; i++) {
//            StaffModel *model=self.dataArray[i];
//            if (staffModel.nameId.intValue==model.nameId.intValue) {
//                [self.dataArray replaceObjectAtIndex:i withObject:staffModel];
//                //刷新列表对应的行
//                NSNumber *num=[NSNumber numberWithInt:i];
//                [self.refreshUserinfo sendNext:num];
//                break;
//            }
//        }
//        
//    }];
    
}

- (RACSubject *)refreshUI {
    
    if (!_refreshUI) {
        
        _refreshUI = [RACSubject subject];
    }
    
    return _refreshUI;
}

- (RACSubject *)refreshEndSubject {
    
    if (!_refreshEndSubject) {
        
        _refreshEndSubject = [RACSubject subject];
    }
    
    return _refreshEndSubject;
}

- (RACSubject *)refreshUserinfo {
    
    if (!_refreshUserinfo) {
        
        _refreshUserinfo = [RACSubject subject];
    }
    
    return _refreshUserinfo;
}

- (RACSubject *)getUserinfoSubject {
    @weakify(self);
    if (!_getUserinfoSubject) {
        
        _getUserinfoSubject = [RACSubject subject];
        
        [_getUserinfoSubject subscribeNext:^(id x) {
            NSArray *dataArray=x;
            
            for (StaffModel *model in dataArray) {
                
                NSString *path=[NSString stringWithFormat:@"getuser?id=%@",model.nameId];

                @strongify(self);
                [self.request getRetransmissionWithPath:path params:nil cachePolicy:XHRequestUseProtocolCachePolicy trimTime:SECOND *3 success:^(NSURLSessionDataTask *task, id responseObject, BOOL fromCache) {


                    @strongify(self);
                    StaffModel *staffModel = [StaffModel mj_objectWithKeyValues:responseObject];

                    for (int i=0; i<self.dataArray.count; i++) {
                        StaffModel *model=self.dataArray[i];
                        if (staffModel.nameId.intValue==model.nameId.intValue) {
                            [self.dataArray replaceObjectAtIndex:i withObject:staffModel];
                            //刷新列表对应的行
                            NSNumber *num=[NSNumber numberWithInt:i];
                            [self.refreshUserinfo sendNext:num];
                            break;
                        }
                    }


                } fail:^(NSURLSessionDataTask *task, NSError *error, BOOL fromCache) {
//                    ShowErrorStatus(@"网络连接失败");

                }];
            }
            
            
            
        }];
    }
    return _getUserinfoSubject;
}


- (RACCommand *)refreshDataCommand {
    
    if (!_refreshDataCommand) {
        
        @weakify(self);
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                self.currentPage = 1;
                NSString *path=[NSString stringWithFormat:@"getuserpage?curpage=%ld",self.currentPage];
                [self.request getWithPath:path params:nil cachePolicy:XHRequestUseProtocolCachePolicy trimTime:SECOND *30 success:^(NSURLSessionDataTask *task, id responseObject, BOOL fromCache) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } fail:^(NSURLSessionDataTask *task, NSError *error, BOOL fromCache) {
                    ShowErrorStatus(@"网络连接失败");
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    
    return _refreshDataCommand;
}

- (RACCommand *)nextPageCommand {
    
    if (!_nextPageCommand) {
        
        @weakify(self);
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                self.currentPage ++;
                NSString *path=[NSString stringWithFormat:@"getuserpage?curpage=%ld",self.currentPage];
                [self.request getWithPath:path params:nil cachePolicy:XHRequestUseProtocolCachePolicy trimTime:SECOND *30 success:^(NSURLSessionDataTask *task, id responseObject, BOOL fromCache) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } fail:^(NSURLSessionDataTask *task, NSError *error, BOOL fromCache) {
                    @strongify(self);
                    self.currentPage --;
                    ShowErrorStatus(@"网络连接失败");
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                
                return nil;
                
            }];
        }];
    }
    
    return _nextPageCommand;
}

- (NSArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

- (RACSubject *)cellClickSubject {
    
    if (!_cellClickSubject) {
        
        _cellClickSubject = [RACSubject subject];
    }
    
    return _cellClickSubject;
}


/// 假数据
+ (NSDictionary *)responseDic{

    NSDictionary *dict = @{
                           @"flag": @1,
                           @"totalSize": @18,
                           @"msg": @"查找成功!",
                           @"rs": @[
                                   @{
                                       @"name": @"财税培训圈子",
                                       @"content": @"自己交保险是不是只能交养老和医疗，费用是多少?",
                                       @"articleNum": @1568,
                                       @"peopleNum": @"568",
                                       @"topicNum": @"5749",
                                       @"headerImageStr": @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5",
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               },
                                       @"ads" : @[
                                               @{
                                                   @"image" : @"ad01.png",
                                                   @"url" : @"http://www.ad01.com"
                                                   },
                                               @{
                                                   @"image" : @"ad02.png",
                                                   @"url" : @"http://www.ad02.com"
                                                   }
                                               ]
                                       },
                                   @{
                                       @"name": @"财税培训圈子",
                                       @"content": @"自己交保险是不是只能交养老和医疗，费用是多少?",
                                       @"articleNum": @1568,
                                       @"peopleNum": @"568",
                                       @"topicNum": @"5749",
                                       @"headerImageStr": @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5",
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               },
                                       @"ads" : @[
                                               @{
                                                   @"image" : @"ad01.png",
                                                   @"url" : @"http://www.ad01.com"
                                                   },
                                               @{
                                                   @"image" : @"ad02.png",
                                                   @"url" : @"http://www.ad02.com"
                                                   }
                                               ]
                                       },
                                   @{
                                       @"name": @"财税培训圈子",
                                       @"content": @"自己交保险是不是只能交养老和医疗，费用是多少?",
                                       @"articleNum": @1568,
                                       @"peopleNum": @"568",
                                       @"topicNum": @"5749",
                                       @"headerImageStr": @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5",
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               },
                                       @"ads" : @[
                                               @{
                                                   @"image" : @"ad01.png",
                                                   @"url" : @"http://www.ad01.com"
                                                   },
                                               @{
                                                   @"image" : @"ad02.png",
                                                   @"url" : @"http://www.ad02.com"
                                                   }
                                               ]
                                       },
                                   @{
                                       @"name": @"财税培训圈子",
                                       @"content": @"自己交保险是不是只能交养老和医疗，费用是多少?",
                                       @"articleNum": @1568,
                                       @"peopleNum": @"568",
                                       @"topicNum": @"5749",
                                       @"headerImageStr": @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5",
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               },
                                       @"ads" : @[
                                               @{
                                                   @"image" : @"ad01.png",
                                                   @"url" : @"http://www.ad01.com"
                                                   },
                                               @{
                                                   @"image" : @"ad02.png",
                                                   @"url" : @"http://www.ad02.com"
                                                   }
                                               ]
                                       },
                                   @{
                                       @"name": @"财税培训圈子",
                                       @"content": @"自己交保险是不是只能交养老和医疗，费用是多少?",
                                       @"articleNum": @1568,
                                       @"peopleNum": @"568",
                                       @"topicNum": @"5749",
                                       @"headerImageStr": @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5",
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               },
                                       @"ads" : @[
                                               @{
                                                   @"image" : @"ad01.png",
                                                   @"url" : @"http://www.ad01.com"
                                                   },
                                               @{
                                                   @"image" : @"ad02.png",
                                                   @"url" : @"http://www.ad02.com"
                                                   }
                                               ]
                                       },
                                   @{
                                       @"name": @"财税培训圈子",
                                       @"content": @"自己交保险是不是只能交养老和医疗，费用是多少?",
                                       @"articleNum": @1568,
                                       @"peopleNum": @"568",
                                       @"topicNum": @"5749",
                                       @"headerImageStr": @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5",
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               },
                                       @"ads" : @[
                                               @{
                                                   @"image" : @"ad01.png",
                                                   @"url" : @"http://www.ad01.com"
                                                   },
                                               @{
                                                   @"image" : @"ad02.png",
                                                   @"url" : @"http://www.ad02.com"
                                                   }
                                               ]
                                       },
                                   @{
                                       @"name": @"财税培训圈子",
                                       @"content": @"自己交保险是不是只能交养老和医疗，费用是多少?",
                                       @"articleNum": @1568,
                                       @"peopleNum": @"568",
                                       @"topicNum": @"5749",
                                       @"headerImageStr": @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5",
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               },
                                       @"ads" : @[
                                               @{
                                                   @"image" : @"ad01.png",
                                                   @"url" : @"http://www.ad01.com"
                                                   },
                                               @{
                                                   @"image" : @"ad02.png",
                                                   @"url" : @"http://www.ad02.com"
                                                   }
                                               ]
                                       },
                                   @{
                                       @"name": @"财税培训圈子",
                                       @"content": @"自己交保险是不是只能交养老和医疗，费用是多少?",
                                       @"articleNum": @1568,
                                       @"peopleNum": @"568",
                                       @"topicNum": @"5749",
                                       @"headerImageStr": @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5",
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               },
                                       @"ads" : @[
                                               @{
                                                   @"image" : @"ad01.png",
                                                   @"url" : @"http://www.ad01.com"
                                                   },
                                               @{
                                                   @"image" : @"ad02.png",
                                                   @"url" : @"http://www.ad02.com"
                                                   }
                                               ]
                                       }
                                   ]
                           };
    
    return dict;
    
    //                    responseString=@"{\"flag\":1,\"totalSize\":64,\"msg\":\"查找成功!\",\"rs\":[{\"name\":\"财税培训圈子\",\"content\":\"自己交保险是不是只能交养老和医疗，费用是多少?\",\"articleNum\":\"1568\",\"peopleNum\":\"568\",\"topicNum\":\"5749\",\"headerImageStr\":\"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5\"},{\"name\":\"财税培训圈子\",\"content\":\"自己交保险是不是只能交养老和医疗，费用是多少?\",\"articleNum\":\"1568\",\"peopleNum\":\"568\",\"topicNum\":\"5749\",\"headerImageStr\":\"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5\"},{\"name\":\"财税培训圈子\",\"content\":\"自己交保险是不是只能交养老和医疗，费用是多少?\",\"articleNum\":\"1568\",\"peopleNum\":\"568\",\"topicNum\":\"5749\",\"headerImageStr\":\"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5\"},{\"name\":\"财税培训圈子\",\"content\":\"自己交保险是不是只能交养老和医疗，费用是多少?\",\"articleNum\":\"1568\",\"peopleNum\":\"568\",\"topicNum\":\"5749\",\"headerImageStr\":\"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5\"},{\"name\":\"财税培训圈子\",\"content\":\"自己交保险是不是只能交养老和医疗，费用是多少?\",\"articleNum\":\"1568\",\"peopleNum\":\"568\",\"topicNum\":\"5749\",\"headerImageStr\":\"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5\"},{\"name\":\"财税培训圈子\",\"content\":\"自己交保险是不是只能交养老和医疗，费用是多少?\",\"articleNum\":\"1568\",\"peopleNum\":\"568\",\"topicNum\":\"5749\",\"headerImageStr\":\"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5\"},{\"name\":\"财税培训圈子\",\"content\":\"自己交保险是不是只能交养老和医疗，费用是多少?\",\"articleNum\":\"1568\",\"peopleNum\":\"568\",\"topicNum\":\"5749\",\"headerImageStr\":\"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5\"},{\"name\":\"财税培训圈子\",\"content\":\"自己交保险是不是只能交养老和医疗，费用是多少?\",\"articleNum\":\"1568\",\"peopleNum\":\"568\",\"topicNum\":\"5749\",\"headerImageStr\":\"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5\"}]}";
    //                    NSDictionary *dict = responseString.mj_keyValues;


}


@end
