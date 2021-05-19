//
//  AppDelegate.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/23.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarViewController.h"
#import "GTApi.h"
#import "GTRootUINavigationController.h"
#import "GTDBUserModel.h"
#import "GTCommonService.h"
#import "GTQiYuCustomerService.h"
#import "GTAuthenticateService.h"

@interface AppDelegate ()
@property (nonatomic, copy) GTClient * manger;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];

    _window.rootViewController = [GTRootTabbarVC shareInstance];//[BaseTabBarViewController shareInstance];
    _manger = [GTClient manger];
    
    
    [GTRouterMapping.manger mirrorTest];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // 未完成订单 取消
    [GTAuthenticateService.sharedInstance cancalBizWithAppTerminate];
}

#pragma mark - App跳转
// iOS 10 以后
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            GTLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}
//  跳转其他app
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            GTLog(@"result = %@",resultDic);
           
        }];
    }
    return YES;
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    // 获取通知
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    GTLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);

    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    // 向七鱼服务器注册deviceToken
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    GTLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {

    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    GTLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}







//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    if (GTAuthenticateService.sharedInstance.bizNo) {
//        dict[@"bizNo"] = GTAuthenticateService.sharedInstance.bizNo;
//        if (GTAuthenticateService.sharedInstance.taskId) {
//            //运营商认证成功，update
//            dict[@"taskId"] = GTAuthenticateService.sharedInstance.taskId;
//            dict[@"operate"] = @"update";
//        } else {
//            //取消认证操作，取消订单
//            //其他，drop
//            dict[@"operate"] = @"drop";
//        }
//    }
//    [GTAuthenticateService.sharedInstance cancelAuthOrderWithDict:dict succ:nil fail:nil];

//#pragma mark - iOS 10中收到推送消息

//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
////  iOS 10: App在前台获取到通知
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//
//    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
//
//    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
//}
//
////  iOS 10: 点击通知进入App时触发
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//
//    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
//
//    // [ GTSdk ]：将收到的APNs信息传给个推统计
//    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
//
//    completionHandler();
//}
//#endif


// ----------
// test pay
//- (void) testPay {
//
//    NSDictionary *dict = @{
//
//                           @"interId":@"tob.quickPayMent",
//                           @"ver":@1000,
//                           @"companyId":@11,
//
//
//                           @"order_no":@"20170630175415257140162791012521",
//                           @"type":@"2",
//                           @"payType":@"2",
//                           @"idNo":@"420621199205207755",
//                           @"pay_money":@"3000",
//                           @"latefee":@"100",
//                           };
//
//    [[GTApi requestParams:dict andResmodel:[GTResModelUserInfo class] andAuthStatus:nil]
//     subscribeNext:^(GTResModelUserInfo*  _Nullable model) {
//
//
//         GTLog(@"请求内容:\n%@",[model yy_modelToJSONObject]);
//     } error:^(NSError * _Nullable error) {
//
//         GTNetError *err = (GTNetError *) error;
//         GTLog(@"#####%@", err);
//     }];
//}
// 测试连连支付
//-(void) testLianlianPay {
//     _window.rootViewController = [[TViewController alloc] init];
//}
// sdk 测试 云慧眼
//-(void) testYunFeiYan {
//
//    _window.rootViewController = [[TViewController alloc] init];
//}
//
// sdk 测试 授权采集
//- (void)testAuth {
//
//    _window.rootViewController = [[TAuthViewController alloc] init];
//}
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"color = %@ AND name BEGINSWITH %@", @"白色", @"大"];
//    RLMResults *dogs = [Dog objectsWithPredicate:pred];

//    [GTLoginService resultDBUserInfo:^(RLMResults * _Nullable result) {
//
//        GTLog(@"%@",result)
//    }];
//    GTDBUserModel *model = [[GTDBUserModel alloc] init];
//    model.custId = @"5";
//    NSDictionary *dict = [model yy_modelToJSONObject];

