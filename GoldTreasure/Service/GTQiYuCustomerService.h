//
//  GTQiYuCustomerService.h
//  GoldTreasure
//
//  Created by wangyaxu on 13/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QIYU_iOS_SDK/QYSDK.h"

typedef NS_ENUM(NSUInteger, QYSessionType) {
    QYSessionTypeService,
    QYSessionTypeFeedBack,
};

@interface GTQiYuCustomerService : NSObject

+ (void)initializeQIYUConfiguration;

+ (void)logoutQIYUService:(void(^)())completion;

+ (QYSessionViewController *)defaultSessionControllerWithSessionType:(QYSessionType)sessionType;

//+ (void)setCustomerInfo;
//
//+ (void)configSession;
//
//+ (void)setCustomerUI;

@end
