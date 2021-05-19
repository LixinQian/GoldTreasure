//
//  GTTradeService.h
//  GoldTreasure
//
//  Created by targeter on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTTradeService : NSObject

+ (GTTradeService *)sharedInstance;

/** 借款列表 */
-(void)loanOrderListWithReqModel:(id)reqModel
                            succ:(void (^)(id resModel))succBlock
                            fail:(void(^)(GTNetError *error))errorBlcok;
/** 借款详情 */

/** 还款列表 */
-(void)paybackListResModelReqModel:(id)reqModel
                              succ:(void (^)(id resModel))succBlock
                              fail:(void(^)(GTNetError *error))errorBlcok;
// 借款列表
-(void)reqLoanOrderListWittPage:(int)page
                           succ:(void (^)(NSArray *modelList))succBlock
                           fail:(void(^)(GTNetError *error))errorBlcok;

/** 连连还款 */
-(void)lianlianPay:(id)reqModel
              succ:(void (^)(id resModel))succBlock
              fail:(void(^)(GTNetError *error))errorBlcok;

/** 借款详情 */
-(void)requestOrderDetail:(NSString *)loanId
                     succ:(void(^)(GTLoanOrderDetailResModel *resModel))succBlock
                     fail:(void(^)(GTNetError *error))errorBlcok;


@end
