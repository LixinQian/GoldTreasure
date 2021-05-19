//
//  GTBaseViewController.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTBaseViewController : UIViewController
/**
 *  返回导航栏上一页面
 */
-(void)returnBackAction;

- (void) hiddenNavBarShadow;
- (void) showNavNarShadow;
- (void) transNav:(BOOL)isTrue;

@end
