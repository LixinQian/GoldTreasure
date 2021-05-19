//
//  QMTabbarController.swift
//  QianmiQB
//
//  Created by lemac on 2017/3/14.
//  Copyright © 2017年 Qianmi Network. All rights reserved.
//

import UIKit
//import RTRootNavigationController

class GTRootTabbarVC: UITabBarController {
    
    //入口
    static let shareInstance:GTRootTabbarVC = {
        
        let instance = GTRootTabbarVC()
        instance.initContent()
        return instance
    }()
    
    //私有化实例
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initContent()
    }
    
    //初始化视图
    func initContent() {
        
        let home = GTHomePageController()
        let mine = GTMineViewController()
        let pay  = PaybackViewController()

        let homeNav = GTRootNavVC(rootViewController: home)
        let payNav = GTRootNavVC(rootViewController: pay)
        let mineNav = GTRootNavVC(rootViewController: mine)

        
        let navList = [homeNav,payNav,mineNav]
        viewControllers = navList

        let titleList = ["借款","还款","个人中心"]
        let norImgNameList = ["icon_jiekuan_off","icon_huankuan_off","icon_my_off"]
        let selImgNameList = ["icon_jiekuan_on","icon_huankuan_on","icon_my_on"]
        
        
        for (index,item) in navList.enumerated() {
            
            item.tabBarItem.title = titleList[index]
            item.tabBarItem.image = UIImage(named: norImgNameList[index])
            let selectImage = UIImage(named: selImgNameList[index])
            
            item.tabBarItem.selectedImage = selectImage?.withRenderingMode(.alwaysOriginal)
            
            // 更改tabbar字体颜色
            item.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:GTColor.gtColorC6()], for: UIControlState.normal)
            item.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:GTColor.gtColorC4()], for: UIControlState.selected)
            // 更改背景颜色
//            item.tabBarController?.tabBar.backgroundColor = UIColor.white
            item.tabBarController?.tabBar.isTranslucent = true
        }
    }
}

