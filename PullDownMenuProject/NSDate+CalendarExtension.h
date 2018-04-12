//
//  NSDate+CalendarExtension.h
//  PullDownMenuProject
//
//  Created by wcx on 2018/4/3.
//  Copyright © 2018年 gupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarExtension)
+ (NSDateComponents *)intervalToDate:(NSDate *)date;
+ (NSDateComponents *)intervalToNow;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

/**
 * 是否为明天
 */
- (BOOL)isTomorrow;

@end
