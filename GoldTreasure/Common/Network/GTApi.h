//
//  GTApi.h
//  GoldTreasure
//
//  Created by ZZN on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

typedef void(^success)();
typedef void(^fail)();


// 用户连接连接 类型 需要登录，不需要登录
typedef NS_ENUM(NSUInteger, GTNetAuthStatusType) {
    GTNetAuthStatusTypeLogined = 0,
    GTNetAuthStatusTypeNoLogin = 10,
};

// 上传文件 类型
typedef NS_ENUM(NSUInteger, GTNetMimeType) {
    GTNetMimeTypeJepg = 0,
    GTNetMimeTypePng = 10,
    GTNetMimeTypeMp4 = 110,
};

@interface GTApi<T> : NSObject


/**
 需要登录请求接口 如请求个人信息接口
 
 @param model 模型类 class 类型 ex. [ExMoel class]
 @param params 入参
 @param type 登录状态 可为空，为空时 默认检测 登录状态，登录为logined 不登录为nologined
 @return rac数据流
 */


+ (RACSignal<T> *_Nonnull)requestParams: (NSDictionary *_Nonnull)params andResmodel: (T _Nonnull)model
                          andAuthStatus:(GTNetAuthStatusType *_Nullable)type;


/**
 上传文件到OSS
 
 @param data 二进制文件
 @param name 文件名 xx/xx.mp4
 @param progressBlock 进度
 @param type 类型
 @return rac
 */

+ (RACSignal *_Nullable)upLoadData:(NSData *_Nonnull)data
andFileName:(NSString *_Nonnull)name
andProgress:(void (^ _Nullable)(float))progressBlock
andAuthStatus:(GTNetAuthStatusType)type;



/**
 请求接口
 
 @param params 入参
 @param type 登录状态
 @return rac
 */
+ (RACSignal *_Nonnull)requestParams: (NSDictionary *_Nonnull)params andAuthStatus:(GTNetAuthStatusType *_Nullable)type;

// 快速生成 signal
+(RACSignal *_Nonnull)getBlockSingal:(void (^_Nonnull)(RACSubject * _Nonnull))progressBlock;
@end
