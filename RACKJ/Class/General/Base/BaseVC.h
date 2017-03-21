//
//  BaseVC.h
//  RACKJ
//
//  Created by hua on 2016/12/27.
//  Copyright © 2016年 hua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

/**
 *  添加控件
 */
- (void)addSubviews;

/**
 *  绑定
 */
- (void)bindViewModel;

/**
 *  设置navation
 */
- (void)layoutNavigation;

/**
 *  初次获取数据
 */
- (void)getNewData;


@end
