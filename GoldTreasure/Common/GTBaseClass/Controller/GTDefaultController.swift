//
//  GTDefaultController.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/8/4.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit

@objc (GTDefaultController)
class GTDefaultController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        GTHUD.showError(title: "未找到相应的页面")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
