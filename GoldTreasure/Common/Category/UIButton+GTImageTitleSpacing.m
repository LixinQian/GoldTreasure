//
//  UIButton+GTImageTitleSpacing.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "UIButton+GTImageTitleSpacing.h"
#import <objc/runtime.h>


@interface UIButton ()
//// 保存上次点击 时间
//@property (nonatomic, assign) NSTimeInterval previousTime;

@end

@implementation UIButton (GTImageTitleSpacing)

static NSString *timeInvervalKey = @"timeInvervalKey";
static NSString *previousTimeKey = @"previousTimeKey";

- (void)layoutButtonWithEdgeInsetsStyle:(GTButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space
{
    //    self.backgroundColor = [UIColor cyanColor];
    
    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case GTButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case GTButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case GTButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case GTButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;

}


+(void)load {
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [self class];
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(handleSendAction:to:forEvents:);
        swizzleMethod(targetClass, originalSelector, swizzledSelector);
    });
}

// 交换方法
void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    IMP swizzledImp = method_getImplementation(swizzledMethod);
    char *swizzledTypes = (char *)method_getTypeEncoding(swizzledMethod);
    
    IMP originalImp = method_getImplementation(originalMethod);
    char *originalTypes = (char *)method_getTypeEncoding(originalMethod);
    
    BOOL success = class_addMethod(class, originalSelector, swizzledImp, swizzledTypes);
    if (success) {
        // Add Method
        class_replaceMethod(class, swizzledSelector, originalImp, originalTypes);
    }else {
        // 直接交换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

// 处理按钮事件传递
- (void)handleSendAction:(SEL)action to:(id)target forEvents:(UIEvent *)event {
    
    
    // 辞去键盘
    [[UIApplication sharedApplication].keyWindow endEditing:true];
    [self handleSendAction:action to:target forEvents:event];
//    // 点击间隔
//    NSTimeInterval nowTime = [[[NSDate alloc] init] timeIntervalSince1970];
//    NSTimeInterval interval = nowTime - self.previousTime;
//    
//    
//    if (interval < self.timeInterval) {
//        
//        NSLog(@"---重复点击了%f",interval);
//        return;
//    }
//    
//    self.previousTime = nowTime;
//    
//    NSLog(@"\n当前时间戳:%f\n上次点击时间:%f\n时间间隔:%f",nowTime,self.previousTime,interval);
}

//- (void) sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
//    [super sendAction:action to:target forEvent:event];
//}
//
//- (void)setTimeInterval:(NSTimeInterval)timeInterval {
//    
//    objc_setAssociatedObject(self, &timeInvervalKey, @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void)setPreviousTime:(NSTimeInterval)previousTime {
//    
//    objc_setAssociatedObject(self, &previousTimeKey, @(previousTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSTimeInterval)timeInterval {
//    
//    // 默认间隔为1，若不设间隔 可设为 -1 或 < 0
//    NSTimeInterval interval = (NSTimeInterval) [objc_getAssociatedObject(self, &timeInvervalKey) floatValue];
//    NSTimeInterval newInterval = interval == 0 ? 1:interval;
//    
//    return interval < 0 ? 0:newInterval;
//}
//
//- (NSTimeInterval)previousTime {
//    
//    NSTimeInterval pTime = (NSTimeInterval) [objc_getAssociatedObject(self, &previousTimeKey) floatValue];
//    return pTime;
//}

@end
