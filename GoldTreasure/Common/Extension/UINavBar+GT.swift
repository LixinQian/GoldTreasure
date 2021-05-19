//
//  UINavBar+GT.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/8/10.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func interactivePopGestureRecognizer(isEnable:Bool?) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = isEnable ?? false
    }
}
