//
//  GTCheck.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/7/12.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit

class GTCheck: NSObject {
    
    // 显示 更新 弹窗 视图
    class func showNeedUpdateView(desc:NSAttributedString,doBlock:@escaping (()->Void)) {
        
        let notiV = getNibUpdateView(logo: nil, title: "发现新版本", desc: desc)
        // 更新
        notiV.actionBtn(block: {
            
            doBlock()
        })
        
        GKCover.center(notiV, style: GKCoverStyle.translucent, notClick: true, animated: true)
    }
    
    /// 校验登录 和 信息 验证
    class func checkUpdateVerAndProfile() {
     
        // 检测版本更新
        GTCommonService.manger().checkUpdataVersion {
            
            if GTUser.isLogin() == false { return }
            // 登录时才校验过期信息
            let dict = ["interId":GTApiCode.getCustInfoByToken]
            GTApi.requestParams(dict, andResmodel: GTResModelUserInfo(), andAuthStatus: nil).subscribeNext({ (model) in
                GTCheck.checkUserInfoState(info: model!)
            })
        }
    }
    
    
    /// 校验个人信息是否过期
    fileprivate class func checkUserInfoState(info:GTResModelUserInfo?) {
        
        if info == nil { return }
        DispatchQueue.main.async {
            
            var dict = [String:String]()
            // 用户登录未认证
            if info?.status == 0 {
                
                GTHUD.showAlert(content: "请先完成认证", trueTitle: "去认证" ,cancelTitle: "取消", trueCol: {
    
                    dict["class"] = NSStringFromClass(GTAuthCenterViewController.classForCoder())
                    GTAdapt.push(dict)
                }, cancelCol: {
                    
                    
                })
                return
            } else if info?.oldStatus == 1 { //认证已失效 1
                
                // 支付宝认证失效
                if info?.zfbStatus == 0 { // 0为 未认证 2 认证成功
                    
                    let text = "支付宝认证两个月认证一次，认证完成后才可进行借款操作"
                    let notiV = getNibNotiView(logo: #imageLiteral(resourceName: "alipay_popup"), title: "支付宝认证已过期", desc: text)
                    // 去认证
                    notiV.actionBtn(block: {
                        dict["class"] = NSStringFromClass(GTAuthCenterViewController.classForCoder())
                        GTAdapt.push(dict)
                    })
                    GKCover.translucentWindowCenterContent(notiV, animated: true, notClick: false)
                    return
                } else if info?.mobileStatus == 0 { // 运营商 失效
                    
                    let text = "运行商认证六个月认证一次，认证完成后才可进行借款操作"
                    let notiV = getNibNotiView(logo: #imageLiteral(resourceName: "operator_popup"), title: "运营商认证已过期", desc: text)
                    
                    // 去认证
                    notiV.actionBtn(block: { 
                        dict["class"] = NSStringFromClass(GTAuthCenterViewController.classForCoder())
                        GTAdapt.push(dict)
                    })
                    
                    GKCover.translucentWindowCenterContent(notiV, animated: true, notClick: false)
                    return
                }
            }
        }
    }
    
    class func test(vc:UIView) {
        
        let nib = Bundle.main.loadNibNamed("GTNotiView", owner: nil, options: nil)
        let nv = nib?.first as? GTNotiView
        nv?.descLab?.text = "的说法哈可视电话反馈的发挥空间的合法开始的发挥的开发和短款礼服啊煽风点火离开"
        GKCover.translucentWindowCenterContent(nv!, animated: true, notClick: false)
    }
}
//  私有方法
extension GTCheck {
    
    // 通知视图
    fileprivate class func getNibNotiView(logo:UIImage?,title:String,desc:String) -> GTNotiView {
        
        let nib = Bundle.main.loadNibNamed("GTNotiView", owner: nil, options: nil)
        let noti = nib?.first as? GTNotiView ?? GTNotiView(frame: CGRect())
        
        noti.titleLab?.text = title
        noti.descLab?.text = desc
        noti.logoImgV?.image = logo
        return noti
    }
    
    // 更新视图
    fileprivate class func getNibUpdateView(logo:UIImage?,title:String,desc:NSAttributedString) -> GTUpdateView {
        
        let nib = Bundle.main.loadNibNamed("GTUpdateView", owner: nil, options: nil)
        let noti = nib?.first as? GTUpdateView ?? GTUpdateView(frame: CGRect())
        
        noti.titleLab?.text = title
        noti.descLab?.attributedText = desc
        return noti
    }
    
}
