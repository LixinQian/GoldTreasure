//
//  GTEnumDefine.h
//  GoldTreasure
//
//  Created by ZZN on 2017/7/22.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#ifndef GTEnumDefine_h
#define GTEnumDefine_h

// 网络连接类型
typedef NS_ENUM(NSInteger, GTNetType) {
    GTNetTypeFormal = 0,
    GTNetTypeTest = 10,
    GTNetTypeDev = 100
};
// 网络连接错误类型
typedef NS_ENUM(NSInteger, GTNetErrorType) {
    // 为登录或过期
    GTNetErrorTypeNoLogin = 100,
    // 接口升级
    GTNetErrorTypeApiUpdate = 105,
};
// 通知类型
typedef NS_ENUM(NSInteger, GTNotiType) {
    // 通知公共消息
    GTNotiTypeAll = 1,
    // 针对个人通知
    GTNotiTypePerson = 0,
};
// 客户端更新
typedef NS_ENUM(NSUInteger,GTClientUpdateType) {
    
    GTClientUpdateTypeNeed = 2,
    GTClientUpdateTypeOptional = 1,
    GTClientUpdateTypeNone = 0,
};
// 授权声明
typedef NS_ENUM(NSUInteger, GTAuthStatus) {
    GTAuthStatusLack = 0,//无授权状态
    GTAuthStatusReview,//授权进行中
    GTAuthStatusSucceed,//授权成功
    GTAuthStatusFailed,//授权失败
    GTAuthStatusAbsolutelyFailed,//授权绝对失败（不授信）
    GTAuthStatusUnkown//授权状态未知
};



// 其他
typedef void(^btnClickBlock)();

@protocol AuthStatusRefreshProtocol <NSObject>

@required
- (void)refreshAuthAfterSubmit;

@end

#endif /* GTEnumDefine_h */

