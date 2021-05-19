//
//  PaybackModel.h
//  GoldTreasure
//
//  Created by targeter on 2017/7/1.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "BaseModel.h"

@interface PaybackModel : BaseModel
/** 应还金额 */
@property(nonatomic, strong)NSString *finalCash;
/** 借款金额 */
@property(nonatomic, strong)NSString *LoanCash;
/** 到期天数 */
@property(nonatomic, strong)NSString *availableDays;
/** 逾期天数 */
@property(nonatomic, strong)NSString *lateDays;
/** 滞纳金 */
@property(nonatomic, strong)NSString *lateFee;

@end
