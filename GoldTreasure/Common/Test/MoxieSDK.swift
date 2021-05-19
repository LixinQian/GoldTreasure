//
//  TAuthViewController.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/7/2.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

//import UIKit

//class TAuthViewController: UIViewController {

    
//    var userID = "201706306764"
//    var apiKey = "251c21a0-7ab6-4654-9606-0bd70f65f3cb"
//    var titleList = ["运营商"]
//    var typeList = ["carrier"]
//    var tableView = UITableView.init()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        initUI()
//        configure()
//    }
    
    // 初始化
//    func initUI() {
    
//        tableView.frame = view.frame
//        tableView.delegate = self
//        tableView.dataSource = self
//    
//        tableView.rowHeight = 80
//        view.addSubview(tableView)
        
//    }
//    /***必须配置的基本参数*/
//    func configure() {
//    
//        MoxieSDK.shared().delegate = self
//        MoxieSDK.shared().mxUserId = userID
//        MoxieSDK.shared().mxApiKey = apiKey
//        MoxieSDK.shared().fromController = self
//        MoxieSDK.shared().hideRightButton = true
//        MoxieSDK.shared().useNavigationPush = false
//        
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        MoxieSDK.shared().taskType = typeList[0]
//        MoxieSDK.shared().startFunction()
//    }
//}

//extension TAuthViewController:MoxieSDKDelegate {
//    
//    //
//    func receiveMoxieSDKResult(_ resultDictionary: [AnyHashable : Any]!) {
//        
//        print(resultDictionary)
//    }
//}
//
//extension TAuthViewController:UITableViewDataSource,UITableViewDelegate {
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return titleList.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//     
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
//        if cell == nil {
//            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "cellID")
//        }
//        cell?.textLabel?.text = titleList[indexPath.row]
//        return cell!;
//    }
//}
