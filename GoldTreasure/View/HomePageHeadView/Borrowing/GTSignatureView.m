//
//  GTSignatureView.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/4.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTSignatureView.h"

@interface GTSignatureView ()

// 用来设置线条的颜色
@property (nonatomic, strong) UIColor *color;
// 用来设置线条的宽度
@property (nonatomic, assign) CGFloat lineWidth;

// 声明一条贝塞尔曲线
@property(nonatomic, strong) UIBezierPath *bezier;
// 创建一个存储后退操作记录的数组
@property(nonatomic, strong) NSMutableArray *cancleArr;
// 用来记录已有线条
@property (nonatomic, strong) NSMutableArray *allLines;

//签名提示
@property (nonatomic, strong) UILabel *explainLabel;

@end

@implementation GTSignatureView

// 初始化一些参数
- (instancetype)initSignatureView {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [GTColor gtColorC3];

        self.color = [UIColor blackColor];
        self.lineWidth = 2;
        self.allLines = [NSMutableArray new];
        self.cancleArr = [NSMutableArray new];
        
        [self addSubview:self.explainLabel];
        
    }
    
    return self;
}
-(void)resetLabel
{
    self.explainLabel.frame = self.frame;
}
-(UILabel *)explainLabel
{
    if (!_explainLabel) {
        _explainLabel = [[UILabel alloc] initWithFrame:self.frame];
        _explainLabel.font = [GTFont gtFontF64];
        _explainLabel.textColor = [GTColor gtColorC7];
        _explainLabel.text = @"请用正楷签名";
        _explainLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _explainLabel;
}

- (void)doCancel {
    
    if (self.allLines.count > 0) {
        
        [self.cancleArr addObjectsFromArray:self.allLines];
        [self.allLines removeAllObjects];
        [self setNeedsDisplay];
        
        [self addSubview:self.explainLabel];

    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 贝塞尔曲线
    self.bezier = [UIBezierPath bezierPath];
    
    // 获取触摸的点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 设置贝塞尔起点
    [self.bezier moveToPoint:point];
    
    // 在字典保存每条线的数据
    NSMutableDictionary *tempDic = [NSMutableDictionary new];
    [tempDic setObject:self.color forKey:@"color"];
    [tempDic setObject:[NSNumber numberWithFloat:self.lineWidth] forKey:@"lineWidth"];
    [tempDic setObject:self.bezier forKey:@"line"];
    
    // 存入线
    [self.allLines addObject:tempDic];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_explainLabel) {
        [_explainLabel removeFromSuperview];
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.bezier addLineToPoint:point];
    //重绘界面
    [self setNeedsDisplay];

}

- (void)drawRect:(CGRect)rect {
    for (int i = 0; i < self.allLines.count; i++) {
        
        NSDictionary *temDic = self.allLines[i];
        UIColor *color = temDic[@"color"];
        CGFloat width = [temDic[@"lineWidth"] floatValue];
        UIBezierPath *path = temDic[@"line"];
        
        [color setStroke];
        [path setLineWidth:width];
        [path stroke];
        
    }
    
    self.setBlock(self.allLines.count);

}


- (void)saveImage:(SaveSuccessBlock)saveSuccessBlock {
    // 截屏
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 截取画板尺寸
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // 截图保存相册
//    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    
    if (saveSuccessBlock) {
        saveSuccessBlock(newImage);
    }
    
}

@end
