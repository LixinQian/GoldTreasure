//
//  GTHUD.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/6/29.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit
import SVProgressHUD

class GTHUD: NSObject {
    
    /// 根据数组创建可选列表 sheet
    ///
    /// - Parameters:
    ///   - titleList: [title]
    ///   - sel: 选择index
    /// - Returns: 返回alert
    class func getSheetView(titleList:[String],sel:@escaping (_ index:Int)->Void) -> UIAlertController {
        
        let vc = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        for (i,item) in titleList.enumerated() {
            
            let alert = UIAlertAction.init(title: item, style: UIAlertActionStyle.default) { (alert) in
                sel(i)
            }
            vc.addAction(alert)
        }
        
        let cancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (alert) in
            
        }
        
        cancel.setValue(GTColor.gtColorC6(), forKey: "titleTextColor")
        
        vc.addAction(cancel)
        return vc
    }
    
    /// 根据数组创建可选列表 alert
    ///
    /// - Parameters:
    ///   - content: 文本内容
    ///   - trueTitle: 确定按钮文字
    ///   - cancelTitle: 取消按钮文字
    /// - Returns: 返回alert
    class func showAlert(content:String?,trueTitle:String?,cancelTitle:String?,trueCol:(()->Void)?, cancelCol:(()->Void)?) {
        
        let vc = UIAlertController.init(title: nil, message: content, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: cancelTitle ?? "取消", style: .cancel) { (alert) in
            if cancelCol != nil {
                cancelCol!()
            }
        }
        let sure = UIAlertAction.init(title: trueTitle ?? "确定", style: .default ) { (alert) in
            if trueCol != nil {
                trueCol!()
            }
        }
        if trueTitle != nil {
            vc.addAction(sure)
        }
        if cancelTitle != nil {
            vc.addAction(cancel)
        }
        
        
        cancel.setValue(GTColor.gtColorC6(), forKey: "titleTextColor")
        sure.setValue(GTColor.gtColorC1(), forKey: "titleTextColor")
        
        
        currentNav().present(vc, animated: true, completion: nil)
    }
    
    class func showAlert(title:String?,attrDesc:NSAttributedString?,trueTitle:String?,cancelTitle:String?,trueCol:(()->Void)?, cancelCol:(()->Void)?)  {
        
        let content = attrDesc?.string ?? "提示"
        let vc = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancelTitle ?? "取消", style: .cancel) { (alert) in
            if cancelCol != nil {
                cancelCol!()
            }
        }
        let sure = UIAlertAction.init(title: trueTitle ?? "确定", style: .default ) { (alert) in
            if trueCol != nil {
                trueCol!()
            }
        }
        if trueTitle != nil {
            vc.addAction(sure)
        }
        if cancelTitle != nil {
            vc.addAction(cancel)
        }
        // 设置颜色
        cancel.setValue(GTColor.gtColorC6(), forKey: "titleTextColor")
        sure.setValue(GTColor.gtColorC1(), forKey: "titleTextColor")
        // 设置富文本
        vc.setValue(attrDesc, forKey: "attributedMessage")
        currentNav().present(vc, animated: true, completion: nil)
    }
    
    
    /// 显示弹窗 和 OK
    ///
    /// - Parameters:
    ///   - title: 显示标题 可为nil
    ///   - desc: 内容
    class func showAlert(title:String?,desc:String) {
        
        let vc = UIAlertController.init(title: title, message: desc, preferredStyle: .alert)
        let btn = UIAlertAction.init(title: "好的", style: .default) { (alert) in
            
        }
        
        vc.addAction(btn)
        currentNav().present(vc, animated: true, completion: nil)
    }
    
    
    /// 只显示弹窗（富文本） 和 OK
    ///
    /// - Parameters:
    ///   - title: 显示标题 可为nil
    ///   - desc: 内容
    class func showAlert(title:String?,attrDesc:NSMutableAttributedString) {
        
        let vc = UIAlertController.init(title: title, message: "", preferredStyle: .alert)
        let btn = UIAlertAction.init(title: "好的", style: .default) { (alert) in
            
        }
        
        // 设置富文本
        vc.setValue(attrDesc, forKey: "attributedMessage")
        vc.addAction(btn)
        currentNav().present(vc, animated: true, completion: nil)
    }
    
}
// toast 弹出框
extension GTHUD {
    
    
    /// 提示 带有 提示图标
    ///
    /// - Parameter text: 显示文本
    class func showToast(info:String) {
        
