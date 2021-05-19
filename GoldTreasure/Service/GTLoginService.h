//
//  GTLoginService.h
//  GoldTreasure
//
//  Created by ZZN on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTResModelUserInfo;
@class RLMResults;

@interface GTLoginService : NSObject

// sington
+ (GTLoginService *_Nonnull)sharedInstance;
//显示登录页面
+ (void) showLoginView;

// 处理登录过期和未登录
+ (void) doWithError:(GTNetError *_Nonnull) err;

// 兼容oc reqModel GTRes
-(void) loginWithReqModel:(id _Nullable )reqModel
                     succ:(void(^_Nullable)(GTResModelUserInfo * _Nullable resModel))succBlock
                     fail:(void(^_Nullable)(GTNetError * _Nullable error))errorBlcok;

// 注册
- (void) registerWithParams:(id _Nonnull )reqModel
                       succ:(void(^_Nullable)(GTResModelUserInfo * _Nullable resModel))succBlock
                       fail:(void(^_Nullable)(GTNetError * _Nullable error))errorBlcok;
// 刷新个人信息
-(void) refreshWith:(void(^_Nullable)(GTResModelUserInfo * _Nullable resModel))succBlock
               fail:(void(^_Nullable)(GTNetError * _Nullable error))errorBlcok;

// 读取登录缓存
+ (void)resultDBUserInfo:(void(^ _Nonnull)(RLMResults * _Nullable result))block;

// 更新用户头像
- (void)uploadUserAvatarWithImage:(UIImage *_Nonnull )image
                      andProgress:(void (^_Nullable)(float progress))progressBlock
                             succ:(void(^_Nullable)(id _Nullable resModel, NSString * _Nullable imageUrl))succBlock
                             fail:(void(^_Nullable)(GTNetError *_Nullable error))errorBlcok;

@end
