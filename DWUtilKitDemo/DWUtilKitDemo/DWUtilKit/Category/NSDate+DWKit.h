//
//  NSDate+DWKit.h
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/10.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DWKit)

@property (nonatomic, readonly) NSDateComponents *dateComponents;

@property (nonatomic, readonly) NSInteger year;
/// 1 ~ 12
@property (nonatomic, readonly) NSInteger month;
/// 1 ~ 31
@property (nonatomic, readonly) NSInteger day;
/// 0 ~ 23
@property (nonatomic, readonly) NSInteger hour;
/// 0 ~ 59
@property (nonatomic, readonly) NSInteger minute;
/// 0 ~ 59
@property (nonatomic, readonly) NSInteger second;
@property (nonatomic, readonly) NSInteger nanosecond;
/// Weekday component (1~7, first day is based on user setting)
@property (nonatomic, readonly) NSInteger weekday;
/// 周一、周二....周日 where for the Gregorian calendar N=7 and 1 is Sunday
@property (nonatomic, readonly) NSString  *weekdayZH;
/// 星期的序数
@property (nonatomic, readonly) NSInteger weekdayOrdinal;
/// WeekOfMonth component (1~5)
@property (nonatomic, readonly) NSInteger weekOfMonth;
@property (nonatomic, readonly) NSInteger weekOfYear;
@property (nonatomic, readonly) NSInteger yearForWeekOfYear;
/// 季度
@property (nonatomic, readonly) NSInteger quarter;
/// 是不是闰月
@property (nonatomic, readonly) BOOL isLeadMonth;
/// 是不是闰年
@property (nonatomic, readonly) BOOL isLeadYear;
/// 基于当前的环境 是不是今天
@property (nonatomic, readonly) BOOL isToday;
/// 是不是昨天
@property (nonatomic, readonly) BOOL isYesterday;
/// 是不是本月
@property (nonatomic, readonly) BOOL isThisMonth;
/// 是不是今年
@property (nonatomic, readonly) BOOL isThisYear;

#pragma mark - add time method

- (NSDate *)dw_dateByAddingYears:(NSInteger)years;

- (NSDate *)dw_dateByAddingMonths:(NSInteger)months;

- (NSDate *)dw_dateByAddingWeeks:(NSInteger)weeks;

- (NSDate *)dw_dateByAddingDays:(NSInteger)days;

- (NSDate *)dw_dateByAddingHours:(NSInteger)hours;

- (NSDate *)dw_dateByAddingMinutes:(NSInteger)minutes;

- (NSDate *)dw_dateByAddingSeconds:(NSInteger)seconds;

#pragma mark - format

/// 根据周一...周日的格式，返回当前日期的日期
- (NSString *)dw_weekdayFormatter:(NSArray *)formatter;

- (NSString *)dw_stringWithFormat:(NSString *)string;

- (NSString *)dw_stringWithFormat:(NSString *)string timeZone:(NSTimeZone *)timeZone
                           locale:(NSLocale *)locale;

/// return 2017-03-12 T 16:34:26 +0800
- (NSString *)dw_stringWithISOFormat;

+ (NSDate *)dw_dateWithString:(NSString *)dateString format:(NSString *)format;

+ (NSDate *)dw_dateWithString:(NSString *)dateString format:(NSString *)format
                     timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;

+ (NSDate *)dw_dateWithISOFormatString:(NSString *)dateString;

#pragma mark - Util

// 判断是不是同一天
- (BOOL)dw_isOnSameDay:(NSDate *)date;

// 比较两个时间的差值
- (NSDateComponents *)dw_getDifferenceFromDate:(NSDate *)date;

@end
