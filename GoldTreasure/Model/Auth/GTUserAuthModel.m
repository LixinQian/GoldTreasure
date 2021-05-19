//
//  GTUserAuthModel.m
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTUserAuthModel.h"
#import "YYModel.h"

@implementation GTUserAuthModel
//auditStatus(1通过，0审核中，2审核不通过)  子状态

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic
{
    NSString *auditStatus = dic[@"auditStatus"];
    if (auditStatus) {
        switch (auditStatus.integerValue) {
            case 0:
                _authStatus = GTAuthStatusReview;
                break;
            case 1:
                _authStatus = GTAuthStatusSucceed;
                break;
            case 2:
                _authStatus = GTAuthStatusFailed;
                break;
            case 3:
                _authStatus = GTAuthStatusAbsolutelyFailed;
                break;
                
            default:
                _authStatus = GTAuthStatusUnkown;
                break;
        }
    } else {
        //此处若取不到个人认证的状态码，则为审核中状态
        _authStatus = GTAuthStatusReview;
    }
    return dic;
}

@end
