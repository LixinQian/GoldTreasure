//
//  UIButton+GTImageTitleSpacing.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GTButtonEdgeInsetsStyle) {
    GTButtonEdgeInsetsStyleTop, // image在上，label在下
    GTButtonEdgeInsetsStyleLeft, // image在左，label在右
    GTButtonEdgeInsetsStyleBottom, // image在下，label在上
    GTButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (GTImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(GTButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

/** 时间间隔 -1 为可连续点击*/
//@property (nonatomic, assign) NSTimeInterval timeInterval;


@end
