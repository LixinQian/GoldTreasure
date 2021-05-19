//
//  PaybackCellModel.h
//  GoldTreasure
//
//  Created by targeter on 2017/7/4.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "BaseModel.h"

@interface PaybackCellModel : BaseModel

/** 贷款订单ID */
@property (nonatomic, strong) NSNumber * _Nullable loanId;
/** 贷款订单编号 */
@property (nonatomic, strong) NSString * _Nullable orderNo;
/** 贷款金额 单位分*/
@property (nonatomic, strong) NSNumber * _Nullable reqMoney;
/** 滞纳金总额 单位分*/
@property (nonatomic, strong) NSNumber * _Nullable lateFee;
/** 逾期天数 */
@property (nonatomic, strong) NSNumber * _Nullable lateDays;
/** 剩余天数 */
@property (nonatomic, strong) NSNumber * _Nullable remainDays;
/** 逾期状态 */
@property (nonatomic, strong) NSNumber * _Nullable lateFlag;

@end
