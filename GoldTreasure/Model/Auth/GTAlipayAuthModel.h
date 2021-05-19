//
//  GTAlipayAuthModel.h
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "BaseModel.h"

@interface GTAlipayAuthModel : BaseModel

//支付宝账号
@property (nonatomic, copy) NSString *alipayAccount;
//认证时间
@property (nonatomic, copy) NSString *authTime;
//认证失败原因
@property (nonatomic, copy) NSString *auditRemark;
//提交审核时间
@property (nonatomic, copy) NSString *commitTime;
//审核通过时间
@property (nonatomic, copy) NSString *successTime;
//授权状态
@property (nonatomic, assign) GTAuthStatus authStatus;
//服务器授权状态
@property (nonatomic, copy) NSString *auditStatus;

@end
