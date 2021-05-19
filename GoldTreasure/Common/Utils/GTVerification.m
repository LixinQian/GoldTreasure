//
//  GTVerification.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/8.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTVerification.h"

@implementation GTVerification


+ (BOOL)checkTelNumber:(NSString *) telNumber {
    
    NSString *pattern = @"^[1][3,4,5,7,8][0-9]{9}$"; //
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+ (BOOL)checkPwdNumber:(NSString *) pwd {
    
    NSString *pattern = @"^([A-Z]|[a-z]|[0-9]|[~_-]){6,16}$"; //
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:pwd];
    return isMatch;
}

+ (BOOL)checkBankCardNumber:(NSString *) bankCardNumber
{
    //第一位不为0，16-19位数字
    NSString *pattern = @"^[1-9]+\\d{15,18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:bankCardNumber];
    return isMatch;
}

+ (BOOL)checkIdCardNumber:(NSString *) idCardNumber
{
    //15 or 18
    NSString *pattern = @"^([0-9]{15}|[0-9]{17}[0-9Xx])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCardNumber];
    return isMatch;
}

+ (BOOL)checkAlipayPassword:(NSString *) password
{
    NSString *pattern = @"^[^ ]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

+ (BOOL) checkAllNum:(NSString *)number {
    
    NSString *pattern = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

+(BOOL) checkNumLength:(NSString*)number length:(NSUInteger)length {
    
    return number.length == length;
}

+(BOOL) checkMaxNumLength:(NSString*)number length:(NSUInteger)length {
    return number.length <= length;
}


+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL) isValidateWechat:(NSString *)wechat {
    
    NSString *emailRegex = @"^[a-zA-Z]+[a-zA-Z-_0-9]{5,19}+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:wechat];
}


#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) cardNo {
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}



/*
 *利用Emoji表情最终会被编码成Unicode，因此，
 *只要知道Emoji表情的Unicode编码的范围，
 *就可以判断用户是否输入了Emoji表情。
 */
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    
    return returnValue;
}

//match 跳转 目录
+ (NSRange) parseRouterPattern:(NSString *)partern with:(NSString *)url{
    NSString *pattern = partern;
    NSRange range = [url rangeOfString:pattern
                                options:NSRegularExpressionSearch];
    return range;
}


+ (BOOL)userInputShouldChinese:(NSString *)string {
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *name = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![name evaluateWithObject: string])
    {
        
        return YES;
    }
    return NO;
}

+ (BOOL)isChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
    
}

+(BOOL) isValidateChinese:(NSString *)chinese
{
    NSString *emailRegex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:chinese];
}

+ (BOOL) isContainNum:(NSString *)string{
    
    NSInteger alength = [string length];
    
    for (int i = 0; i<alength; i++) {
        unichar commitChar = [string characterAtIndex:i];
        
        if((commitChar>47)&&(commitChar<58)){
            
            return YES;
        }
        
        
        
    }
    return NO;
}

//+ (BOOL) isOperId:(NSString *)string
//{
//    NSString *pattern = @"^[0-9]*$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:string];
//    if (string.length != 13) {
//        isMatch = NO;
//    }
//    
//    return isMatch;
//    
//}
//
//+ (BOOL) isOperGroupId:(NSString *)string
//{
//    if (string.integerValue < 0) {
//        return NO;
//    }
//    
//    NSString *pattern = @"^[0-9]*$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = ![pred evaluateWithObject:string];
//    
//    
//    return isMatch;
//    
//}
//
//
//+ (BOOL) checkCompanyChatId:(NSString *)string{
//    
//    BOOL isMatch = NO;
//    
//    if ([self isOperId:string] || [self isOperGroupId:string]) {
//        
//        isMatch = YES;
//    }
//    
//    
//    return isMatch;
//    
//}


@end
