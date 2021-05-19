//
//  GTFont.m
//  GoldTreasure
//
//  Created by wangyaxu on 27/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTFont.h"

@implementation GTFont

+ (UIFont *)gtFontF1
{
    return  [self fontWithSize:18 weight:UIFontWeightRegular];
}

+ (UIFont *)gtFontF1Medium
{
    return  [self fontWithSize:18 weight:UIFontWeightMedium];
}

+ (UIFont *)gtFontF2
{
    return  [self fontWithSize:16 weight:UIFontWeightRegular];
}

+ (UIFont *)gtFontF2Medium
{
    return  [self fontWithSize:16 weight:UIFontWeightMedium];
}

+ (UIFont *)gtFontF3
{
    return  [self fontWithSize:14 weight:UIFontWeightRegular];
}

+ (UIFont *)gtFontF4
{
    return  [self fontWithSize:12 weight:UIFontWeightRegular];
}

+ (UIFont *)gtFontF5
{
    return  [self fontWithSize:36 weight:UIFontWeightRegular];
}

+ (UIFont *)gtFontF6
{
    return  [self fontWithSize:20 weight:UIFontWeightRegular];
}

+ (UIFont *)gtFontF6Medium
{
    return  [self fontWithSize:20 weight:UIFontWeightMedium];
}

+ (UIFont *)gtFontF7
{
    return  [self fontWithSize:24 weight:UIFontWeightRegular];
}

+ (UIFont *)gtFontF7Medium
{
    return  [self fontWithSize:24 weight:UIFontWeightMedium];
}

+ (UIFont *)gtFontF8
{
    return  [self fontWithSize:32 weight:UIFontWeightRegular];
}

+ (UIFont *)gtFontF48
{
    return  [self fontWithSize:48 weight:UIFontWeightRegular];
}

+ (UIFont *)gtFontF64
{
    return  [self fontWithSize:64 weight:UIFontWeightRegular];
}

+ (UIFont *)fontWithSize:(CGFloat )size weight:(CGFloat)weight
{
    return [UIFont systemFontOfSize:autoScaleW(size) weight:weight];
}

@end
