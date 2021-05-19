//
//  TimeTools.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/23.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "TimeTools.h"

@implementation TimeTools

#pragma mark 时间戳转时间
+(NSString *)stringFromTimestamp:(NSTimeInterval)timestamp
{
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    if ([[self getDateStringByString:date] isEqualToString:@"今天"]) {
        [dateFormatter setDateFormat:@"今天 HH:mm:ss"];
    }
    else if ([[self getDateStringByString:date] isEqualToString:@"昨天"])
    {
        [dateFormatter setDateFormat:@"昨天 HH:mm:ss"];
    }
    else {
        [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    }
    dateString = [dateFormatter stringFromDate:date];
    
    //输出格式为：2010-10-27 10:22:13
    
    return dateString;
}
#pragma mark 判断日期是昨天还是今天
+(NSString *)getDateStringByString:(NSDate *)date
{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}


@end
