//
//  GTSystemAuth.h
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GTSystemAuthType) {
    // 相机摄像头
    GTSystemAuthTypeCamera,
    // 相册
    GTSystemAuthTypePhotos,
    // 通讯录
    GTSystemAuthTypeContacts,
    // 位置
    GTSystemAuthTypeLocation,
    // 通知
    GTSystemAuthTypeNotificaction
};

typedef NS_ENUM(NSUInteger, GTSystemAuthStatus) {
    // 未授权
    GTSystemAuthStatusNotDetermined = 0 ,
    // 授权成功
    GTSystemAuthStatusAuthorized,
    // 授权失败
    GTSystemAuthStatusDenied,
    // 其他
    GTSystemAuthStatusOther
};


@interface GTSystemAuth : NSObject

+ (instancetype)shareInstance;

/**
 获取指定类型的权限

 @param authType 权限类型
 @param handler 权限结果
 */
+ (void)showAlertWithAuthType:(GTSystemAuthType)authType completionHandler:(void (^)(GTSystemAuthStatus status))handler;

@end
