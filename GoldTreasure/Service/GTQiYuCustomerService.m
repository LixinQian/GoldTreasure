//
//  GTQiYuCustomerService.m
//  GoldTreasure
//
//  Created by wangyaxu on 13/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTQiYuCustomerService.h"

@implementation GTQiYuCustomerService

+ (void)initializeQIYUConfiguration
{
    [[QYSDK sharedSDK] registerAppId:QYAPPKEY appName:QYAPPKEY];
}

+ (void)logoutQIYUService:(void(^)())completion
{
    [[QYSDK sharedSDK] logout:^{
        if (completion) {
            completion();
        }
    }];
}

+ (QYSessionViewController *)defaultSessionControllerWithSessionType:(QYSessionType)sessionType
{
    [self setCustomerUI];
    [self setCustomerInfo];
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    [self configSessionWithController:sessionViewController type:sessionType];
    return sessionViewController;
}

+ (void)setCustomerInfo
{
    //访客头像
    [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageNamed:@"default_avatar"];
    //客服头像
    [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageNamed:@"head_default"];
    //    [[QYSDK sharedSDK] customUIConfig].serviceHeadImageUrl = @"http_url";

    //提交用户的个人信息
    GTResModelUserInfo *user = GTUser.manger.userInfoModel;
    if (!user) {
        return;
    }
    
    if (user.custName) {
        QYUserInfo *userInfo = [[QYUserInfo alloc] init];
        userInfo.userId = user.custId.stringValue;
        NSMutableArray *array = [NSMutableArray new];
        NSMutableDictionary *dictRealName = [NSMutableDictionary new];
        [dictRealName setObject:@"real_name" forKey:@"key"];
        [dictRealName setObject:user.custName forKey:@"value"];
        [array addObject:dictRealName];
        NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                       options:0
                                                         error:nil];
        if (data)
        {
            userInfo.data = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
        }
        [[QYSDK sharedSDK] setUserInfo:userInfo];
    }
    [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = user.headimgUrl;
}

+ (void)setCustomerUI
{
    
}

+ (void)configSessionWithController:(QYSessionViewController *)sessionViewController type:(QYSessionType)type
{
    //此处可以区分意见反馈 or 在线客服
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"花乐宝";
//    source.urlString = @"https://www.baidu.com/";   //项目网址
    sessionViewController.source = source;
    switch (type) {
        case QYSessionTypeService:
        {
            sessionViewController.sessionTitle = @"在线客服";
            
//            sessionViewController.groupId = 511250;
//            sessionViewController.staffId = 167248;
        }
            break;
        case QYSessionTypeFeedBack:
        {
            sessionViewController.sessionTitle = @"意见反馈";
            
//            sessionViewController.groupId = 511250;
//            sessionViewController.staffId = 167248;
        }
            break;
            
        default:
            break;
    }
}

@end
