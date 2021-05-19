//
//  GTApiInterCode.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit


/// 接口编号
@objc class GTApiCode: NSObject {

    // 登陆
    @objc static let loginByPhone:NSString          = "toa.loginByPhone"
    // 获取验证码
    @objc static let getVerificationCode:NSString   = "toa.getVerificationCode"
    // 注册
    @objc static let registerAppCust:NSString       = "toa.registerAppCust"
    // 更新头像
    @objc static let updateCustHeadimg:NSString     = "toa.updateCustHeadimg"
    // 通过手机号+验证码重置密码<已完成>
    @objc static let resetCustPassword:NSString     = "toa.resetCustPassword"
    // 登录后修改密码
    @objc static let modifyCustPassword:NSString    = "toa.modifyCustPassword"
    // 登录后修改密码
    @objc static let submitElinkman:NSString        = "toa.submitElinkman"
    // 获取借款订单列表
    @objc static let getLoans:NSString              = "toa.getLoans"
    // 获取还款订单列表
    @objc static let getNeedPayLoans:NSString       = "toa.getNeedPayLoans"
    // 获取还款方式连连等
    @objc static let getQuickPayMent:NSString       = "toa.quickPayMent"
    // 获取借款订单详情页面
    @objc static let getLoanDetail:NSString         = "toa.getLoanDetail"
    // 获取个人资料
    @objc static let getCustInfoByToken:NSString    = "toa.getCustInfoByToken"
    // 获取系统参数（费率）
    @objc static let getConfig:NSString             = "toa.getConfig"
    // 提交借款订单）
    @objc static let submitLoan:NSString            = "toa.submitLoan"
    // 获取首页活动图片列表
    @objc static let getActivityImgs:NSString       = "toa.getActivityImgs"
    
    // 提交实名认证
    @objc static let submitCertify:NSString         = "toa.submitCertify"
    // 上传通讯录
    @objc static let submitAddrbook:NSString        = "toa.submitAddrbook"
    // 绑定银行卡
    @objc static let submitCardBind:NSString        = "toa.submitCardBind"
    // 提交支付宝
    @objc static let submitZfbCertify:NSString      = "toa.submitZfbCertify"
    // 创建认证订单流水
    @objc static let createAuthOrder:NSString       = "toa.createAuthOrder"
    // 取消认证订单流水
    @objc static let processBizFlow:NSString        = "toa.processBizFlow"
    // 客户认证信息查询
    @objc static let getAuthStatus:NSString         = "toa.getAuthStatus"
    // 客户认证信息明细查询
    @objc static let getAuthDetail:NSString         = "toa.getAuthDetail"
    // 查询银行卡绑定信息
    @objc static let queryCardBind:NSString         = "toa.queryCardBind"
    
    // 查询用户更新
    @objc static let checkUpdate:NSString           = "toa.checkUpdate"
    
}

/// 接口 固定入参数 配置
@objc class GTApiCommonParam: NSObject {
    
    // 版本号
    @objc static let ver:NSNumber       = NSNumber(value: APIVER)
    // 商户编号
    @objc static let companyId:NSNumber = NSNumber(value: APICOMPANYID)

}
