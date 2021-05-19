//
//  GTBankCardAuthModel.h
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "BaseModel.h"

@interface GTBankCardAuthModel : BaseModel

//银行卡号
@property (nonatomic, copy) NSString *cardNo;
//银行名称
@property (nonatomic, copy) NSString *bankName;
//银行卡logo地址
@property (nonatomic, copy) NSString *logoUrl;
//添加卡片时间
@property (nonatomic, copy) NSString *addTime;
//提交审核时间
@property (nonatomic, copy) NSString *commitTime;
//授权状态
@property (nonatomic, assign) GTAuthStatus authStatus;
//服务器授权状态
@property (nonatomic, copy) NSString *auditStatus;
//失败原因
@property (nonatomic, copy) NSString *auditRemark;

@end
