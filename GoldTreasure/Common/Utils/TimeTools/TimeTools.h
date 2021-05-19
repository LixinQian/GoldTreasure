//
//  TimeTools.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/23.
//  Copyright © 2017年 王超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTools : NSObject

/**
 *  将时间戳转换为时间
 *
 *  @param timestamp 需要转换的时间戳
 *
 *  @return 转换得到的字符串
 */
+(NSString *)stringFromTimestamp:(NSTimeInterval)timestamp;

@end
