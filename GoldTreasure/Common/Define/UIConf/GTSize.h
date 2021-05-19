//
//  GTSize.h
//  GoldTreasure
//
//  Created by ZZN on 2017/7/26.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTSize : NSObject

// 获取相对屏幕宽度比例
+ (CGFloat) getScaleW:(CGFloat)w;
// 获取相对屏幕高度比例
+ (CGFloat) getScaleH:(CGFloat)h;

@end
