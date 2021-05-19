//
//  QMUIStandardDefine.swift
//  QianmiQB
//
//  Created by lemac on 2017/3/14.
//  Copyright © 2017年 Qianmi Network. All rights reserved.
//

import UIKit

/** 全局frame,bounds属性*/
struct GTFrame {
    
    
    struct Screen {
    
        static let NavH: CGFloat = 64;
        static let TabbarH: CGFloat = 49;
        static let StatusbarH: CGFloat = 20;
        static let Width: CGFloat = UIScreen.main.bounds.width
        static let Height: CGFloat = UIScreen.main.bounds.size.height
        static let Bounds: CGRect = UIScreen.main.bounds
        
    }
    struct UI {
        
        static let TopPadding:CGFloat = 10
        static let LeftPadding:CGFloat = 18
        static let RightPadding:CGFloat = 18
        static let BottomPadding:CGFloat = 10
        
    }
    
    //
    static let AttrLineH:CGFloat = 8
    
    static func currentNavH(vc:UIViewController) -> CGFloat {
        
        if vc.navigationController != nil {
            
            return GTFrame.Screen.NavH
        } else {
            
            return 0
        }
    }
}

// 静态变量
class GTUIDefine:NSObject {
    
     public static let SCREEN_WIDTH = UIScreen.main.bounds.width
     public static let SCREEN_HEIGHT = UIScreen.main.bounds.height
}