//    [GTDB execWithAction:^(RLMRealm * _Nonnull realm) {
//
//        [realm addObject:model];
//
//    }];
//    [GTDB
//    [GTDB execWithAction:^(RLMRealm * _Nonnull realm) {
//
////        [realm object]
//        RLMResults<GTDBUserModel *> *modelss = [GTDBUserModel allObjects];
////        modelss.
//        GTLog(@"%@",modelss)
//
//    }];

//


//    [self registerRemoteNotification];
//    [_manger registerRemoteNotification];

//    [[GTUser manger] reloadUserInfoWithSucc:nil fail:nil];
//    [[UINavigationBar appearance] setTranslucent:NO];
//    [[UINavigationBar appearance]setBarTintColor:NavigationBgColor];
//    [[GTClient manger] config];
//    [self testNet];
//    [self testYunFeiYan];
//    [self testAuth];
//    [self testLianlianPay];
//    [self testPay];

//#pragma mark - 用户通知(推送) _自定义方法
//
///** 注册远程通知 */
//- (void)registerRemoteNotification {
//
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = _manger;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
//            if (!error) {
//                NSLog(@"request authorization succeeded!");
//            }
//        }];
//
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//
//    } else  {
//
//        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//}

// ex 网络测试
//- (void) testNet {


    //模拟登录测试
    //test
    //    MobileLoginViewController *vc = [[MobileLoginViewController alloc] init];
    //    _window.rootViewController = vc;

    //    RACSignal *signal = [GTApi noLoginRequest:@"" andParams:[NSDictionary dictionary]];
    //    [signal subscribeNext:^(id  _Nullable x) {
    //
    //    }];
    //

    //    RACSignal *s1 =  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //
    //
    //        [NSTimer timerWithTimeInterval:4 repeats:true block:^(NSTimer * _Nonnull timer) {
    //            [subscriber sendNext:@1];
    //        }];
    //        return [RACDisposable disposableWithBlock:^{
    //
    //        }];
    //    }];
    //
    //    [[s1 then:^RACSignal * _Nonnull{
    //
    //                RACSubject *subject = [RACSubject subject];
    //                [subject sendNext:@2];
    //                return subject;
    //    }]subscribeNext:^(id  _Nullable x) {
    //
    //        NSLog(@"%@",x);
    //    }];

    //    [GTNet loginWithUserName:<#(NSString * _Nonnull)#> pwd:<#(NSString * _Nonnull)#>]
    //      then:^RACSignal * _Nonnull {
    //
    //        RACSubject *subject = [RACSubject subject];
    //        [subject sendNext:@2];
    //        return subject;
    //    }] subscribeNext:^(id  _Nullable x) {
    //
    //        NSLog(@"%@",x);
    //    }];
    //




    // 方式一
    // 传入 参数
    //    NSDictionary *dict = @{
    //
    //                           @"interId":@"toa.submitFourFactor",
    //                           @"ver":@1000,
    //                           @"companyId":@1,
    //                           @"type":@1,
    //                           @"phoneNo":@"13083663880",
    //
    //                           @"carName":@"仁进刚",
    //                           @"carNo":@"6214835714400841",
    //                           @"idNo":@"420621199205207755",
    //                           @"mobile":@"15257140162",
    //                           @"customerid":@"12345",
    //                           @"idName":@"仁进刚",
    //                           };


    // 方式二
    //    GTReqModelLogin *model = [[GTReqModelLogin alloc] init]; // 请求model 暂定为 GTReqModelLogin 需要参数 自定义 添加
    //    model.interId = GTApiCode.getVerificationCode;  // 接口编号 在GTApiCode 中定义,要自己定义
    //    model.ver = @1000;                              // 版本号，接口暂定1000
    //    model.companyId = @1;
    //    model.type = @1;
    //    model.phoneNo = @"1301111111";
    //
    //    NSDictionary *dict = [model yy_modelToJSONObject]; // 转为字典

    /**

     // 模型信息 可以在GTResModelUserInfo 中添加
     // andAuthStatus 接口是否需要登录
     @param model [model class]
     @param andAuthStatus GTNetAuthStatusTypeLogined
     @return rac
     */




    // 文件上传
    //
    //        UIImage *img = [UIImage imageNamed:@"bj_bankcard"];
    //        NSData *data = UIImagePNGRepresentation(img);
    //
    //        NSDictionary *dict2 = @{
    //
    //                               @"interId":@"toa.updateCustHeadimg",
    //                               @"ver":@1000,
    //                               @"companyId":@1
    //                               };

    //    [[[GTApi upLoadData:data andFileName:@"demo/xo.jpg" andProgress:^(float progress) {
    //
    //        // 更新进度
    //        GTLog(@"%f",progress);
    //    } andAuthStatus:nil] then:^RACSignal * _Nonnull{
    //
    //
    //        return [GTApi requestModel:[GTResModelCommon class] andParams:dict2 andAuthStatus:nil];
    //    }] subscribeNext:^(GTResModelCommon   * _Nullable model) {
    //
    //        GTLog(@"%@",[model yy_modelToJSONObject]);
    //
    //    } error:^(NSError * _Nullable error) {
    //
    //        GTLog(@"%@",error);
    //    }];

    //    [[[[GTApi upLoadData:nil andFileName:nil andProgress:nil andAuthStatus:nil] doNext:^(id  _Nullable x) {
    //
    //    }] then:^RACSignal * _Nonnull{
    //
    //    }] doNext:^(id  _Nullable x) {
    //
    //    }];


    //    [[[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //        NSLog(@"第一步");
    //        [NSTimer scheduledTimerWithTimeInterval:1 repeats:false block:^(NSTimer * _Nonnull timer) {
    //             [subscriber sendNext:@"11"];
    //            [subscriber sendCompleted];
    //        }];
    //
    //        return nil;
    //    }] doNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x)
    //    }] then:^RACSignal *{
    //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //            NSLog(@"第二步");
    //            [NSTimer scheduledTimerWithTimeInterval:1 repeats:false block:^(NSTimer * _Nonnull timer) {
    //                [subscriber sendNext:@"22"];
    //                [subscriber sendCompleted];
    //            }];
    //
    //            return nil;
    //        }];
    //    }] doNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x)
    //    }] then:^RACSignal *{
    //        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    //            NSLog(@"第三步");
    //            [NSTimer scheduledTimerWithTimeInterval:1 repeats:false block:^(NSTimer * _Nonnull timer) {
    //                [subscriber sendNext:@"33"];
    //                [subscriber sendCompleted];
    //            }];
    //            return nil;
    //        }];
    //    }] subscribeNext:^(id  _Nullable x) {
    //
    //        NSLog(@"%@",x)
    //    }];

    //     subscribeCompleted:^{
    //        NSLog(@"完成");
    //    }];

    // 下载文件
    // 第一步 上传到 oss
    // 第二部 同步 url 到本地服务器

    //    __block NSMutableDictionary *mutdict = [dict2 mutableCopy];
    //    [[[[GTApi upLoadData:data andFileName:@"xx/xx.jpg" andProgress:^(float progress) {
    //
    //        GTLog(@"上传进度：%f",progress);
    //    } andAuthStatus:nil] doNext:^(NSString  *_Nullable urlPath) {
    //
    //        GTLog(@"oss地址：%@",urlPath);
    //        mutdict[@"headimgUrl"] = urlPath;
    //    }] then:^RACSignal * _Nonnull{
    //
    //        NSDictionary *dict = [mutdict copy];
    //        return [GTApi requestParams:dict andResmodel:[GTResModelCommon class] andAuthStatus:nil];
    //    }] subscribeNext:^(GTResModelCommon  *_Nullable x) {
    //
    //        GTLog(@"%@",[x yy_modelToJSONObject])
    //    } error:^(NSError * _Nullable error) {
    //
    //        GTLog(@"%@",error);
    //    }];

//}

@end
