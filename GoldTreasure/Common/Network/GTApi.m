//
//  GTApi.m
//  GoldTreasure
//
//  Created by ZZN on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTApi.h"
#import "GTNetError.h"
#import "GTApi.h"

@interface GTApi<T>() {

}

@end

@implementation GTApi


+(RACSignal *)requestParams:(NSDictionary *)params andAuthStatus:(GTNetAuthStatusType *)type {
    
    RACSignal *singal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        
        __block NSMutableDictionary *mutParams = [params mutableCopy];
        // 判断接口登录
        if (type == GTNetAuthStatusTypeLogined && type != nil) {
            // 需要登录
            if (![GTUser isLogin]) {
                
                [GTLoginService showLoginView];
                GTNetError *error = [[GTNetError alloc] initErrCode:555 msg:@"帐号需要登录"];
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
        }
        // 写入cusid
        if ([GTUser isLogin]) {
            mutParams[@"custId"] = [GTUser getCurrentUserID];
        }
        
        mutParams[@"ver"] = GTApiCommonParam.ver;
        mutParams[@"companyId"] = GTApiCommonParam.companyId;
        
        GTLog(@"-->输入参数：%@",mutParams);
        
        [GTNet postWithUrl:[GTNet getAppServiceUrl] params:mutParams success:^(id _Nonnull dict) {
            
            // 类型解析判断
            if ([dict isKindOfClass:[NSArray class]] == true) {
                
                NSArray *arrList = (NSArray *)dict;
                [subscriber sendNext:arrList];
                [subscriber sendCompleted];
                
            } else {
                
                GTLog(@"请求成功后Dictionary:\n %@",dict);
                [subscriber sendNext:dict];
                [subscriber sendCompleted];
            }
            
        } failure:^(GTNetError * _Nonnull error) {
            
            
            [subscriber sendError:error];
            [subscriber sendCompleted];
            // 统一处理 错误号
            [GTLoginService doWithError:error];
        }];
        
        // 结束流
        return [RACDisposable disposableWithBlock:^{
            GTLog(@"RACDisposed")
        }];
    }];
    return singal;
}






+ (RACSignal<id> *_Nonnull)requestParams:(NSDictionary *_Nonnull)params andResmodel:(id _Nonnull)model
                           andAuthStatus: (GTNetAuthStatusType *)type {
    
    RACSignal *singal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        // 判断接口登录
        __block NSMutableDictionary *mutParams = [params mutableCopy];
        
        if (type == GTNetAuthStatusTypeLogined && type != nil) {
            // 需要登录
            if (![GTUser isLogin]) {
                
                [GTLoginService showLoginView];
                GTNetError *error = [[GTNetError alloc] initErrCode:555 msg:@"帐号需要登录"];
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
        }
        // 写入cusid
        if ([GTUser isLogin]) {
            mutParams[@"custId"] = [GTUser getCurrentUserID];
        }
        
        mutParams[@"ver"] = GTApiCommonParam.ver;
        mutParams[@"companyId"] = GTApiCommonParam.companyId;
        
        GTLog(@"-->输入参数：%@",mutParams);
        
        [GTNet postWithUrl:[GTNet getAppServiceUrl] params:mutParams success:^(id _Nonnull dict) {
            
            // 类型解析判断
            if ([dict isKindOfClass:[NSArray class]] == true) {
                
                NSArray *arrList = (NSArray *)dict;
                NSMutableArray *modelList = [NSMutableArray array];
                [[arrList.rac_sequence.signal map:^id _Nullable(id  _Nullable value) {
                    
                    id jsonModel = [[model class] yy_modelWithDictionary:value];
                    return jsonModel;
                    
                }] subscribeNext:^(id  _Nullable x) {
                    
                    [modelList addObject:x];
                } completed:^{
                    
                    [subscriber sendNext:modelList];
                    [subscriber sendCompleted];
                }];
                
            } else {
                
                GTLog(@"请求成功后Dictionary:\n %@",dict);
                id jsonModel = [[model class] yy_modelWithDictionary:dict];
                [subscriber sendNext:jsonModel];
                [subscriber sendCompleted];
            }
            
        } failure:^(GTNetError * _Nonnull error) {
            
            
            [subscriber sendError:error];
            [subscriber sendCompleted];
            // 统一处理 错误号
            [GTLoginService doWithError:error];
        }];
        
        // 结束流
        return [RACDisposable disposableWithBlock:^{
            GTLog(@"RACDisposed")
        }];
    }];
    return singal;
}

