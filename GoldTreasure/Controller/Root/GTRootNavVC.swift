//
//  QMRTNavVC.swift
//  QianmiQB
//
//  Created by ZZN on 17/4/12.
//  Copyright © 2017年 Qianmi Network. All rights reserved.
//

import UIKit
//import RTRootNavigationController

class GTRootNavVC: UINavigationController {


    var popClosure:((GTRootNavVC)->Void)?
    var pushClosure:((GTRootNavVC)->Void)?
    
     var barLeft:UIBarButtonItem?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navBarTintColor = GTColor.gtColorC2()
        
//        interactivePopGestureRecognizer!.isEnabled = true
//        interactivePopGestureRecognizer!.delegate = self

        //左bar图
        barLeft = UIBarButtonItem(image: UIImage(named:"back"), style: .plain, target: self, action:#selector(self.navBack))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        popClosure = nil
        pushClosure = nil
    }
    
    // new bar
    func createBar() -> UIBarButtonItem {
        
        let bar = UIBarButtonItem(image:UIImage(named: "back") , style: .plain, target: self, action:#selector(self.navBack))
        return bar
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.childViewControllers.count > 0 {
            
            viewController.navigationItem.leftBarButtonItem = createBar()
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
//     拦截手势操作
//    func pushViewController(_ viewController: UIViewController!, animated: Bool, complete block: ((Bool) -> Void)!) {
//        
//        if let vc = viewController as? GTSubmittedSuccessfullyController != nil {
//            
//            viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        }
//    }
    
    
    //拦截pop事件
    func navBack(){
        
        popViewController(animated: true)
    }
}

extension GTRootNavVC:UIGestureRecognizerDelegate {

    override func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        
        //只有一个控制器的时候禁止手势，防止卡死现象
        if (self.childViewControllers.count > 1) {
            
            if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
                interactivePopGestureRecognizer?.isEnabled = true
            }
            
        } else {
            
            if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
                interactivePopGestureRecognizer?.isEnabled = false
            }
        }
        
        return true
    }
    
    
    func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        
        //只有一个控制器的时候禁止手势，防止卡死现象
        if (self.childViewControllers.count == 1) {
            if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
                interactivePopGestureRecognizer?.isEnabled = false
                interactivePopGestureRecognizer?.delegate = nil
            }
        }
    }
}

