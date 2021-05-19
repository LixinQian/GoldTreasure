//
//  GTLoginRoot.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/7/7.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit

class GTLoginRoot: UINavigationController {
    
//    var rootVC:GTLoginController?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init() {
        //初始化 登录模块
        let vc = GTLoginController()
        super.init(rootViewController: vc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