        setSvprogressHUD()
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.showInfo(withStatus: info)
    }
    
    /// 显示toast 纯文字
    ///
    /// - Parameter text: 显示文本
    class func showToast(text:String) {
        
        let hud = MBProgressHUD.showAdded(to: currentNav().view, animated: true);
        showDefaultHUD(hud: hud, title: text)
        hud.mode = .text
        hud.minSize = CGSize.init(width: 60, height: 40)
        hud.backgroundView.color = .clear
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
    
    
    /// 显示 进度条
    ///
    /// - Parameter pro: 0.xx
    class func showProgress(pro:Float) {
        
        OperationQueue.main.addOperation {
            
            setSvprogressHUD()
            let prostr = (pro*100).toString() + "%"
            SVProgressHUD.showProgress(pro, status: prostr)
        }
        
    }
    
    /// 显示等待状态 默认 系统菊花，text 可选
    ///
    /// - Parameter str: 文本
    class func showStatus(title:String?) {
        
        OperationQueue.main.addOperation {
            
            setSvprogressHUD()
            SVProgressHUD.dismiss(withDelay: 40)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show(withStatus: title)
        }
    }
    
    /// 消失
    class func dismiss() {
        
        OperationQueue.main.addOperation {
            SVProgressHUD.dismiss()
        }
    }
    
    // 设置默认样式
    fileprivate class func setSvprogressHUD() {
        
        SVProgressHUD.setCornerRadius(5)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setMinimumSize(CGSize.init(width: 80, height: 60))
        SVProgressHUD.setMaximumDismissTimeInterval(1.5)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 12))
        
    }
    
    /// 成功
    ///
    /// - Parameter title: title
    class func showSuccess(title:String) {
        
        setSvprogressHUD()
        SVProgressHUD.setMaximumDismissTimeInterval(1.5)
        SVProgressHUD.showSuccess(withStatus: title)
    }
    /// 失败
    ///
    /// - Parameter title: title
    class func showError(title:String) {
        
        OperationQueue.main.addOperation {
            setSvprogressHUD()
            SVProgressHUD.setMaximumDismissTimeInterval(1.5)
            SVProgressHUD.showError(withStatus: title)
        }
    }
    
    /// 显示黑色遮照
    ///
    /// - Parameter title: title
    class func showMaskStatus(title:String?) {
        
        
        OperationQueue.main.addOperation {
            setSvprogressHUD()
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show(withStatus: title)
        }
    }
    
    /// MBPROGRESS view 中加入 HUD
    ///
    /// - Parameters:
    ///   - view: 要加入的视图
    ///   - title: 标题
    ///   - block: 操作的block
    class func showMaskStatus(view:UIView,title:String,block:((MBProgressHUD)->Void)?) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true);
        showDefaultHUD(hud: hud, title: title)
        if block != nil {
            block!(hud)
        }
    }
    // 设置默认样式
    fileprivate class func showDefaultHUD(hud:MBProgressHUD,title:String){
        
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = title
        hud.animationType = MBProgressHUDAnimation.zoom
        hud.bezelView.alpha = 0.8
        hud.contentColor = UIColor.white
        hud.bezelView.style = MBProgressHUDBackgroundStyle.blur
        hud.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.backgroundView.color = UIColor.init(white: 0, alpha: 0.5)
        
        hud.minSize = CGSize.init(width: 80, height: 80)
        
        hud.bezelView.color = UIColor.black
        hud.label.font = UIFont.systemFont(ofSize: 12)
        hud.margin = 5
    }
    
}

extension GTHUD {
    
    /// 当前控制器
    ///
    /// - Returns: nav
    class func currentNav() -> UINavigationController  {
        
        let nav_default = UINavigationController()
        guard let tab = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else { return nav_default}
        
        let selindex = tab.selectedIndex
        
        guard let nav = tab.viewControllers?[selindex] as? UINavigationController else {
            
            return UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        }
        return nav
        
    }
    
    // 获取根控制器
    class func rootNav() -> UINavigationController  {
        
        let nav = currentNav()
        nav.popToRootViewController(animated: false)
        return nav
    }
    
    // 获取当前控制器上一级
    class func upCurrentNav() -> UINavigationController  {
        
        currentNav().popViewController(animated: false)
        return currentNav()
    }
}
