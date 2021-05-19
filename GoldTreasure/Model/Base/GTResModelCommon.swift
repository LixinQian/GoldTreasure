//
//  GTBaseModel.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit
import Realm
import YYModel

class GTResModelCommon: NSObject {

    // 状态
    var status:NSNumber?
    // 提示信息
    var message:String?
    // 请求内容
    var body:AnyObject?
}

class GTResModelAuth: NSObject {
    
    // 认证订单流水号
    var bizNo:NSString?
    
}

class GTResModelUserInfo:NSObject,NSMutableCopying {

    
    // 提示信息
    var message:String?
    // 客户ID
    var custId:NSNumber?
    // 手机号
    var phoneNo:NSString?
    // 头像
    var headimgUrl:NSString?
    // 身份证号
    var custNumber:NSString?
    // 客户实名
    var custName:NSString?
    // 银行卡名称
    var bankName:NSString = "建设银行"
    // 银行卡号
    var cardNumber:NSString?
    // 认证状态
    var status:NSNumber?
    // 各个认证模块 是否有 1 失效
    var oldStatus:NSNumber?
    
    // 实名认证状态
    var certificationStatus:NSNumber?
    // 银行卡绑定状态
    var cardBindStatus:NSNumber?
    // 通讯录上传状态
    var addrbookStatus:NSNumber?
    
    // 运营商认证状态
    var mobileStatus:NSNumber?
    // 支付宝证状态
    var zfbStatus:NSNumber?
    // 紧急联系人上传状态
    var hasElinkman:NSNumber?
    // 是否为黑名单中客户
    var isBlack:NSNumber?
    
    // 授权信用额度
    var authedCredit:NSNumber?
    // 已使用授权额度
    var usedCredit:NSNumber?
    
    // 接口编号
    var interId:NSNumber?
    // 商户编号
    var companyId:NSNumber?
    // 代理商ID
    var agentId:NSNumber?
    // 上级代理商ID
    var fagentId:NSNumber?
    // token
    var token:NSString?
    // 活动ID
    var actId:NSString?
    // 活动封面图
    var coverImg:NSString?
    
    // 升级文件所在地址
    var updateUrl:NSString?
    // 升级内容
    var updateNote:NSString?
    // 最新版本
    var appVersion:NSString?
    // 是否需要升级  0否 1可选升级 2必须升级
    var needUpdate:NSNumber?
    
    func mutableCopy(with zone: NSZone? = nil) -> Any {
        
        let person = GTResModelUserInfo()
        person.message = message
        person.custId = custId
        person.phoneNo = phoneNo
        person.headimgUrl = headimgUrl
        person.custNumber = custNumber
        person.custName = custName
        person.status = status
        person.certificationStatus = certificationStatus
        person.cardBindStatus = cardBindStatus
        person.addrbookStatus = addrbookStatus
        person.mobileStatus = mobileStatus
        person.zfbStatus = zfbStatus
        person.hasElinkman = hasElinkman
        person.isBlack = isBlack
        person.authedCredit = authedCredit
        person.usedCredit = usedCredit
        person.interId = interId
        person.companyId = interId
        person.agentId = agentId
        person.fagentId = fagentId
        person.token = token
        
        return person
    }
    
    // 获取类中params参数
    func paramsCopy() -> NSDictionary {
        
        return self.yy_modelToJSONObject() as? NSDictionary ?? NSDictionary()
    }
}


/**
 *  借款列表响应
 */
@objc class GTResModelLoanOrder:NSObject {
    
    // 提示信息
    var message:String?
    // 贷款订单ID
    var loanId:NSNumber?
    // 贷款订单编号
    var orderNo:NSString?
    // 贷款金额
    var reqMoney:NSNumber?
    // 申请日期
    var reqTime:NSString?
    // 还款日期
    var endTime:NSString?
    // 贷款订单状态
    var loanStatus:NSNumber?
    // 逾期状态
    var lateFlag:NSNumber?
}

/**
 *  借款还款详情响应
 */
@objc class GTLoanOrderDetailResModel:NSObject {

    // 提示信息
    var message:String?
    // 贷款订单ID
    var loanId:NSNumber?
    // 贷款订单编号
    var orderNo:NSString?
    // 贷款金额
    var reqMoney:NSNumber?
    // 申请日期
    var reqTime:NSString?
    // 贷款开始日期
    var startTime:NSString?
    // 还款日期
    var endTime:NSString?
    // 贷款订单状态
    var loanStatus:NSNumber?
    // 逾期状态
    var lateFlag:NSNumber?
    // 手续费
    var handleFee:NSNumber?
    // Body.latefees多行
    var latefees:NSArray?
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["latefees":GTLatefees.classForCoder()];
    }

}

/**
 *  借款还款详情的请求得到的数据中的滞纳金响应
 */
@objc class GTLatefees:NSObject {
    
    // 滞纳金产生日期
    var createTime:NSString?
    // 类别 1滞纳金产生 2滞纳金减免
    var type:NSNumber?
    // 滞纳金额或减免金额
    var money:NSNumber?
}

/**
 *  还款订单整体列表响应
 */
class GTPaybackListResModel:NSObject {
    // 提示信息
    var message:String?
    // 应还款金额合计
    var sumMoney:NSNumber?
    // 最近还款额日
    var recentPayDay:NSString?
    // 借款单数
    var payBackNum:NSNumber?
    // 逾期单数
    var overDueNumber:NSNumber?
    // body.loans多行
    var loans:NSArray?
    
    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        
        return ["loans":GTPaybackCellModel.classForCoder()];
    }
}

/**
 *  还款订单cell响应
 */
@objc class GTPaybackCellModel:NSObject {

    // 贷款订单ID
    var loanId:NSNumber?
    // 贷款订单编号
    var orderNo:NSString?
    // 贷款金额 单位分
    var reqMoney:NSNumber?
    // 滞纳金总额 单位分
    var lateFee:NSNumber?
    // 逾期天数
    var lateDays:NSNumber?
    // 剩余天数
    var remainDays:NSNumber?
    // 逾期状态
    var lateFlag:NSNumber?

    
}

