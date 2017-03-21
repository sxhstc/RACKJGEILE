//
//  StartAPP.m
//  RACKJ
//
//  Created by hua on 2017/1/4.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "StartAPP.h"
#import "XHNetworking.h"

@implementation StartAPP

+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [[self class] initPersonData];

        [[self class] setKeyBord];
        
        //检测网络
        [XHNetworking AFNetworkStatus];
        
    });
}

#pragma mark - 初始化个人数据
+ (void)initPersonData {
    
}

#pragma mark - 键盘回收相关
+ (void)setKeyBord {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}


@end