////
//+ (RACSignal *)requestModel:(id)model andParams:(NSDictionary *)params andData:(NSData *)data
//                andProgress:(void (^ _Nullable)(float))progressBlock
//                andMimeType:(GTNetMimeType)mime andAuthStatus:(GTNetAuthStatusType *)type {
//    
//    
//    // 先把 Data -> 云盘
//    NSString *interId = [params objectForKey:@"interId"];
//    NSNumber *companyId = [params objectForKey:@"companyId"];
//    NSString *fileType = [NSString string];
//    NSTimeInterval timeInterval = [[[NSDate alloc] init] timeIntervalSince1970];
//    
//    switch (mime) {
//        case GTNetMimeTypePng:
//            fileType = @".png";
//            break;
//        case GTNetMimeTypeMp4:
//            fileType = @".mp4";
//            break;
//        default:
//            fileType = @".jpg";
//            break;
//    }
//    //
//    RACSubject *subject = [RACSubject subject];
//    NSString *fileName = [NSString stringWithFormat:@"%@/%@/%d%@",interId,companyId,(int)timeInterval,fileType];
//    
//    [GTNet upLoadWithFilaData:data fileName:fileName progress:^(float progress) {
//        
//        // 更新进度
//        if (progressBlock != nil) {
//            progressBlock(progress);
//        }
////        [subject sendNext:@(progress)];
//    } succ:^(NSString * _Nonnull url) {
//        
//        [GTNet postWithUrl:[[GTNet manger] getNetDomain] params:params success:^(id _Nonnull dict) {
//            
//            // 类型解析判断
//            if ([dict isKindOfClass:[NSArray class]] == true) {
//                
//                NSArray *arrList = (NSArray *)dict;
//                NSMutableArray *modelList = [NSMutableArray array];
//                [[arrList.rac_sequence.signal map:^id _Nullable(id  _Nullable value) {
//                    
//                    id jsonModel = [[model class] yy_modelWithDictionary:value];
//                    return jsonModel;
//                    
//                }] subscribeNext:^(id  _Nullable x) {
//                    
//                    [modelList addObject:x];
//                } completed:^{
//                    
//                    [subject sendNext:modelList];
//                    [subject sendCompleted];
//                }];
//                
//            } else {
//                
//                id jsonModel = [[model class] yy_modelWithDictionary:dict];
//                [subject sendNext:jsonModel];
//                [subject sendCompleted];
//            }
//            
//        } failure:^(GTNetError * _Nonnull error) {
//            
//            [subject sendError:error];
//            [subject sendCompleted];
//        }];
//        
//        
//    } fail:^(GTNetError * _Nonnull error) {
//        
//        [subject sendError:error];
//        [subject sendCompleted];
//    }];
//    
//    
//    
//    //
//    GTLog(@"");
//    return subject;
//    
//}

//
/**
 上传文件到OSS

 @param data 二进制文件
 @param name 文件名 xx/xx.mp4
 @param progressBlock 进度
 @param type 类型
 @return rac
 */
+ (RACSignal *)upLoadData:(NSData *)data
                andFileName:(NSString *)name
                andProgress:(void (^ _Nullable)(float))progressBlock
                andAuthStatus:(GTNetAuthStatusType )type {
    
    
    // 先把 Data -> 云盘
//    NSString *interId = [params objectForKey:@"interId"];
//    NSNumber *companyId = [params objectForKey:@"companyId"];
//    if ([name rangeOfString:@"."].location == NSNotFound) {
//        
//    }
//    NSString *fileType = [NSString string];
    
    NSTimeInterval timeInterval = [[[NSDate alloc] init] timeIntervalSince1970];
    
//    switch (mime) {
//        case GTNetMimeTypePng:
//            fileType = @".png";
//            break;
//        case GTNetMimeTypeMp4:
//            fileType = @".mp4";
//            break;
//        default:
//            fileType = @".jpg";
//            break;
//    }
    //
    RACSubject *subject = [RACSubject subject];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [formater stringFromDate:date];
    NSString *fileName = [NSString stringWithFormat:@"%@/%d%@",dateStr,(int)timeInterval,name];
    
    [GTNet upLoadWithFilaData:data fileName:fileName progress:^(float progress) {
        
        // 更新进度
        if (progressBlock != nil) {
            progressBlock(progress);
        }
     
        
    } succ:^(NSString * _Nonnull url) {
        
        [subject sendNext:url];
        [subject sendCompleted];
    } fail:^(GTNetError * _Nonnull error) {
        
        [subject sendError:error];
        [subject sendCompleted];
    }];
    
    return subject;
}

+ (RACSignal *) getBlockSingal:(void (^)(RACSubject * _Nonnull))progressBlock {
    
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//       
//        return [RACDisposable disposableWithBlock:^{
//            GTLog(@"RACDisposable");
//        }];
//    }];
//    
    RACSubject *subject = [RACSubject subject];
    progressBlock(subject);
    

    

    
    return subject;
}



@end
