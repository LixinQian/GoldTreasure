//
//  UILabel+Extension.m
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = color;
    return label;
}

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)color text:(NSString *)text
{
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = color;
    label.text = text;
    return label;
}

@end
