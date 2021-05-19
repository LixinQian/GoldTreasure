//
//  OrderModel.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/27.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "BaseModel.h"

@interface OrderModel : BaseModel

//首页
@property (nonatomic, copy) NSString *creditLine;
@property (nonatomic, copy) NSString *usedCredits;
@property (nonatomic ,copy) NSString *surplusCredits;

/** 接口编号 */
@property (nonatomic, copy) NSString *interId;
/** 版本号 */
@property (nonatomic, copy) NSNumber *ver;
/** 商户编号 */
@property (nonatomic, copy) NSNumber *companyId;
/** 客户ID */
@property (nonatomic, copy) NSNumber *custId;

//紧急联系人
/** 姓名 */
@property (nonatomic, copy) NSString *name;
/** 关系 */
@property (nonatomic, copy) NSString *relation;
/** 联系电话 */
@property (nonatomic, copy) NSString *phoneNo;

/** 借款利息 除10000才是百分比 */
@property (nonatomic, copy) NSNumber *interestDay;
/** 管理费 除10000才是百分比 */
@property (nonatomic, copy) NSNumber *magFeeDay;

/** 借款金额 */
@property (nonatomic, assign) NSNumber *borrowAmount;
/** 固定周期 */
@property (nonatomic, assign) NSNumber *period;
///** 借款利息费用（具体钱数） */
//@property (nonatomic, assign) NSNumber rateCount;
///** 管理费（具体钱数） */
//@property (nonatomic, assign) NSNumber overHeadCount;
///** 到账金额 */
//@property (nonatomic, assign) NSNumber arrivalAmount;


//提交借款订单
/** 借款金额 */
@property (nonatomic, copy) NSNumber *reqMoney;
/** 手续费 */
@property (nonatomic, copy) NSNumber *handleFee;
/** 签名图片 */
@property (nonatomic, copy) NSString *signImage;
/** 借款手机设备 */
@property (nonatomic, copy) NSString *clientid;

@end
