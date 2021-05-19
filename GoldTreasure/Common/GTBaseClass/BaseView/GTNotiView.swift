//
//  GTNotiView.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/7/12.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit
import Masonry

class GTNotiView: UIView {
    
    
    //    @IBOutlet var backImageV:UIImageView?
    @IBOutlet var logoImgV:UIImageView?
    @IBOutlet var titleLab:UILabel?
    @IBOutlet var descLab:UILabel?
    @IBOutlet var lineV:UIView?
    @IBOutlet var actionBtn:UIButton?
    
    private var actionBlcok:(()->())?
    
    override func awakeFromNib() {
        
        // 执行点击
        actionBtn?.rac_signal(for: .touchUpInside).subscribeNext({ [weak self] (btn) in
            
            if self?.actionBlcok != nil {
                self?.actionBlcok!()
                GKCover.dissmiss()
            }
        })
    }
    
    // 点击
    func actionBtn(block:@escaping ()->Void) {
       actionBlcok = block
    }
    
    // 初始化 视图
    func initView() {
        
        //        // 背景图
        //        backImageV = UIImageView(image: UIImage(named: "NotiPopBG"))
        //        logoImgV = UIImageView(image: UIImage(named: "default_avatar"))
        //        titleLab = UILabel()
        //        titleLab?.text = "支付宝认证一过期"
        //        descLab = UILabel()
        //        descLab?.text = "支付宝需要没爱短发绝代风华库认证一次"
        //
        //        lineV = UIView()
        //        lineV?.backgroundColor = UIColor.red
        //
        //        actionBtn = UIButton()
        //        actionBtn?.backgroundColor = UIColor.brown
    }
    
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
}
