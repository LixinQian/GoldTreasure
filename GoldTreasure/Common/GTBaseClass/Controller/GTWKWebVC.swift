//
//  QMBaseWKWebVC.swift
//  QianmiQB
//
//  Created by zzn on 2017/4/19.
//  Copyright © 2017年 Qianmi Network. All rights reserved.
//

import UIKit
import WebKit
import ObjectiveC
import Masonry

@objc class GTWKWebVC: UIViewController {
    
    // js 操作模型
    final let jsModelName = "GTWEBKVC"
    // url 地址
    var url:String? {
        didSet{
            
            guard let newV = url else { return }
            webView?.load(URLRequest(url: URL(string: newV)!))
        }
    }
    var backItem:UIBarButtonItem?
    var closeItem:UIBarButtonItem?
    var leftItems:NSMutableArray?
    var webView:WKWebView?
    /// 进度条
    var progressView:UIProgressView?
    
    override func viewDidLoad() {
        
        setupView()
        initData()
        
    }
    
    //  初始化URL
    init(urlStr:String) {
        super.init(nibName: nil, bundle: nil)
        url = urlStr
        hidesBottomBarWhenPushed = true
    }
    
    // 视图显示
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        progressView?.removeFromSuperview()
        
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData() {
        
        guard let url = URL(string: url ?? "") else { return }
        
        let req = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 5)
        webView!.load(req)
        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:UIFont.systemFont(ofSize: 14)]
//        
        
//        self.rt_navigationController.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:UIFont.systemFont(ofSize: 14)]
        // 监听进度条
        rac_observeKeyPath("webView.estimatedProgress", options: .new, observer: self) { [weak self]
            (value, info, x, y) in
            
            guard let progress = value else { return }
            debugPrint(progress)
            self?.progressView?.progress = progress as? Float ?? 0
            
        }
//        // 监听URL改变
//        rac_observeKeyPath("url", options: .init(rawValue: 0), observer: self) { [weak self](value, info, x, y) in
//            
//            guard let newV = value as? String else { return }
//            
//            self?.webView?.load(URLRequest(url: URL(string: newV)!))
////            self?.webView?.reload()
//            
//        }
        
//        rx.observe(Float.self, "webView.estimatedProgress").subscribe(onNext: { [weak self] (pro) in
//            
//            guard let progress = pro else { return }
//            debugPrint(progress)
//            self?.progressView?.progress = progress
//        }, onError: { (error) in
//        }).disposed(by: disposeTag)
    }

    deinit {
        // 销毁
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: jsModelName)
        progressView?.removeFromSuperview()
    }
    
    func setupView() {
    
        //webview
        let configure = WKWebViewConfiguration()
        configure.allowsInlineMediaPlayback = true
        configure.userContentController = WKUserContentController()
        configure.userContentController.add(self, name: jsModelName)
        
        webView = WKWebView.init(frame: view.frame , configuration: configure)
        webView?.allowsBackForwardNavigationGestures = true
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        view.addSubview(webView!)
        
//        webView?.snp.makeConstraints({ (make) in
//            make.top.left.equalTo(0)
//            make.bottom.right.equalTo(0)
//        })
        
        
//        webView?.mas_makeConstraints({ (make) in
//            make?.bottom.equalTo()
//        })
//        webView
        
        //progressview
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        progressView!.frame = CGRect(x:0, y:GTFrame.Screen.NavH - 1, width:GTFrame.Screen.Width, height:1);
        progressView?.tintColor = UIColor.blue
        navigationController?.view.addSubview(progressView!)
        
        
        
        backItem = UIBarButtonItem.init(image: UIImage(named: ""), style: .done, target: self, action: #selector(self.back))
            
        
        closeItem = UIBarButtonItem.init(title: "关闭", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.pop))
        closeItem?.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -10, vertical: 0), for: UIBarMetrics.compact)
        
        //backlogo
        //        backItem = UIBarButtonItem().bk_init(with: R.image.nav_back(), style: .done) { [weak self](obj) in
        //
        //
        //            if self?.webView?.canGoBack == true {
        //                self?.webView?.goBack()
        //            } else {
        //                self?.navigationController?.popViewController(animated: true)
        //            }
        //            
        //            } as?UIBarButtonItem
        //        bk_init(withTitle: "关闭 ", style: UIBarButtonItemStyle.done, handler: {[weak self] (obj) in
        //
        //            self?.navigationController?.popViewController(animated: true)
        //        })as? UIBarButtonItem
        //closeitem
        //        closeItem = UIBarButtonItem().bk_initWithImage(UIImage(named: "close_item"), style: .Done) { [weak self](obj) in
        //
        //            self?.navigationController?.popViewControllerAnimated(true)
        //        } as?UIBarButtonItem
    }
    
    // pop
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    //  back
    func back() {
        
        if webView?.canGoBack == true {
            webView?.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
extension GTWKWebVC:WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //window.webkit.messageHandlers.DPLUS.postMessage({body:message});
        if message.name == "QMWKVC" {
            //根据传递的 dict判断
            _ = message.body as? NSDictionary
        }
    }
    
    
    //开始
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView?.isHidden = false;
        title = "加载中..."
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    //完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        progressView?.isHidden = true
        title = webView.title
        
//        if webView.canGoBack {
//            
//            navigationItem.leftBarButtonItems = [backItem!,closeItem!]
//            rt_navigationController?.interactivePopGestureRecognizer!.isEnabled = false;
//        } else {
//            navigationItem.leftBarButtonItems = [backItem!]
//            rt_navigationController?.interactivePopGestureRecognizer!.isEnabled = true;
//        }
    }
    //加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        GTHUD.showError(title: "连接错误")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
