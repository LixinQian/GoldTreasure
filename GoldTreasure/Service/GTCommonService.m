//
//  GTCommonService.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/11.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTCommonService.h"
#import "GTRealmService.h"
#import "OrderModel.h"


@implementation GTCommonService
static GTLoginService *instance = nil;
// 实例化
+ (GTLoginService *)manger {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 初始化单例类对象
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)requestBannerImgList:(void(^)(NSArray<GTDBCommonModel *> *listModel))succ {
    
    // 请求banner 图
    [[GTApi requestParams:@{@"interId":GTApiCode.getActivityImgs} andResmodel:[GTDBCommonModel class] andAuthStatus:nil] subscribeNext:^(NSArray*  _Nullable x) {
        
        __block NSMutableArray *arrList = [NSMutableArray array];
        
        [GTRealmService execRealm:^(RLMRealm * _Nonnull realm) {
            
            
            // 移除 缓存数据
            [realm deleteObjects:[GTDBCommonModel allObjects]];
            for (GTDBCommonModel *model in x) {
                // 加入 缓存
                model.custId = [[GTUser getCurrentUserID] toString];
                [arrList addObject: model];
                [realm addObject: model];
            }
            succ(arrList);
        }];
        
    } error:^(NSError * _Nullable error) {
        
        GTLog(@"%@",error);
        NSMutableArray *arrList = [NSMutableArray array];
        
        
        [GTRealmService execResult:[GTDBCommonModel alloc] andPredicate:nil andWithResult:^(RLMResults * _Nonnull result) {
            
            for (GTResModelUserInfo *info in result) {
                [arrList addObject:info];
            }
            //
            succ(arrList);
        }];
    }];
    
}

// 版本检测
-(void)checkUpdataVersion:(void(^)())finishedBlock {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *version = [GTClient clientVersion];
    dict[@"name"] =  @"huajinbao";
    dict[@"os"] = @"ios";
    dict[@"v"] = version;
    dict[@"interId"] = GTApiCode.checkUpdate;
    
    [[GTApi requestParams:dict andResmodel:[GTResModelUserInfo class] andAuthStatus:nil] subscribeNext:^(GTResModelUserInfo  *_Nullable x) {
        
        NSString *version = x.appVersion;
        NSNumber *state = x.needUpdate;
        NSString *url = x.updateUrl;
        
        [GTCommonService compareLocalVersion:version needUpdate:state content:x.updateNote updateUrl:url otherVerify:^(bool isOk) {
            
            if (finishedBlock) {
                finishedBlock();
            }
        }];
    }];
}

// 比较版本号
+ (void) compareLocalVersion:(NSString *)str needUpdate:(NSNumber *)state content:(NSString *)desc updateUrl:(NSString *)url otherVerify:(void(^)(bool isOk))block   {
    
    NSString *localVersion  =[[GTClient clientVersion] stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *newVersion = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSInteger a = localVersion.integerValue;
    NSInteger b = newVersion.integerValue;
    
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    
    if (a<b) {
        
        //Todo:
        if (state.intValue == GTClientUpdateTypeNeed) {
        
            // 必须更新
            [GTCheck showNeedUpdateViewWithDesc:attrStr doBlock:^{
              
                NSURL *urlUpdate  = [NSURL URLWithString:url];
                [[UIApplication sharedApplication] openURL:urlUpdate];
            }];
            
            
        } else if (state.intValue == GTClientUpdateTypeOptional) {
            
            // 更新
            
            NSString *newDesc = [NSString stringWithFormat:@"<br/>%@",desc];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[newDesc dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            NSMutableParagraphStyle *paragrapStyle = [NSMutableParagraphStyle new];
            [paragrapStyle setLineSpacing:4];
            [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSParagraphStyleAttributeName:paragrapStyle} range:NSMakeRange(0, attrStr.length)];
            
            [GTHUD showAlertWithTitle:@"更新提示" attrDesc:attrStr trueTitle:@"立即更新" cancelTitle:@"稍后" trueCol:^{
                NSURL *urlUpdate  = [NSURL URLWithString:url];
                [[UIApplication sharedApplication] openURL:urlUpdate];
            } cancelCol:nil];
        }
        
        // block(false);
    } else {
        
        block(true);
    }
}


- (void)requestRate:(void(^_Nonnull)(OrderModel * _Nonnull resModel))succ
{
    [GTHUD showStatusWithTitle:nil];
    NSDictionary *dict = @{
                           @"interId": GTApiCode.getConfig
                           };
    [[GTApi requestParams:dict andResmodel:[OrderModel class] andAuthStatus:nil]
     subscribeNext:^(OrderModel*  _Nullable resModel) {
         if (succ != nil) {
             succ(resModel);
             [GTHUD dismiss];
         }

         
     } error:^(NSError * _Nullable error) {
         GTNetError *err = (GTNetError *) error;
         [GTHUD dismiss];
         [GTHUD showErrorWithTitle: err.msg];
     }];

}
@end
