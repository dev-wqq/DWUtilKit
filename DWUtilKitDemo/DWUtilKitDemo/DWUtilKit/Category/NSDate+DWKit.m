//
//  NSDate+DWKit.m
//  DWUtilKitDemo
//
//  Created by wangqiqi on 2017/3/10.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "NSDate+DWKit.h"
#import <objc/runtime.h>

static const void *DWDateComponentKey = &DWDateComponentKey;

@implementation NSDate (DWKit)

- (NSDateComponents *)dateComponents {
    NSDateComponents *dateComponents = objc_getAssociatedObject(self, &DWDateComponentKey);
    if (!dateComponents) {
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitQuarter | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear | NSCalendarUnitNanosecond | NSCalendarUnitCalendar | NSCalendarUnitTimeZone;
        dateComponents = [[NSCalendar currentCalendar] components:unit fromDate:self];
        objc_setAssociatedObject(self, &DWDateComponentKey, dateComponents, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dateComponents;
}

- (NSInteger)year {
    return self.dateComponents.year;
}

- (NSInteger)month {
    return self.dateComponents.month;
}

- (NSInteger)day {
    return self.dateComponents.day;
}

- (NSInteger)hour {
    return self.dateComponents.hour;
}

- (NSInteger)minute {
    return self.dateComponents.minute;
}

- (NSInteger)second {
    return self.dateComponents.second;
}

- (NSInteger)nanosecond {
    return self.dateComponents.nanosecond;
}

- (NSInteger)weekday {
    return self.dateComponents.weekday;
}

- (NSString *)weekdayZH {
    NSArray *weekdayZHArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    return [self dw_weekdayFormatter:weekdayZHArray];
}

- (NSInteger)weekdayOrdinal {
    return self.dateComponents.weekdayOrdinal;
}

- (NSInteger)quarter {
    return self.dateComponents.quarter;
}

- (NSInteger)weekOfMonth {
    return self.dateComponents.weekOfMonth;
}

- (NSInteger)weekOfYear {
    return self.dateComponents.weekOfYear;
}

- (NSInteger)yearForWeekOfYear {
    return self.dateComponents.yearForWeekOfYear;
}

- (BOOL)isLeadMonth {
    return [self.dateComponents isLeapMonth];
}


- (BOOL)isLeadYear {
    NSUInteger year = self.year;
    if ((year % 400 == 0) || (year % 100 == 0) || (year % 4 == 0)) return YES;
    return NO;
}

- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) {
        return NO;
    }
    return [NSDate new].day == self.day;
}

- (BOOL)isYesterday {
    NSDate *date = [self dw_dateByAddingDays:1];
    return date.isToday;
}

- (BOOL)isThisMonth {
    NSDate *currentDate = [NSDate date];
    return self.month == currentDate.month;
}

- (BOOL)isThisYear {
    NSDate *currentDate = [NSDate date];
    return self.year == currentDate.year;
}

#pragma mark - add time method

- (NSDate *)dw_dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dw_dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dw_dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calender dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dw_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dw_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dw_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dw_dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark - format

- (NSString *)dw_weekdayFormatter:(NSArray *)formatter {
    NSInteger weekday = [self weekday];
    NSAssert(weekday >= 1 && weekday <= formatter.count, @"周几是从1到7");
    return formatter[weekday-1];
}

- (NSString *)dw_stringWithFormat:(NSString *)string {
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    [formattor setDateFormat:string];
    [formattor setLocale:[NSLocale currentLocale]];
    return [formattor stringFromDate:self];
}

- (NSString *)dw_stringWithFormat:(NSString *)string timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    [formattor setDateFormat:string];
    if (timeZone) {
        [formattor setTimeZone:timeZone];
    }
    if (locale) {
        [formattor setLocale:locale];
    }
    return [formattor stringFromDate:self];
}

- (NSString *)dw_stringWithISOFormat {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd 'T' HH:mm:ss Z";
    });
    return [formatter stringFromDate:self];
}

+ (NSDate *)dw_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dw_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dw_dateWithISOFormatString:(NSString *)dateString {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd 'T' HH:mm:ss Z";
    });
    return [formatter dateFromString:dateString];
}

#pragma mark - Util

- (BOOL)dw_isOnSameDay:(NSDate *)date {
    return self.year == date.year &&
    self.month == date.month &&
    self.day == date.day;
}

- (NSDateComponents *)dw_getDifferenceFromDate:(NSDate *)date {
    // 日历
    NSCalendar *calender = [NSCalendar currentCalendar];
    // 比较时间的单位
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calender components:unit fromDate:date toDate:self options:0];
}

@end
