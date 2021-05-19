//
//  UILabel+Extension.h
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

//create label
+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)color;

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)color text:(NSString *)text;

@end
