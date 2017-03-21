//
//  NSData+Extend.h
//  RACKJ
//
//  Created by hua on 2017/1/10.
//  Copyright © 2017年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSData (Extend)

@property (nonatomic, readonly) NSData *	MD5;
@property (nonatomic, readonly) NSString *	MD5String;

+ (NSData *)fromResource:(NSString *)resName;

@end
