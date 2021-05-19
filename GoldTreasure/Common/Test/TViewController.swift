//
//  ViewController.swift
//  Test
//
//  Created by ZZN on 2017/7/2.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit
import ObjectiveC
import SwiftyJSON

class TViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    
    var sdk:LLPaySdk?
//    lazy var engine:UDIDSafeAuthEngine = {
//        return UDIDSafeAuthEngine()
//    }()
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        sdk = LLPaySdk.shared()
//        sdk?.sdkDelegate = self
//        let nib = Bundle.main.loadNibNamed("GTNotiView", owner: nil, options: nil)
//        let nv = nib?.first as? GTNotiView
//        view.addSubview(nv!)
//
//        btn.addTarget(self, action: #selector(startNet), for: UIControlEvents.touchUpInside)
//        view.addSubview(nview)
    }
    
    
//    func startNet() {
//        
//        let dict = [
//            "interId":"tob.quickPayMent",
//            "ver":"1000",
//            "companyId":"11",
//
//            "order_no":"20170630175415257140162791012521",
//            "type":"2",
//            "payType":"2",
//            "idNo":"420621199205207755",
//            "pay_money":"3000",
//            "latefee":"100",
//        ] as [String : Any]

        // 支付宝
//        let newDict = NSDictionary.init(dictionary: dict);
//        AlipaySDK.defaultService().payOrder(JSON.init(dict).string, fromScheme: "GoldTreasure") { (res) in
//            
//            print(res)
//            print(res)
//            
//        }
        // 连连
//        GTApi<GTResModelUserInfo>.requestParams(newDict as! [AnyHashable : Any],
//                                                andResmodel: GTResModelUserInfo(), andAuthStatus: nil).subscribeNext({ (res) in
//            
//                                                    
//                                                    // 目录
//                                                    debugPrint(res)
//                                                    debugPrint(res)
//                                                    
//        }, completed: { (err) in
//            
//            // 完成
//            debugPrint(err)
//        })
        
        //
//        sdk!.present(in: self, with: LLPayType.quick, andTraderInfo: newDict as! [AnyHashable : Any]);
//        sdk!.presentLLPaySign(in: self, with: LLPayType.quick, andTraderInfo: dict)÷        
//        LLPaySdk.shared().present(in: <#T##UIViewController!#>, with: <#T##LLPayType#>, andTraderInfo: <#T##[AnyHashable : Any]!#>)
    }
    
//    func startScan() {
//        
//        engine.delegate = self
//        engine.authKey = "25ae8dc6-e7ca-42cc-9e3c-d830078245fd"
//        engine.notificationUrl = ""
//        engine.showInfo = true
//        engine.outOrderId = "20170983088477676387"
//        
//        engine.startIdSafe(withUserName: "", identityNumber: "", in: self);
//        
//    }
//}

//extension TViewController:UDIDSafeAuthDelegate,LLPaySdkDelegate {
//    
//    // swift 
//    func idSafeAuthFinished(withResult result: Int, userInfo: Any!) {
//    
//        guard let info = userInfo else {
//            return
//        }
//        print(info)
//    }
//    //
//    func paymentEnd(_ resultCode: LLPayResult, withResultDic dic: [AnyHashable : Any]!) {
//        
//        //
//        debugPrint(dic)
//    }
//    
//}

