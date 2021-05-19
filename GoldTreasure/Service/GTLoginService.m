//
//  GTLoginService.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTLoginService.h"
#import "GTLoginController.h"
#import "NSNumber+GT.h"
#import "GTDBUserModel.h"

@implementation GTLoginService
static GTLoginService *instance = nil;
// 实例化
+ (GTLoginService *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 初始化单例类对象
        instance = [[self alloc] init];
    });
    return instance;
}

// 登录
-(void) loginWithReqModel:(id)reqModel
                     succ:(void(^)(GTResModelUserInfo *resModel))succBlock
                     fail:(void(^)(GTNetError *error))errorBlcok  {
    
    
    
    NSMutableDictionary *dict = [reqModel yy_modelToJSONObject]; // 转为字典
    dict[@"clientid"] = [GTUser getGeTuiClentID]; // 传入个推标志
    WEAKSELF
    [[GTApi requestParams:dict andResmodel:[GTResModelUserInfo class] andAuthStatus:nil]
     subscribeNext:^(GTResModelUserInfo *_Nullable model) {
         
         
         if (succBlock != nil) {
             succBlock(model);
         }
         
         // 处理登录操作
         [weakSelf doWithLoginSucc:model];

     } error:^(NSError * _Nullable error) {
         
         // 处理登录错误操作
         GTNetError *err = (GTNetError *) error;
         if (errorBlcok != nil) {
             errorBlcok(err);
         }
         [GTLoginService doWithError:err];
         GTLog(@"#####%@", err);
     }];
}

// 注册
- (void) registerWithParams:(id)reqModel
                       succ:(void(^)(GTResModelUserInfo *resModel))succBlock
                       fail:(void(^)(GTNetError *error))errorBlcok {
    
    
    [GTHUD showStatusWithTitle:@"注册中..."];
    NSMutableDictionary *dict = [reqModel yy_modelToJSONObject];
    dict[@"clientid"] = [GTUser getGeTuiClentID];
    
    WEAKSELF
    [[GTApi requestParams:dict andResmodel:[GTResModelUserInfo class] andAuthStatus:nil]
     subscribeNext:^(GTResModelUserInfo*  _Nullable resModel) {
       
         if (succBlock != nil) {
             succBlock(resModel);
         }
         // 处理登录操作
         [weakSelf doWithLoginSucc:resModel];
         
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *)error;
         if (errorBlcok != nil) {
             errorBlcok(err);
         }
     }];
}

// token 刷新 个人信息
-(void) refreshWith:(void(^)(GTResModelUserInfo *resModel))succBlock
                     fail:(void(^)(GTNetError *error))errorBlcok  {
    
    if (![GTUser isLogin]) {
        return;
    }
    
    NSDictionary *dict = @{@"interId":GTApiCode.getCustInfoByToken};
    [[GTApi requestParams:dict andResmodel:[GTResModelUserInfo class] andAuthStatus:nil]
     subscribeNext:^(GTResModelUserInfo *_Nullable model) {
         
         // 存入 缓存
         [GTDB execWithAction:^(RLMRealm * _Nonnull realm) {
             
             NSDictionary *dict = [model yy_modelToJSONObject];
             GTDBUserModel *dbModel = [GTDBUserModel yy_modelWithJSON:dict];
             [realm addOrUpdateObject:dbModel];
         } succ:nil];
         // 更新个人信息model
         GTUser.manger.userInfoModel = model;
         
         if (succBlock != nil) {
             succBlock(model);
         }
         
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         
         if ([GTUser isLogin]) { // && err.code == 100
             
             [GTLoginService resultDBUserInfo:^(RLMResults * _Nullable result) {
                 
                 NSDictionary *dict = [result.firstObject yy_modelToJSONObject];
                 GTResModelUserInfo *res = [GTResModelUserInfo yy_modelWithDictionary:dict];
                 succBlock(res);
             }];
         } else {
             // 用户未登录失败 处理
             if (errorBlcok != nil) {
                 errorBlcok(err);
             }
         }
         
         [GTLoginService doWithError:err];
         GTLog(@"#####%@", err);
     }];
}

// [GTLoginService doWithError:err];
// 处理登录成功相关的处理
- (void) doWithLoginSucc:(GTResModelUserInfo *) model {
    
    [GTUser saveLoginUserWithPhone:model.phoneNo cusId:model.custId token:model.token];
    GTUser.manger.userInfoModel = model;
    [GTLoginService saveUserInfoToDB:model];
    [[NSNotificationCenter defaultCenter] postNotificationName: NOTIUSERLOGINSUCC object:nil userInfo:[model yy_modelToJSONObject]];
    // 信息校验
    [GTCheck checkUpdateVerAndProfile];
}


