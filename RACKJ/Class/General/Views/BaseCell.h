//
//  BaseCell.h
//  RACKJ
//
//  Created by hua on 2016/12/28.
//  Copyright © 2016年 hua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

/**
 *  添加子View到主View
 */
- (void)setupViews;

/**
 *  绑定V与VM
 */
- (void)bindViewModel;

@end
