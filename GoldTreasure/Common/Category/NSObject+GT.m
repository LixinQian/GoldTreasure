//
//  NSObject+GT.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/5.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "NSObject+GT.h"

@implementation NSObject (GT)

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
