//
//  NSNumber+GT.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/5.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "NSNumber+GT.h"

@implementation NSNumber (GT)

- (NSString *)toString {
    
    return [NSString stringWithFormat:@"%@",self];
}

// 汇率转换 分->元
- (NSString *)centToYuan
{
    return [NSString stringWithFormat:@"%.2f",[self doubleValue] * 0.01];
}

@end
