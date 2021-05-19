//
//  GTAuthenticateService.h
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTAuthenticateService : NSObject

//用户认证订单的流水号
@property (nonatomic, copy) NSString *bizNo;
//用户运营商认证产生的任务号
@property (nonatomic, copy) NSString *taskId;

+ (GTAuthenticateService *)sharedInstance;

// 提交用户认证信息
- (void)submitAuthInfoWithDict:(NSDictionary *)dict
                          succ:(void(^)(id resDict))succBlock
                          fail:(void(^)(GTNetError *error))errorBlock;

/*
 废弃
// 获取用户认证信息
- (void)fetchAuthInfoWithDict:(NSDictionary *)dict
                         succ:(void(^)(id resModel))succBlock
                         fail:(void(^)(GTNetError *error))errorBlock;
*/

// 创建认证订单流水
- (void)createAuthOrderWithDict:(NSDictionary *)dict
                           succ:(void(^)(id resModel))succBlock
                           fail:(void(^)(GTNetError *error))errorBlock;

// 取消认证订单流水
- (void)cancelAuthOrderWithDict:(NSDictionary *)dict
                           succ:(void(^)(id resModel))succBlock
                           fail:(void(^)(GTNetError *error))errorBlock;

- (void)uploadIdCardImageWithName:(NSString *)imageName
                            image:(UIImage *)image
                      andProgress:(void (^)(float progress))progressBlock
                             succ:(void(^)(NSString *imageUrl))succBlock
                             fail:(void(^)(GTNetError *error))errorBlock;

// 获取用户认证信息详情
- (void)fetchAuthDetailWithDict:(NSDictionary *)dict
                            res:(id)resModel
                           succ:(void(^)(id resModel))succBlock
                           fail:(void(^)(GTNetError *error))errorBlock;


// app 退出 取消订单
- (void)cancalBizWithAppTerminate;

//地理位置解析
- (void)reverseGeocodeLocation:(CLLocation *)location
                          succ:(void(^)(NSDictionary *locasDict))succBlock
                          fail:(void(^)(NSError *error))errorBlock;

@end
