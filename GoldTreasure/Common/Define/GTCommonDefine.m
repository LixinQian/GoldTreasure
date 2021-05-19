//
//  GTStrDefine.m
//  GoldTreasure
//
//  Created by ZZN on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTCommonDefine.h"

@implementation GTCommonDefine

#pragma 网络地址配置项 兼容Swift

/** 服务器地址 开发 正式 */
NSString * const APIURLDEV          = @"http://118.31.78.207:8080";//@"http://101.37.163.179:8082";
NSString * const APIURLFormal       = @"http://118.31.78.207:8080";//@"https://api.huajinbao.zhaofangroup.com";


//NSString * const APPOPAPICOMPENTSTR = __DEV == true ? @"http://116.62.43.160:8081" : @"https://agent.huajinbao.zhaofangroup.com";
NSString * const APPOPAPICOMPENTSTR = __DEV == true ? @"http://116.62.43.160:8081" : @"https://hualebao-api.milicaixian.cn";
//NSString * const APPAPICOMPENTSTR   = @"huajinbao/appservice";

NSString * const APPAPICOMPENTSTR   = @"hjb/appservice";

#pragma 配置项 兼容Swift
/** 又拍云 Bulket */
NSString * const UPYUNBUCKETNAME    = @"huajinbao";
// 又拍云 操作员
NSString * const UPYUNOPERATOR      = @"lushuangteng";
// 又拍云 操作员 pwd
NSString * const UPYUNPASSWORD      = @"Shenlu850323";
// 默认 dbName
NSString * const REALMDBNAME        = @"realm.db";

// 个推 APPID
NSString * const GETUIAPPID     = __DEV == true ? @"rOxZRmogHb73uxGJzaBiyA" : @"oku5uFfNlw6A0VUrzccZL6";
// 个推 AppSecret
NSString * const GETUIAPPSECRET = __DEV == true ? @"h9gCnKfDlFAxQvo5y0Hph4" : @"Bh9uPgF6of8shK3r11T2g2";
// 个推 AppKey
NSString * const GETUIAPPKEY    = __DEV == true ? @"h9gCnKfDlFAxQvo5y0Hph4" : @"Vw1412wrxVAIsDiBq3nSa4";


// 支付宝加密 key
NSString * const GTALIAES128KEY         = @"adf#%!afd*&^a%^&";
// 默认 token
NSString * const APPDEFAULTUSERTOKEN    = @"tyuiggl55663ddsd";
// 默认 接口加密 key
NSString * const APPCURRENTUSERKEY      = @"adkj58ghf7545ytjk";

#warning 旧的
// 有盾APIKey
//NSString * const IDCARDAUTHKEY      = __DEV == true ? @"b58b428f-5fb9-448b-a461-800e01f25640":@"25ae8dc6-e7ca-42cc-9e3c-d830078245fd";

// 有盾APIKey
NSString * const IDCARDAUTHKEY      = __DEV == true ? @"b58b428f-5fb9-448b-a461-800e01f25640":@"080ace92-c76a-4a31-9cde-09ab6a1bf85c";


//NSString * const IDCARDAUTHKEY = @"251c21a0-7ab6-4654-9606-0bd70f65f3cb"; //自己临时server的app key
// 网易七鱼
//NSString * const QYAPPKEY           = __DEV == true ? @"c05c6038b22634ba85663093642cca52" : @"c05c6038b22634ba85663093642cca52";
NSString * const QYAPPKEY           = __DEV == true ? @"c05c6038b22634ba85663093642cca52" : @"46068c59e84a73309787073152cce7d5";


//NSString * const QYAPPNAME          = __DEV == true ? @"iOS花乐宝测试":@"iOS花乐宝生产";
NSString * const QYAPPNAME          = __DEV == true ? @"iOS花乐宝测试":@"花乐宝";



NSInteger const APIVER              = 1000;

//NSInteger const APICOMPANYID        = 1;  原来的
NSInteger const APICOMPANYID        = 5;

#pragma 缓存key 兼容Swift
//缓存app版本连接 类型
NSString * const APPNETTYPEKEY      = @"APPNETTYPEKEY";
//缓存app版本key
NSString * const APPVERSIONKEY      = @"APPVERSIONKEY";
//缓存app版本是否第一次启动
NSString * const APPFRISTLAUNCHKEY  = @"APPFRISTLAUNCHKEY";
//缓存app是否登陆
NSString * const USERISLOGIN        = @"USERISLOGIN";
//缓存app 用户 ID
NSString * const APPALLUSERID       = @"APPALLUSERID";
//设置当前 app 用户 ID
NSString * const APPCURRENTUSERID   = @"APPCURRENTUSERID";
//设置当前 app 用户 clientid
NSString * const APPCLIENTID        = @"APPCLIENTID";
//设置当前 app 用户 PHONE NO
NSString * const APPCURRENTPHONENO  = @"APPCURRENTPHONENO";
// 引导页结束通知
NSString * const NOTIGUIDERIMGVIEWEND   = @"NOTIGUIDERIMGVIEWEND";
//是否需要显示引导图
NSString * const APPISSHOWGUIDEPIC      = @"APPISSHOWGUIDEPIC";
// 个推通知key
NSString * const NOTIGETUINEWNOTIKEY    = @"NOTIGETUINEWNOTIKEY";
// 登录成功通知
NSString * const NOTIUSERLOGINSUCC      = @"USERLOGINSUCCNOTI";
// 登录失败通知
NSString * const NOTIUSERLOGINFAIL      = @"USERLOGINFAILNOTI";

//uuid
+(NSString *)APPUNIQUEID {
    
    return [[NSUUID alloc] UUIDString];
}
// realm url
+ (NSString *)DBFILEPATH {
    
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath objectAtIndex:0];
    
    NSString *filePath = [path stringByAppendingPathComponent:REALMDBNAME];
    return filePath;
}


@end
