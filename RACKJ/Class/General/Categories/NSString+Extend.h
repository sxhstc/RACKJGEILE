//
//  NSString+Extend.h
//  RACKJ
//
//  Created by hua on 2017/1/10.
//  Copyright © 2017年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)

- (NSString *)MD5;
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;
- (NSString *)trim;
- (NSArray *)words;
- (NSString *)getOutOfTheNumber;
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;
+ (NSString *)jsonStringWithArray:(NSArray *)array;
+ (NSString *)jsonStringWithString:(NSString *) string;
+ (NSString *)jsonStringWithObject:(id) object;
- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;
@end

@interface NSMutableString (EasyExtend)

typedef NSMutableString *	(^NSMutableStringAppendBlock)( id format, ... );
@property(nonatomic,readonly) NSMutableStringAppendBlock APPEND;
+(NSMutableString *)stringFromResFile:(NSString *)name encoding:(NSStringEncoding)encode;

@end
