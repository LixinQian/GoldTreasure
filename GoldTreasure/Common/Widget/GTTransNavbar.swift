//
//  GTTransNavbar.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/8/9.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit

extension DispatchQueue {
    
    private static var onceTracker = [String]()
    
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}

extension UINavigationController {
    
    
//    static let instance:String = {
//    
//        return ""
//    }()
    open override func viewDidLoad() {
        self.changeMethod()
        super.viewDidLoad()
    }
    
    fileprivate func changeMethod() {
        
//        let needSwizzleSelectorArr = [
//            NSSelectorFromString("_updateInteractiveTransition:"),
//            #selector(popToViewController),
//            #selector(popToRootViewController)
//        ]
//        
//        for selector in needSwizzleSelectorArr {
//            
//            let newMethodName = ("gt_" + selector.description).replacingOccurrences(of: "__", with: "_")
//            
//            let originalMethod = class_getInstanceMethod(self.classForCoder, selector)
//            let swizzledMethod = class_getInstanceMethod(self.classForCoder, Selector(newMethodName))
//            method_exchangeImplementations(originalMethod, swizzledMethod)
//        }
        
        DispatchQueue.once(token: "com.huanjinbao.thread") {
            
            let needSwizzleSelectorArr = [
                NSSelectorFromString("_updateInteractiveTransition:"),
                #selector(popToViewController),
                #selector(popToRootViewController)
            ]
            
            for selector in needSwizzleSelectorArr {
                
                let newMethodName = ("gt_" + selector.description).replacingOccurrences(of: "__", with: "_")
                
                let originalMethod = class_getInstanceMethod(self.classForCoder, selector)
                let swizzledMethod = class_getInstanceMethod(self.classForCoder, Selector(newMethodName))
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    // 更新 bar bartint 渐变颜色
    func gt_updateInteractiveTransition(_ percentComplete: CGFloat) {
        
        guard let topViewController = topViewController, let coordinator = topViewController.transitionCoordinator else {
            gt_updateInteractiveTransition(percentComplete)
            return
        }
        
        let fromViewController = coordinator.viewController(forKey: .from)
        let toViewController = coordinator.viewController(forKey: .to)
        
        // Bg Alpha
        let fromAlpha = fromViewController?.navBarAlpha ?? 0
        let toAlpha = toViewController?.navBarAlpha ?? 0
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete
        
        setNavbarBackground(alpha: newAlpha)
        
        // Tint Color
        let fromColor = fromViewController?.navBarTintColor ?? .blue
        let toColor = toViewController?.navBarTintColor ?? .blue
        
        let newColor = averageColor(fromColor: fromColor, toColor: toColor, percent: percentComplete)
        navigationBar.barTintColor = newColor
        gt_updateInteractiveTransition(percentComplete)
    }
    
    // 渐变颜色 ex. red->white 过渡
    private func averageColor(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let nowRed = fromRed + (toRed - fromRed) * percent
        let nowGreen = fromGreen + (toGreen - fromGreen) * percent
        let nowBlue = fromBlue + (toBlue - fromBlue) * percent
        let nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
        
        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
    
//    func gt_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
//        
//        setNavbarBackground(alpha: viewController.navBarAlpha)
//        navigationBar.barTintColor = viewController.navBarTintColor
//        return gt_popToViewController(viewController, animated: animated)
//    }
//    
//    func gt_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
//        
//        setNavbarBackground(alpha: viewControllers.first?.navBarAlpha ?? 0)
//        navigationBar.barTintColor = viewControllers.first?.navBarTintColor
//        return gt_popToRootViewControllerAnimated(animated)
//    }
    
    // 设置 背景颜色
    fileprivate func setNavbarBackground(alpha: CGFloat) {
        
        let barBackgroundView = navigationBar.subviews.first
        guard let valueForKey = barBackgroundView?.value(forKey:) else { return }
        guard let shadowView = valueForKey("_shadowView") as? UIView  else { return }
        
        shadowView.alpha = alpha
        shadowView.isHidden = alpha == 0 ? true:false
        
        if navigationBar.isTranslucent {
            
            if #available(iOS 10.0, *) {
                
                if let backgroundEffectView = valueForKey("_backgroundEffectView") as? UIView, navigationBar.backgroundImage(for: .default) == nil {
                    backgroundEffectView.alpha = alpha
                    return
                }
                
            } else {
                
                if let adaptiveBackdrop = valueForKey("_adaptiveBackdrop") as? UIView , let backdropEffectView = adaptiveBackdrop.value(forKey: "_backdropEffectView") as? UIView {
                    backdropEffectView.alpha = alpha
                    return
                }
            }
        }
        
        barBackgroundView?.alpha = alpha
    }
}

// MARK: - navbar delegate
extension UINavigationController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        if let topVC = topViewController, let coor = topVC.transitionCoordinator, coor.initiallyInteractive {
            
            if #available(iOS 10.0, *) {
                coor.notifyWhenInteractionChanges({ (context) in
                    self.dealInteractionChanges(context)
                })
            } else {
                coor.notifyWhenInteractionEnds({ (context) in
                    self.dealInteractionChanges(context)
                })
            }
            
            return true
        }
        
        
        
        guard let itemCount = navigationBar.items?.count else { return false }
        let n = viewControllers.count >= itemCount ? 2 : 1
        
        let popToVC = viewControllers[viewControllers.count - n]
        
        OperationQueue.main.addOperation { [weak self] in
            self?.popToViewController(popToVC, animated: true)
        }
        
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        setNavbarBackground(alpha: topViewController?.navBarAlpha ?? 0)
        navigationBar.barTintColor = topViewController?.navBarTintColor
        return true
    }
    
