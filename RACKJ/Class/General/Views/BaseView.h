//
//  BaseView.h
//  RACKJ
//
//  Created by hua on 2016/12/27.
//  Copyright © 2016年 hua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

- (instancetype)initWithViewModel:(id)viewModel;

/**
 *  绑定V与VM
 */
- (void)bindViewModel;

/**
 *  添加子View到主View
 */
- (void)setupViews;

/**
 *  设置点击空白键盘回收
 */
- (void)addReturnKeyBoard;

@end
