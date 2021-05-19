//
//  GTUpdateView.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/7/20.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit

class GTUpdateView: UIView {
    
    
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var descLab: UITextView!
    @IBOutlet weak var titleLab: UILabel!
    private var actionBlcok:(()->())?
    
    override func awakeFromNib() {
        
        // 执行点击
        btn?.rac_signal(for: .touchUpInside).subscribeNext({ [weak self] (btn) in
            
            if self?.actionBlcok != nil {
                self?.actionBlcok!()
            }
        })
    }
    
    // 点击
    func actionBtn(block:@escaping ()->Void) {
        actionBlcok = block
    }
    
}
