//
//  UIViewController+GT.m
//  GoldTreasure
//
//  Created by ZZN on 2017/8/11.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "UIViewController+GT.h"

@implementation UIViewController (GT)


- (void) interactivePopGesture:(BOOL) isEnable {
    //
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.navigationController.interactivePopGestureRecognizer setEnabled:isEnable];
    }
}

- (void) pushController:(UIViewController *)viewController {
    
    if (self.navigationController != nil) {
    
        WEAKSELF
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          
            [weakSelf.navigationController pushViewController:viewController animated:true];
        }];
    }
}

@end
