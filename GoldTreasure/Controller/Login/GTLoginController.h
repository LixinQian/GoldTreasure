//
//  GTLoginController.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTBaseViewController.h"

@interface GTLoginController : GTBaseViewController

/**
 登录处理

 model 是 GTResModelUserInfo 兼容swift 写为id类型
 @param succ 成功
 @param fail 失败
 */
- (void) loginUserWith:(void(^)(id model)) succ andWithFail:(void(^)(GTNetError *error)) fail;
@end
