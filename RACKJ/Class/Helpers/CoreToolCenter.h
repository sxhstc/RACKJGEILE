//
//  CoreToolCenter.h
//  RACKJ
//
//  Created by hua on 2017/1/4.
//  Copyright © 2017年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreToolCenter : NSObject

extern void ShowSuccessStatus(NSString *statues);
extern void ShowErrorStatus(NSString *statues);
extern void ShowMaskStatus(NSString *statues);
extern void ShowMessage(NSString *statues);
extern void ShowProgress(CGFloat progress);
extern void DismissHud(void);

@end
