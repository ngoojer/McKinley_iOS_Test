//
//  WebViewController.swift
//  McKinleyTest
//
//  Created by Narendra on 17/03/20.
//  Copyright © 2020 Narendra. All rights reserved.
//


import UIKit
import WebKit
import KRProgressHUD

class WebViewController: UIViewController {
    static let storybordId  = "WebViewController"
    
    @IBOutlet weak var webView: WKWebView!
    var token:String
    
    init?(coder: NSCoder, token: String) {
        self.token = token
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a token dependency.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.setupWebView()
    }
    
    private func setupWebView(){
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        
        if let url = URL(string: "https://mckinleyrice.com?token=\(token)"){
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            title = webView.title
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action ) in
            self.logoutUser()
        }
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func logoutUser(){
        UserDefaults.standard.setValue(nil, forKey: Constants.token)
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension WebViewController:WKUIDelegate,WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        KRProgressHUD.showError(withMessage: "Web page could not be loaded")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        KRProgressHUD.show()
        
    }
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error){
        KRProgressHUD.showError(withMessage: "Web page loading failed.")
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        KRProgressHUD.dismiss()
    }
    
}
