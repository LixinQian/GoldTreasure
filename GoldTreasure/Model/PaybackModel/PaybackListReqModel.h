//
//  PaybackListReqModel.h
//  GoldTreasure
//
//  Created by targeter on 2017/7/4.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "BaseModel.h"

@interface PaybackListReqModel : BaseModel

/** 接口编号和借款订单相同，值为toa.getNeedPayLoans */
@property (nonatomic, copy) NSString * _Nullable interId;
/** 版本号 */
@property (nonatomic, strong) NSNumber * _Nullable ver;
/** 商户编号 */
@property (nonatomic, strong) NSNumber * _Nullable companyId;
/** 客户ID */
@property (nonatomic, strong) NSNumber * _Nullable custId;

@end
