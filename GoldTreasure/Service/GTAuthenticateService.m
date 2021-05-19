//
//  GTAuthenticateService.m
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAuthenticateService.h"
#import "GTAuthInfoModel.h"

@implementation GTAuthenticateService

// 实例化
+ (GTAuthenticateService *)sharedInstance {
    
    static GTAuthenticateService *instance = nil;
    static dispatch_once_t authOnceToken;
    dispatch_once(&authOnceToken, ^{
        
        // 初始化单例类对象
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

-(void)submitAuthInfoWithDict:(NSDictionary *)dict
                         succ:(void(^)(id resDict))succBlock
                         fail:(void(^)(GTNetError *error))errorBlock
{
    [GTHUD showStatusWithTitle:nil];
    [[GTApi requestParams:dict andAuthStatus:nil] subscribeNext:^(id  _Nullable x) {
        [GTHUD dismiss];
        if ([x isKindOfClass:[NSDictionary class]]) {
            if (succBlock) {
                succBlock(x);
            }
        } else {
            GTNetError *err = [[GTNetError alloc] initErrCode:0 msg:@"异常错误！"];
            if (errorBlock != nil) {
                errorBlock(err);
            }
        }
    } error:^(NSError * _Nullable error) {
        [GTHUD dismiss];
        GTNetError *err = (GTNetError *) error;
        if (errorBlock != nil) {
            errorBlock(err);
        }
    }];
}

-(void)fetchAuthInfoWithDict:(NSDictionary *)dict
                        succ:(void (^)(id))succBlock
                        fail:(void (^)(GTNetError *))errorBlock
{
    [[GTApi requestParams:dict andResmodel:[GTAuthInfoModel new] andAuthStatus:nil]
     subscribeNext:^(id _Nullable model) {
         
         if (succBlock != nil) {
             succBlock(model);
         }
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         if (errorBlock != nil) {
             errorBlock(err);
         }
         GTLog(@"#####%@", err);
     }];
}

- (void)createAuthOrderWithDict:(NSDictionary *)dict
                           succ:(void(^)(id resModel))succBlock
                           fail:(void(^)(GTNetError *error))errorBlock
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    paramsDict[@"interId"] = GTApiCode.createAuthOrder;
    paramsDict[@"orgCode"] = @"YOUDUN";
    
    [[GTApi requestParams:paramsDict andResmodel:[GTResModelAuth new] andAuthStatus:nil]
     subscribeNext:^(id _Nullable model) {
         
         if (succBlock != nil) {
             succBlock(model);
         }
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         if (errorBlock != nil) {
             errorBlock(err);
         }
         GTLog(@"#####%@", err);
     }];
}

- (void)cancelAuthOrderWithDict:(NSDictionary *)dict
                           succ:(void(^)(id resModel))succBlock
                           fail:(void(^)(GTNetError *error))errorBlock
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    paramsDict[@"interId"] = GTApiCode.processBizFlow;
    
    [[GTApi requestParams:paramsDict andResmodel:[GTAuthInfoModel new] andAuthStatus:nil]
     subscribeNext:^(id _Nullable model) {
         
         if (succBlock != nil) {
             succBlock(model);
         }
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         if (errorBlock != nil) {
             errorBlock(err);
         }
         GTLog(@"#####%@", err);
     }];
}

- (void)fetchAuthDetailWithDict:(NSDictionary *)dict
                            res:(id)resModel
                           succ:(void(^)(id resModel))succBlock
                           fail:(void(^)(GTNetError *error))errorBlock
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    paramsDict[@"interId"] = GTApiCode.getAuthDetail;

    [[GTApi requestParams:paramsDict andResmodel:resModel andAuthStatus:nil]
     subscribeNext:^(id _Nullable model) {
         
         if (succBlock != nil) {
             succBlock(model);
         }
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         if (errorBlock != nil) {
             errorBlock(err);
         }
         GTLog(@"#####%@", err);
     }];
}

- (void)uploadIdCardImageWithName:(NSString *)imageName
                            image:(UIImage *)image
                      andProgress:(void (^)(float progress))progressBlock
                             succ:(void(^)(NSString *imageUrl))succBlock
                             fail:(void(^)(GTNetError *error))errorBlock
{
    //compress image
    NSInteger dataLimit = 300; //身份证照片400k以下
    NSData *data = [image resetSizeOfImageData:image maxSize:dataLimit resolution:CGPointMake(image.size.width / 4, image.size.height / 4)];
    
    [[GTApi upLoadData:data andFileName:imageName andProgress:^(float progress) {
        
        if (progressBlock) {
            progressBlock(progress);
        }
    } andAuthStatus:GTNetAuthStatusTypeNoLogin] subscribeNext:^(NSString * _Nullable urlPath) {
        
        GTLog(@"oss地址：%@",urlPath);
        if (succBlock) {
            succBlock(urlPath);
        }
    } error:^(NSError * _Nullable error) {
        
        if (errorBlock) {
            errorBlock((GTNetError *)error);
        }
    }];    
}


-(void)cancalBizWithAppTerminate {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (GTAuthenticateService.sharedInstance.bizNo) {
        dict[@"bizNo"] = GTAuthenticateService.sharedInstance.bizNo;
        if (GTAuthenticateService.sharedInstance.taskId) {
            //运营商认证成功，update
            dict[@"taskId"] = GTAuthenticateService.sharedInstance.taskId;
            dict[@"operate"] = @"update";
        } else {
            //取消认证操作，取消订单
            //其他，drop
            dict[@"operate"] = @"drop";
        }
    }
    [GTAuthenticateService.sharedInstance cancelAuthOrderWithDict:dict succ:nil fail:nil];
}

- (void)reverseGeocodeLocation:(CLLocation *)location
                          succ:(void(^)(NSDictionary *locasDict))succBlock
                          fail:(void(^)(NSError *error))errorBlock
{
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            if (errorBlock) {
                errorBlock(error);
            }
            return ;
        }
        
        if (placemarks.count > 0) {
            
            CLPlacemark *mark = placemarks[0];
            NSString *administrativeArea = mark.administrativeArea; //省
            NSString *city = mark.locality; //市
            NSString *subLocality = mark.subLocality;   //区
            NSString *targetAddr = administrativeArea;
            if (city) {
                //若存在市，则加上市
                targetAddr = [administrativeArea stringByAppendingString:city];
            } else {
                //为直辖市，加上区
                targetAddr = [administrativeArea stringByAppendingString:subLocality];
            }
            
            NSArray *lines = mark.addressDictionary[@"FormattedAddressLines"];
            NSString *addressString = [lines componentsJoinedByString:@"\n"];
            
            NSDictionary *resultDic = @{
                                        @"city" : targetAddr,
                                        @"address" : addressString
                                        };
            if (succBlock) {
                succBlock(resultDic);
            }
        }
    }];
}

@end
