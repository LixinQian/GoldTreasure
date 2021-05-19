//
//  GTVerification.h
//  GoldTreasure
//
//  Created by ZZN on 2017/7/8.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//验证
@interface GTVerification : NSObject

/**
 判断手机号 是否合法

 @param telNumber 手机号
 @return bool
 */
+ (BOOL)checkTelNumber:(NSString *) telNumber;

/**
 判断手机号 是否合法
 
 @param pwd 密码
 @return bool
 */
+ (BOOL)checkPwdNumber:(NSString *) pwd;

/**
 判断银行卡号 是否合法
 
 @param bankCardNumber 银行卡号
 @return bool
 */
+ (BOOL)checkBankCardNumber:(NSString *) bankCardNumber;

//判断是否为15 or 18 位的身份证号
+ (BOOL)checkIdCardNumber:(NSString *) idCardNumber;

//判断为6-20位非空格字符（支付宝密码）
+ (BOOL)checkAlipayPassword:(NSString *) password;

/**
 判断是否为 0-9 数字
 
 @param number 数字
 @return bool
 */
+ (BOOL) checkAllNum:(NSString *)number;

/**
 检测字符串长度
 
 @param number 字符串
 @return bool
 */
+(BOOL) checkNumLength:(NSString*)number length:(NSUInteger)length;


+(BOOL) checkMaxNumLength:(NSString*)number length:(NSUInteger)length;

// 邮箱检测
+(BOOL)isValidateEmail:(NSString *)email;

// 微信号检测
+(BOOL) isValidateWechat:(NSString *)wechat;
// 是否包含enmoj表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

// 是否为中文
+ (BOOL)userInputShouldChinese:(NSString *)string;
// 是否包含中文
+(BOOL) isValidateChinese:(NSString *)chinese;
// 是否包含数字
+ (BOOL) isContainNum:(NSString *)string;

+ (BOOL)isChinese:(NSString *)str;

// 目录解析
+ (NSRange) parseRouterPattern:(NSString *)partern with:(NSString *)url;

//+ (BOOL)checkUserIdCard: (NSString *) cardNo;
//+ (BOOL) isOperId:(NSString *)string;
//+ (BOOL) isOperGroupId:(NSString *)string;
//+ (BOOL) checkCompanyChatId:(NSString *)string;

@end
