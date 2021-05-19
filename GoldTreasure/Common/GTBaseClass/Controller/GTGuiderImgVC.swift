//
//  VC.swift
//  bibao
//
//  Created by Zhongnan on 16/3/2.
//  Copyright © 2016年 Zhongnan. All rights reserved.
//

import UIKit


class GTGuiderImgVC: UIViewController,UIScrollViewDelegate {
    
    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    var startBtn:UIButton!
    
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    
    // 结束
    var tapEndBlock:(()->Void)?
    //图片数量
    var guidePicArr = [String]() {
        
        didSet{
            
            loadCustomLayout()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
//        view.backgroundColor = LDGolbalColor.BgGoundGray
    }
    
    //scrollview委托
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset=scrollView.contentOffset
        
        pageControl.currentPage=Int(offset.x/screenW)
        if(pageControl.currentPage == guidePicArr.count-1){
            
            startBtn.isHidden=false
        }else{
            
            startBtn.isHidden=true
        }
    }
    //载入自定义布局
    func loadCustomLayout(){
        
        
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        scrollView.isPagingEnabled=true
        scrollView.showsHorizontalScrollIndicator=false
        scrollView.showsVerticalScrollIndicator=false
        scrollView.contentSize=CGSize(width:CGFloat(guidePicArr.count) * screenW,height:screenH)

        for i in 1...guidePicArr.count{
            
            let strname = guidePicArr[i-1]
            let image=UIImage(named: strname)
            let imageView=UIImageView(image: image)
            
            imageView.frame=CGRect(x:CGFloat(i-1)*screenW, y:0, width:screenW, height:screenH)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            scrollView.addSubview(imageView)
            
        }
        
        
        pageControl=UIPageControl(frame: CGRect(x:screenW/2-100, y:screenH-GTSize.getScaleH(40), width:200, height:40))
        
        pageControl.currentPageIndicatorTintColor = GTColor.gtColorC1()
        pageControl.pageIndicatorTintColor = UIColor.gray
        
        
        startBtn=UIButton(frame: CGRect(x:screenW/2-60, y:screenH-GTSize.getScaleH(300), width:screenW, height:GTSize.getScaleH(300)))
        startBtn.center.x = self.view.center.x
        
        pageControl.numberOfPages=guidePicArr.count;
        pageControl.currentPage=0

//        startBtn.setBackgroundImage(UIImage(named: "welcome_enter"), for: UIControlState.normal)
//        startBtn.setTitle("点击进入", for: UIControlState.normal)
//        startBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        startBtn.setTitleColor(GTColor.gtColorC1(), for: UIControlState.normal)
        
//        startBtn.layer.borderColor = GTColor.gtColorC1().cgColor
//        startBtn.layer.borderWidth = 1
//        
//        startBtn.layer.cornerRadius = 3
//        startBtn.layer.masksToBounds = true

        startBtn.addTarget(self, action: #selector(self.guideOver), for: UIControlEvents.touchUpInside)
        startBtn.isHidden=true
        
        
        scrollView.bounces=false
        scrollView.delegate=self
        self.view.addSubview(scrollView)
        self.view.addSubview(pageControl)
        self.view.addSubview(startBtn)
        
    }
    
    //开始使用app
    func guideOver(){
        //点击按钮发送加载完成通知
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIGUIDERIMGVIEWEND), object: nil)
        
        if tapEndBlock != nil {
            tapEndBlock!()
            GTUser.setIsShowGuider(isOk: false)
        }
        UIApplication.shared.isStatusBarHidden  = false
    }
    
    
}
