//
//  UIViewController+GT.h
//  GoldTreasure
//
//  Created by ZZN on 2017/8/11.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GT)


/**
 侧滑手势

 @param isEnable bool
 */
- (void) interactivePopGesture:(BOOL) isEnable;

/**
 push控制器

 @param viewController viewControler
 */
- (void) pushController:(UIViewController *)viewController;
@end
