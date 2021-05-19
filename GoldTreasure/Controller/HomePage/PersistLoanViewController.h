//
//  PersistLoanViewController.h
//  GoldTreasure
//
//  Created by targeter on 2017/7/1.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTBaseViewController.h"
@class GTPayWayReqModel;

@interface PersistLoanViewController : GTBaseViewController
/** GTPayWayReqModel */
@property(nonatomic, strong)GTPayWayReqModel *PayWayReqModel;
/** 借款金额 */
@property(nonatomic, strong)NSString *loanCashString;
/** 滞纳金 */
@property(nonatomic, strong)NSString *lateFee;
/** 应付金额 */
@property(nonatomic, strong)NSString *sumCash;
/** 手续费 */
@property(nonatomic, strong)NSString *handleFee;
/** 申请日期 */
@property(nonatomic, strong)NSString *reqTime;
/** 贷款开始日期 */
@property(nonatomic, strong)NSString *startTime;
/** 还款日期 */
@property(nonatomic, strong)NSString *endTime;

@end
