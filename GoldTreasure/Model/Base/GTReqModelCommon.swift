//
//  GTReqModelLogin.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit

/**
 *  登陆请求
 */
class GTReqModelLogin: NSObject {

    // 接口编号
    var interId:String?
    // 版本号
    var ver:NSNumber?
    // 商户编号
    var companyId:NSNumber?
    // 业务类别 1 app注册时 2 app忘记密码 3 管理系统中忘记密码
    var type:NSNumber?
    // 手机号码
    var phoneNo:NSString?
    // 个推用的手机标识
    var clientid:NSString?
    // 密码
    var password:NSString?
    // 原密码
    var oldPassword:NSString?
    // 新密码
    var newPassword:NSString?
    // 代理商ID
    var agentId:NSString?
    
    // 上级代理商ID
    var fagentId:NSString?
    // 验证码
    var verificationCode:NSString?
}

/**
 *  请求订单列表
 */
class GTReqModelLoanOrder: NSObject {
    
    //接口编号 值为toa.getLoans
    var interId:String?
    // 版本号
    var ver:NSNumber?
    // 商户编号
    var companyId:NSNumber?
    // 客户ID
    var custId:NSNumber?
    // 页码
    var pageNo:NSNumber?
    // 每页行数
    var pageSize:NSNumber?
}

/**
 *  请求还款列表
 */
class GTPaybackListReqModel: NSObject {
    
    // 接口编号和借款订单相同，值为值为toa.getNeedPayLoans
    var interId:String?
    // 版本号
    var ver:NSNumber?
    // 商户编号
    var companyId:NSNumber?
    // 客户ID
    var custId:NSNumber?
}

/**
 *  请求还款借款详情
 */
class GTLoanOrderDetailReqModel: NSObject {
    
    // 接口编号 值为toa.getLoanDetail
    var interId:String?
    // 版本号
    var ver:NSNumber?
    // 商户编号
    var companyId:NSNumber?
    // 客户ID
    var custId:NSNumber?
    // 借款订单编号
    var loanId:NSNumber?

}

/**
 *  连连支付
 */
class GTPayWayReqModel: NSObject {
    
    // 接口编号 值为toa.quickPayMent
    var interId:String?
    // 版本号
    var ver:NSNumber?
    // 商户编号
    var companyId:NSNumber?
    // 还款或续借的贷款订单ID
    var loanId:NSNumber?
    // 1续借 2还款
    var type:NSString?
    // 1支付宝还款 2银行卡还款 3手工还款
    var payType:String?
    // 支付总金额
    var payMoney:String?
    // 金额中滞纳金部分金额
    var latefee:String?
    // 还款银行卡号
    var cardNumber:String?

    
}

