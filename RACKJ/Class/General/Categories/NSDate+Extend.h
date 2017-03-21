//
//  NSDate+Extend.h
//  RACKJ
//
//  Created by hua on 2017/1/10.
//  Copyright © 2017年 hua. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSInteger SECOND;
extern const NSInteger MINUTE;
extern const NSInteger HOUR;
extern const NSInteger DAY;
extern const NSInteger MONTH;
extern const NSInteger YEAR;

@interface NSDate (Extend)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;

- (NSString *)stringWithDateFormat:(NSString *)format;
- (NSString *)nowDateSring;
- (NSString *)timeAgo;
- (NSString *)timeLeft;

+ (long long)timeStamp;

+ (NSDate *)dateWithString:(NSString *)string format:(NSString*)format;
+ (NSDate *)now;

+ (void)NSLongNowTime;

+ (UInt64)nowTimeStamp;

@end
