//
//  GTTradeService.m
//  GoldTreasure
//
//  Created by targeter on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTTradeService.h"


#import "LLOrder.h"
@implementation GTTradeService
@class GTPaybackListReqModel;
@class GTResModelLoanOrder;
@class GTLoanOrderDetailResModel;
// 实例化
+ (GTTradeService *)sharedInstance {
    
    static GTTradeService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 初始化单例类对象
        instance = [[self alloc] init];
        
    });
    
    return instance;
}


// 借款列表
-(void)loanOrderListWithReqModel:(id)reqModel
                            succ:(void (^)(id resModel))succBlock
                            fail:(void(^)(GTNetError *error))errorBlcok
{
    NSDictionary *dict = [reqModel yy_modelToJSONObject];
    [[GTApi requestParams:dict andResmodel:[GTResModelLoanOrder class] andAuthStatus:nil]
     subscribeNext:^(id _Nullable model) {
         
         if (succBlock != nil) {
             succBlock(model);
             //             [GTUser.manger reloadUserInfoWithSucc:nil fail:nil];
         }
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         if (errorBlcok != nil) {
             errorBlcok(err);
         }
         [GTHUD dismiss];
         [GTHUD showErrorWithTitle: err.msg];
         GTLog(@"#####%@", err);
     }];
    
}

// 借款列表
-(void)reqLoanOrderListWittPage:(int)page
                            succ:(void (^)(NSArray *resModelList))succBlock
                            fail:(void(^)(GTNetError *error))errorBlcok
{
  
  
    
    //
//    [GTHUD showStatusWithTitle:nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"interId"] = GTApiCode.getLoans;
    dict[@"pageNo"] = @(page);
    dict[@"pageSize"] = @(10);
    
    [[GTApi requestParams:dict andResmodel:[GTResModelLoanOrder class] andAuthStatus:nil]
     subscribeNext:^(NSArray *_Nullable modelList) {
         
         [GTHUD dismiss];
         if (succBlock != nil) {
             succBlock(modelList);
         }
         
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         
         if (errorBlcok != nil) {
             errorBlcok(err);
         }
         
         [GTHUD showStatusWithTitle:nil];
     }];
    
}

// 借款详情
-(void)loanOrderDetail:(id)reqModel
                          succ:(void (^)(id resModel))succBlock
                          fail:(void(^)(GTNetError *error))errorBlcok
{
    [GTHUD showStatusWithTitle:nil];
    NSDictionary *dict = [reqModel yy_modelToJSONObject];
    [[GTApi requestParams:dict andResmodel:[GTLoanOrderDetailResModel class] andAuthStatus:nil]
     subscribeNext:^(id _Nullable model) {
         
         if (succBlock != nil) {
             succBlock(model);
             //             [GTUser.manger reloadUserInfoWithSucc:nil fail:nil];
             [GTHUD dismiss];
         }
     } error:^(NSError * _Nullable error) {
         
         [GTHUD dismiss];
         GTNetError *err = (GTNetError *) error;
         if (errorBlcok != nil) {
             errorBlcok(err);
             [GTHUD showErrorWithTitle: err.msg];
         }
         GTLog(@"#####%@", err);
     }];
    
}

//
-(void)requestOrderDetail:(NSString *)loanId
                     succ:(void(^)(GTLoanOrderDetailResModel *resModel))succBlock
                     fail:(void(^)(GTNetError *error))errorBlcok {
    
    
    [GTHUD showStatusWithTitle:nil];
    NSDictionary *dict = @{@"loanId":loanId,@"interId":GTApiCode.getLoanDetail};
    [[GTApi requestParams:dict andResmodel:[GTLoanOrderDetailResModel class] andAuthStatus:nil]
     subscribeNext:^(GTLoanOrderDetailResModel *_Nullable model) {
         
         [GTHUD dismiss];
         if (succBlock != nil) {
             succBlock(model);
             //             [GTUser.manger reloadUserInfoWithSucc:nil fail:nil];
             [GTHUD dismiss];
         }
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         if (errorBlcok != nil) {
             errorBlcok(err);
         }
         [GTHUD dismiss];
         [GTHUD showErrorWithTitle: err.msg];
         GTLog(@"#####%@", err);
     }];
    
    //    WEAKSELF
    //    [[GTTradeService sharedInstance] LoanOrderDetailReqModel:weakSelf.reqModel succ:^(GTLoanOrderDetailResModel *resModel) {
    //        weakSelf.resModel = resModel;
    //        for (int i = 0; i < self.resModel.latefees.count; i++) {
    //            GTLatefees *feeModel = self.resModel.latefees[i];
    //            float feeValue = feeModel.money.intValue;
    //            if (feeModel.type.intValue == 2) {
    //                _sumLateFeeFloat -= feeValue;
    //            } else {
    //                _sumLateFeeFloat += feeValue;
    //            }
    //        }
    //
    //        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //            [weakSelf.myTableView reloadData];
    //            if (resModel.loanStatus.intValue == 3 || resModel.loanStatus.intValue == 6) {
    //                [weakSelf setBottomButtons];
    //            }
    //
    //        }];
    //
    //    } fail:^(GTNetError *error) {
    //        GTNetError *err = (GTNetError *) error;
    //        [GTHUD showErrorWithStr:[NSString stringWithFormat:@"%@",err]];
    //    }];
    
}


// 还款列表
-(void)paybackListResModelReqModel:(id)reqModel
                              succ:(void (^)(id resModel))succBlock
                              fail:(void(^)(GTNetError *error))errorBlcok
{
    [GTHUD showStatusWithTitle:nil];
    NSDictionary *dict = [reqModel yy_modelToJSONObject];
    [[GTApi requestParams:dict andResmodel:[GTPaybackListResModel class] andAuthStatus:nil]
     subscribeNext:^(id _Nullable model) {
         
         if (succBlock != nil) {
             succBlock(model);
             //             [GTUser.manger reloadUserInfoWithSucc:nil fail:nil];
             [GTHUD dismiss];
         }
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         if (errorBlcok != nil) {
             errorBlcok(err);
         }
         [GTHUD dismiss];
         [GTHUD showErrorWithTitle: err.msg];
         GTLog(@"#####%@", err);
     }];
    
}

// 连连还款
-(void)lianlianPay:(id)reqModel
              succ:(void (^)(id resModel))succBlock
              fail:(void(^)(GTNetError *error))errorBlcok
{
    NSDictionary *dict = [reqModel yy_modelToJSONObject];
    
    [[GTApi requestParams:dict andResmodel:[LLOrder class] andAuthStatus:nil]
     subscribeNext:^(LLOrder *  _Nullable model) {
         
         if (succBlock != nil) {
             succBlock(model);
         }
     } error:^(NSError * _Nullable error) {
         
         GTNetError *err = (GTNetError *) error;
         if (errorBlcok != nil) {
             errorBlcok(err);
         }
         [GTHUD showErrorWithTitle: err.msg];
         GTLog(@"#####%@", error);
     }];
    
}


@end