// 处理token刷新成功
- (void) doWithRefreshTokenSucc:(GTResModelUserInfo *) model {
    
    [GTLoginService saveUserInfoToDB:model];
}

// 处理登录缓存
+ (void)saveUserInfoToDB:(GTResModelUserInfo *)info {
    
    //
    __block NSDictionary *dict = [info yy_modelToJSONObject];
    
    [GTDB execWithAction:^(RLMRealm * _Nonnull realm) {
        
        GTDBUserModel *model = [GTDBUserModel yy_modelWithDictionary:dict];
        [realm addOrUpdateObject:model];
    } succ:nil];
    GTLog(@"%@",dict);
    
}
// 读取缓存
+ (void)resultDBUserInfo:(void(^ _Nonnull)(RLMResults *result))block {

    NSString *cusId = [[GTUser getCurrentUserID] toString];
    
    if (![cusId isEmptyOrWhitespace] || ![GTUser isLogin]) {

        RLMResults *res = (RLMResults *)@[[RLMObject new]];
        block(res);;
    }
    [GTDB execWithCusId:cusId resultBlock:^(RLMResults<RLMObject *> * _Nonnull list) {
        
        block(list);
        GTLog(@"缓存数据:%@",list);
    }];
}

// 处理 未登录 token 失效
+ (void) doWithTokenErr {
    
    // token 过期
    if ([GTUser isLogin] && ![GTUser isDefaultTokenKey]) {
        
        [GTHUD showErrorWithTitle:@"帐号登录已在其他设备登录，请重新登录"];
        [GTUser.manger loginInSucc:nil fail:nil];
    } else {
        [GTHUD showErrorWithTitle:@"帐号未登录"];
    }
}

// 处理 接口升级
+ (void)doWithApiErr {
    
    // 接口升级 app
    [GTHUD showAlertWithContent:@"接口需要升级" trueTitle:@"去升级" cancelTitle:@"取消" trueCol:^{
        
        [GTCommonService.manger checkUpdataVersion:nil];
    } cancelCol:nil];
    
}

// 处理登录过期和为登录
+ (void) doWithError:(GTNetError *) err {
    
    //
    switch (err.code) {
        // 100 错误处理
        case GTNetErrorTypeNoLogin:
            [self doWithTokenErr];
            break;
        case GTNetErrorTypeApiUpdate:
            [self doWithApiErr];
            break;
        default:
            break;
    }
}

- (void)uploadUserAvatarWithImage:(UIImage *_Nonnull )image
                      andProgress:(void (^_Nullable)(float progress))progressBlock
                             succ:(void(^_Nullable)(id _Nullable resModel, NSString * _Nullable imageUrl))succBlock
                             fail:(void(^_Nullable)(GTNetError *_Nullable error))errorBlcok
{
    //compress image
    NSInteger dataLimit = 100; //头像100k以下
    NSData *data = [image resetSizeOfImageData:image maxSize:dataLimit resolution:CGPointMake(AvatarDimension, AvatarDimension)];

    __block NSMutableDictionary *avatarParams = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                                @"interId" : GTApiCode.updateCustHeadimg,
                                                                                                @"headimgUrl" : @""
                                                                                                }];
    [[[[GTApi upLoadData:data andFileName:@"avatar.jpg" andProgress:^(float progress) {
        
        progressBlock(progress);
    } andAuthStatus:GTNetAuthStatusTypeLogined] doNext:^(NSString  *_Nullable urlPath) {
        
        GTLog(@"oss地址：%@",urlPath);
        avatarParams[@"headimgUrl"] = [urlPath stringByAppendingString:@"!s"];
    }] then:^RACSignal * _Nonnull{
        
        return [GTApi requestParams:avatarParams andResmodel:[GTResModelCommon class]  andAuthStatus:nil];
    }] subscribeNext:^(GTResModelCommon  *_Nullable x) {
        
        if (succBlock) {
            succBlock(x, avatarParams[@"headimgUrl"]);
        }
    } error:^(NSError * _Nullable error) {
        
        if (errorBlcok) {
            errorBlcok((GTNetError *)error);
        }
    }];
}

- (UIImage *)resizedImageWithOriginImage:(UIImage *)originImage size:(CGSize )targetSize
{
    //格式化头像尺寸
    UIGraphicsBeginImageContext(targetSize);
    [originImage drawInRect:CGRectMake(0,0,targetSize.width,targetSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


// 显示登录页面
+ (void) showLoginView {
    GTLoginRoot *vc = [GTLoginRoot new];
    [[GTHUD currentNav] presentViewController:vc animated:true completion:nil];
}



@end
