//
//  GTUserAuthModel.h
//  GoldTreasure
//
//  Created by wangyaxu on 07/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "BaseModel.h"

@interface GTUserAuthModel : BaseModel

//姓名
@property (nonatomic, copy) NSString *name;
//身份证号
@property (nonatomic, copy) NSString *idCard;
//身份证有效期
@property (nonatomic, copy) NSString *cardValid;
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
