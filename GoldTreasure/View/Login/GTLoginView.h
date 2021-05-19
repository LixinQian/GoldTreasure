//
//  GTLoginView.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTLoginView : UIView

typedef void(^loginBlock)(NSString *telNum,NSString *passWord, UIButton *btn);
typedef void(^jumpBlock)();

/**
 登录按钮回调
 */
@property (nonatomic, copy) loginBlock login;

/**
 注册按钮回调
 */
@property (nonatomic, copy) jumpBlock registerVC;

/**
 忘记密码回调
 */
@property (nonatomic, copy) jumpBlock passWordVC;

//@property (nonatomic, copy) jumpBlock dismissVC;

@end
