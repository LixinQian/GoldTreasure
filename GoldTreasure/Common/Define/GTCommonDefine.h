//
//  GTStrDefine.h
//  GoldTreasure
//
//  Created by ZZN on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GTCommonDefine : NSObject

/** 服务器地址 开发 正式 测试 */
extern NSString * const APIURLDEV;
extern NSString * const APIURLFormal;
extern NSString * const APPAPICOMPENTSTR;
extern NSString * const APPOPAPICOMPENTSTR;

// 缓存app版本连接 类型
extern NSString * const APPNETTYPEKEY;
// 个腿 APPID
extern NSString * const GETUIAPPID;
// 个腿 AppSecret
extern NSString * const GETUIAPPSECRET;
// 个腿 AppKey
extern NSString * const GETUIAPPKEY;

/** 又拍云 Bulket */
extern NSString * const UPYUNBUCKETNAME;
/** 又拍云 操作员 */
extern NSString * const UPYUNOPERATOR;
// 又拍云 操作员 pwd
extern NSString * const UPYUNPASSWORD;


// 有盾APIKey
extern NSString * const IDCARDAUTHKEY;

// 网易七鱼
extern NSString * const QYAPPKEY;
extern NSString * const QYAPPNAME;


// 缓存当前 app 用户 token
extern NSString * const APPDEFAULTUSERTOKEN;
// 接口 key约定
extern NSString * const APPCURRENTUSERKEY;

// App 接口相关
extern NSInteger const APIVER;
extern NSInteger const APICOMPANYID;

//缓存app版本key
extern NSString * const APPVERSIONKEY;
//缓存app版本是否第一次启动
extern NSString * const APPFRISTLAUNCHKEY;
//是否需要显示引导图
extern NSString * const APPISSHOWGUIDEPIC;
//缓存app是否登陆
extern NSString * const USERISLOGIN;
//缓存app 用户 ID
extern NSString * const APPALLUSERID;

//缓存app 用户 手机号
extern NSString * const APPCURRENTPHONENO ;
//缓存当前 app 用户 手机号
extern NSString * const APPCURRENTUSERP ;
//缓存当前 app 用户 ID
extern NSString * const APPCURRENTUSERID ;
//缓存当前 app 用户 clientid 个推
extern NSString * const APPCLIENTID ;
// 默认 dbName
extern NSString * const REALMDBNAME;
// AES 加密key
extern NSString * const GTALIAES128KEY;
// 个推通知
extern NSString * const NOTIGETUINEWNOTIKEY;
// 引导页结束通知
extern NSString * const NOTIGUIDERIMGVIEWEND;
// 登录成功通知
extern NSString * const NOTIUSERLOGINSUCC;
// 登录失败通知
extern NSString * const NOTIUSERLOGINFAIL;



//uuid
//extern NSString * const APPUNIQUEID ; // NSUUID().uuidString

+ (NSString *)APPUNIQUEID;

/**
 默认realm地址

 @return path
 */
+ (NSString *)DBFILEPATH;

@end
