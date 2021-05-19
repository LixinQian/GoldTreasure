//
//  GTForgetPasswordController.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/29.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTBaseViewController.h"

@interface GTForgetPasswordController : GTBaseViewController

/**
 区分点击什么按钮进来的，1位忘记密码，2修改登录密码
 */
@property (nonatomic, assign) NSInteger passWordFlag;

@end
