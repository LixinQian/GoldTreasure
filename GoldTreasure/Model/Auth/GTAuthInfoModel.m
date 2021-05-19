//
//  GTAuthInfoModel.m
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAuthInfoModel.h"

@implementation GTAuthInfoModel

//- (void)setCertificationStatus:(NSString *)certificationStatus
//{
//    if (certificationStatus) {
//        _certificationStatus = certificationStatus;
//        NSArray<NSString *> *authStatusArray = [self.certificationStatus componentsSeparatedByString:@"."];
//        _realAuth = [authStatusArray[0] integerValue];
//        _bankAuth = [authStatusArray[1] integerValue];
//        _carrierAuth = [authStatusArray[2] integerValue];
//        _alipayAuth = [authStatusArray[3] integerValue];
//    }
//}

- (NSUInteger)authSuccessCount
{
    NSUInteger authCount = 0;
    if (self.certStatus == GTAuthStatusSucceed) {
        authCount ++;
    }
    if (self.cardStatus == GTAuthStatusSucceed) {
        authCount ++;
    }
    if (self.carrierStatus == GTAuthStatusSucceed) {
        authCount ++;
    }
    if (self.zfbStatus == GTAuthStatusSucceed) {
        authCount ++;
    }
    return authCount;
}

@end
