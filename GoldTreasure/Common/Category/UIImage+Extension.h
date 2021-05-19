//
//  UIImage+Util.h
//  LittleCircle
//
//  Created by Lee on 16/3/31.
//  Copyright © 2016年 trioly.com. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImage (Extension)

// 压缩成指定大小
- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)fixOrientation;


/**
 图片压缩

 @param source_image 原图
 @param maxSize 图片大小 kb
 @param resolution 分辨率
 @return 图片数据
 */
- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize resolution:(CGPoint)resolution;
@end
