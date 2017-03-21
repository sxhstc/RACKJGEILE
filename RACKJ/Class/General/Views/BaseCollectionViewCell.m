//
//  BaseCollectionViewCell.m
//  RACKJ
//
//  Created by hua on 2017/1/3.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {}

@end