    // 处理颜色渐变
    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext) {
        

        let animations: (UITransitionContextViewControllerKey) -> () = {
            let nowAlpha = context.viewController(forKey: $0)?.navBarAlpha ?? 0
            self.setNavbarBackground(alpha: nowAlpha)
            
            self.navigationBar.barTintColor = context.viewController(forKey: $0)?.navBarTintColor
        }
        
        if context.isCancelled {
            
            let cancelDuration: TimeInterval = context.transitionDuration * Double(context.percentComplete)
            UIView.animate(withDuration: cancelDuration) {
                animations(.from)
            }
        } else {
            let finishDuration: TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration) {
                animations(.to)
            }
        }
    }
}

extension UIViewController {
    
    @nonobjc static var navBarBgKey = "NAVBARBGKEY"
    @nonobjc static var navBarTintColorKey = "NAVBARTINTCOLORBGKEY"
    @nonobjc static var navTintColorKey = "NAVTINTCOLORBGKEY"
    
    
    /// 根据alpha值判断 bar backgound 是否透明 0 透明 1 不透明
    open var navBarAlpha: CGFloat {
        get {
            guard let alpha = objc_getAssociatedObject(self, &UIViewController.navBarBgKey) as? CGFloat else {
                return 1.0
            }
            return alpha
            
        }
        set {
            let alpha = max(min(newValue, 1), 0) // 必须在 0~1的范围
            objc_setAssociatedObject(self, &UIViewController.navBarBgKey, alpha, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            // Update UI
            navigationController?.setNavbarBackground(alpha: alpha)
        }
    }
    
    /// bar color bar 颜色
    open var navBarTintColor: UIColor {
        get {
            guard let tintColor = objc_getAssociatedObject(self, &UIViewController.navBarTintColorKey) as? UIColor else {
                
                return self.navigationController?.navigationBar.barTintColor ?? UIColor.white
            }
            return tintColor
        }
        set {
            navigationController?.navigationBar.barTintColor = newValue
            objc_setAssociatedObject(self, &UIViewController.navBarTintColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
//    /// bar title color
//    open var navTintColor: UIColor {
//        
//        get {
//            guard let tintColor = objc_getAssociatedObject(self, &UIViewController.navTintColorKey) as? UIColor else {
//                
//                return self.navigationController?.navigationBar.tintColor ?? UIColor.white
//            }
//            return tintColor
//        }
//        
//        set {
//            navigationController?.navigationBar.tintColor = newValue
//            objc_setAssociatedObject(self, &UIViewController.navTintColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
    
    
    
    
}
