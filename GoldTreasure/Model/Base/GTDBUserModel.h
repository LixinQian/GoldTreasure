//
//  GTDBUserModel.h
//  GoldTreasure
//
//  Created by ZZN on 2017/7/7.
//  strongright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
@class GTDBCommonModel;

// 定义 RLMArray类型

//RLM_ARRAY_TYPE(GTDBCommonModel)
@interface GTDBUserModel:RLMObject

// 提示信息
@property (nonatomic, strong) NSString  * message;
// 客户ID
@property (nonatomic, strong) NSString * custId;
// 手机号
@property (nonatomic, strong) NSString  * phoneNo;
// 头像
@property (nonatomic, strong) NSString  * headimgUrl;
// 身份证号
@property (nonatomic, strong) NSString  * custNumber;
// 客户实名
@property (nonatomic, strong) NSString  * custName;
// 认证状态
@property (nonatomic, assign) NSInteger  status;
// 各个认证模块 是否有 1 失效
@property (nonatomic, assign) NSInteger  oldStatus;

// 实名认证状态
@property (nonatomic, assign) NSInteger  certificationStatus;
// 银行卡绑定状态
@property (nonatomic, assign) NSInteger  cardBindStatus;
// 通讯录上传状态
@property (nonatomic, assign) NSInteger  addrbookStatus;

// 运营商认证状态
@property (nonatomic, assign) NSInteger  mobileStatus;
// 支付宝证状态
@property (nonatomic, assign) NSInteger   zfbStatus;
// 紧急联系人上传状态
@property (nonatomic, assign) NSInteger  hasElinkman;
// 是否为黑名单中客户
@property (nonatomic, assign) NSInteger  isBlack;

// 授权信用额度
@property (nonatomic, assign) NSInteger  authedCredit;
// 已使用授权额度
@property (nonatomic, assign) NSInteger  usedCredit;

// 接口编号
@property (nonatomic, assign) NSInteger  interId;
// 商户编号
@property (nonatomic, assign) NSInteger  companyId;
// 代理商ID
@property (nonatomic, assign) NSInteger   agentId;
// 上级代理商ID
@property (nonatomic, assign) NSInteger   fagentId;
// token
@property (nonatomic, strong) NSString  * token;
////
//@property  RLMArray<GTDBCommonModel> *common;

// 活动ID
@property (nonatomic, strong) NSString  * actId;
// 活动封面图
@property (nonatomic, strong) NSString  * coverImg;

// 升级文件所在地址
@property (nonatomic, strong) NSString  * updateUrl;
// 升级内容
@property (nonatomic, strong) NSString  * updateNote;
// 最新版本
@property (nonatomic, strong) NSString  * appVersion;


// 是否需要升级  0否 1可选升级 2必须升级
@property (nonatomic, assign) NSInteger needUpdate;

@end

//
@interface GTDBCommonModel : RLMObject

@property NSString *custId;
@property NSString *actId;
@property NSString *coverImg;


@end
