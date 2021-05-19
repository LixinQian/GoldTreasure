//
//  NSDate+Custom.m
//  GoldTreasure
//
//  Created by targeter on 2017/7/19.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

static NSString *const kFormatterYYYYMMDDBirthday = @"yyyy-MM-dd";
static NSString *const kFormatterHHMMTime = @"HH:mm";
static NSString *const kFormatterEEEEWeekday = @"EEEE";
static NSString *const kFormatterYYYYMMDDRidingDate = @"yyyy.MM.dd";
static int const SecondPerHour = 3600;
static int const SecondPerMinute = 60;

#import "NSDate+Custom.h"
@implementation NSDate (Custom)

+ (NSUInteger)weekdayOfToday {
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitWeekday) fromDate:today];
    NSUInteger weekday = [weekdayComponents weekday];
    return weekday;
}

+ (NSString *)readableDateForDate:(NSDate *)date {
    return [NSDate readableDateForDate:date
                             dateStyle:NSDateFormatterLongStyle
                             timeStyle:NSDateFormatterNoStyle];
}

+ (NSString *)readableDateForDate:(NSDate *)date
                        dateStyle:(NSDateFormatterStyle)dateStyle
                        timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:dateStyle];
    [dateFormatter setTimeStyle:timeStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
}

+ (NSNumber *)ageFromBirthday:(NSDate *)birthday {
    if (![birthday isKindOfClass:[NSDate class]]) {
        return nil;
    }
    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    return @([ageComponents year]);
}

+ (NSString *)relativeDateStringForDate:(NSDate *)date {
    if (![date isKindOfClass:[NSDate class]]) {
        return nil;
    }
    
    long long durationJustNow = 10;
    long long secondsPerMinute = 60;
    long long minutesPerHour = 60;
    long long hoursPerDay = 24;
    long long daysPerWeek = 7;
    long long weeksPerMonth = 5;
    long long daysPerMonth = 30;
    long long daysPerYear = 365;
    
    long long currentInterval = [[NSDate date] timeIntervalSince1970];
    long long relativeInterval = [date timeIntervalSince1970];
    long long differentInterval = currentInterval - relativeInterval;
    
    NSString *defaultDateFormatter = @"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = defaultDateFormatter;
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    if (relativeInterval > currentInterval) {
        return dateString;
    }
    
    if (differentInterval <= durationJustNow) {
        dateString = @"刚刚";
    } else if (differentInterval <= secondsPerMinute) {
        dateString = [NSString stringWithFormat:@"%@秒前", @(differentInterval)];
    } else if (differentInterval < secondsPerMinute * minutesPerHour) {
        differentInterval = differentInterval / secondsPerMinute;
        dateString = [NSString stringWithFormat:@"%@分钟前", @(differentInterval)];
    } else if (differentInterval < secondsPerMinute * minutesPerHour * hoursPerDay) {
        differentInterval = differentInterval / (secondsPerMinute * minutesPerHour);
        dateString = [NSString stringWithFormat:@"%@小时前", @(differentInterval)];
    } else if (differentInterval < secondsPerMinute * minutesPerHour * hoursPerDay * daysPerWeek) {
        differentInterval = differentInterval / (secondsPerMinute * minutesPerHour * hoursPerDay);
        dateString = [NSString stringWithFormat:@"%@天前", @(differentInterval)];
    } else if (differentInterval < secondsPerMinute * minutesPerHour * hoursPerDay * daysPerWeek * weeksPerMonth) {
        differentInterval = differentInterval / (secondsPerMinute * minutesPerHour * hoursPerDay * daysPerWeek);
        dateString = [NSString stringWithFormat:@"%@周前", @(differentInterval)];
    } else if (differentInterval < secondsPerMinute * minutesPerHour * hoursPerDay * daysPerYear) {
        differentInterval = differentInterval / (secondsPerMinute * minutesPerHour * hoursPerDay * daysPerMonth);
        dateString = [NSString stringWithFormat:@"%@个月前", @(differentInterval)];
    } else {
        differentInterval = differentInterval / (secondsPerMinute * minutesPerHour * hoursPerDay * daysPerYear);
        dateString = [NSString stringWithFormat:@"%@年前", @(differentInterval)];
    }
    
    return dateString;
}

- (NSString *)dateStringWithFormatterYYYYMMDD {
    return [self dateStringWithDateFormatter:kFormatterYYYYMMDDBirthday];
}

- (NSString *)dateStringWithFormatterHHMM {
    return [self dateStringWithDateFormatter:kFormatterHHMMTime];
}

- (NSString *)dateStringWithFormatterEEEE {
    return [self dateStringWithDateFormatter:kFormatterEEEEWeekday];
}

- (NSString *)dateStringWithRidingDateFormatterYYYYMMDD {
    return [self dateStringWithDateFormatter:kFormatterYYYYMMDDRidingDate];
}

- (NSString *)dateStringWithDateFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *birthday = [dateFormatter stringFromDate:self];
    return birthday;
}

+ (NSString *)hoursStringWithDuration:(long long)duration {
    long long hours = duration / SecondPerHour;
    return [NSDate timeStringWithCount:hours];
}

+ (NSString *)minutesStringWithDuration:(long long)duration {
    long long hours = duration / SecondPerHour;
    long long minutes = (duration - (hours * SecondPerHour)) / SecondPerMinute;
    return [NSDate timeStringWithCount:minutes];
}

+ (NSString *)secondsStringWithDuration:(long long)duration {
    NSUInteger seconds = (NSUInteger)duration % SecondPerMinute;
    return [NSDate timeStringWithCount:seconds];
}

+ (NSString *)durationStringWithDuration:(long long)duration {
    NSString *hoursString = [NSDate hoursStringWithDuration:duration];
    NSString *minutesString = [NSDate minutesStringWithDuration:duration];
    NSString *secondsString = [NSDate secondsStringWithDuration:duration];
    NSString *format = duration >= SecondPerHour ? @"%@:%@:%@" : @"%@:%@";
    NSString *durationString;
    if (duration >= SecondPerHour) {
        durationString = [NSString stringWithFormat:format,
                          hoursString,
                          minutesString,
                          secondsString];
    } else {
        durationString = [NSString stringWithFormat:format,
                          minutesString,
                          secondsString];
    }
    return durationString;
}

- (NSString *)timeStringWithSixDays
{
    return [[NSDate dateWithTimeInterval:60 * 60 * 24 * 6 sinceDate:self] dateStringWithFormatterYYYYMMDD];
}

+ (NSString *)timeStringWithCount:(long long)count {
    NSString *countString = count < 10 ?
    [NSString stringWithFormat:@"0%@", @(count)] : [NSString stringWithFormat:@"%@", @(count)];
    return countString;
}

@end
