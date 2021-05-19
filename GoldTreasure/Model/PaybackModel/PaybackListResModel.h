//
//  PaybackListResModel.h
//  GoldTreasure
//
//  Created by targeter on 2017/7/4.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "BaseModel.h"
@class PaybackCellModel;
@interface PaybackListResModel : BaseModel

/** 提示信息 */
@property (nonatomic, copy) NSString * _Nullable message;
/** 应还款金额合计 */
@property (nonatomic, strong) NSNumber * _Nullable sumMoney;
/** 贷款订单编号 */
@property (nonatomic, strong) NSNumber * _Nullable recentPayDay;
/** 借款单数 */
@property (nonatomic, strong) NSNumber * _Nullable payBackNum;
/** 逾期单数 */
@property (nonatomic, strong) NSNumber * _Nullable overDueNumber;
/** body.loans多行 */
@property (nonatomic, strong) NSArray<PaybackCellModel *> * _Nullable loans;

@end
