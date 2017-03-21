//
//  CoreToolCenter.m
//  RACKJ
//
//  Created by hua on 2017/1/4.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "CoreToolCenter.h"

@implementation CoreToolCenter

+ (void)load{
//    [SVProgressHUD setBackgroundColor:RGBACOLOR(0, 0, 0, 0.8)];
//    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setInfoImage:nil];
}

void ShowSuccessStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:statues];
        });
    }else{
        [SVProgressHUD showSuccessWithStatus:statues];
    }
}


void ShowMessage(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:statues];
        });
    }else{
        [SVProgressHUD showInfoWithStatus:statues];
    }
}

void ShowErrorStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:statues];
//            [SVProgressHUD showProgress:0.5 status:@"上传" maskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showProgress:0.5 status:@"上传"];
        });
    }else{
        [SVProgressHUD showErrorWithStatus:statues];
    }
}


void ShowMaskStatus(NSString *statues){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD showWithStatus:statues maskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showWithStatus:statues];
        });
    }else{
//        [SVProgressHUD showWithStatus:statues maskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:statues];
    }
}

void ShowProgress(CGFloat progress){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD showProgress:progress maskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showProgress:progress];
        });
    }else{
//        [SVProgressHUD showProgress:progress maskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showProgress:progress];
    }
}

void DismissHud(void){
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }else{
        [SVProgressHUD dismiss];
    }
}


@end
