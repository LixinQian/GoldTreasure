//
//  GTPhoneAuthModel.h
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "BaseModel.h"

@interface GTPhoneAuthModel : BaseModel

//手机号
@property (nonatomic, copy) NSString *phoneNo;
//提交审核时间
@property (nonatomic, copy) NSString *commitTime;
//审核通过时间
@property (nonatomic, copy) NSString *successTime;
//服务器授权状态
@property (nonatomic, copy) NSString *auditStatus;
//授权状态
@property (nonatomic, assign) GTAuthStatus authStatus;
//失败原因
@property (nonatomic, copy) NSString *auditRemark;

@end
