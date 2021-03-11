//
//  LoginVC.swift
//  McKinleyTest
//
//  Created by Narendra on 17/03/20.
//  Copyright © 2020 Narendra. All rights reserved.
//

import UIKit
import Combine
import KRProgressHUD

class LoginVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblTerms: UILabel!
    
    lazy var viewModel : LoginVM = LoginVM(apiClient: APIClient())
    
    //var keyboardSubscription: AnyCancellable?
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGesture()
        self.initBinding()
        self.handleKeyboardFrame()
        self.checkLoginSession()
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        UIApplication.shared.statusBarUIView?.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        self.txtEmail.text = "eve.holt@reqres.in"
        self.view.backgroundColor = .yellow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    private func checkLoginSession(){
        let token = UserDefaults.standard.value(forKey: Constants.token) as? String ?? ""
        if token.count > 0{
            self.showWebView(token: token)
        }
    }
    
    private func handleKeyboardFrame()  {
        let keyboardWillOpen = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map{$0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect}
            .map{$0.height + 10}
        
        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map{_ in CGFloat(0)}
        
        Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: DispatchQueue.main)
            .assign(to: \UIScrollView.contentInset.bottom, on: self.scrollView)
            .store(in: &cancellables)
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        tap.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func tapOnView(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    private func initBinding() {
        func bindViewToViewModel(){
            self.txtEmail.textPublisher.receive(on: DispatchQueue.main)
                .assign(to: \.email, on: viewModel)
                .store(in: &cancellables)
            
           self.txtPassword.textPublisher.receive(on: DispatchQueue.main)
                .assign(to: \.password, on: viewModel)
                .store(in: &cancellables)

            self.viewModel.loginHandler = {[unowned self] (states) in
                DispatchQueue.main.async {
                    KRProgressHUD.dismiss()
                    switch states {
                    case .success(let token):
                        self.showWebView(token: token)
                    case .failure(let message):
                        self.alert(message: message)
                    }
                }
            }
            
        }
        bindViewToViewModel()
    }
    
    
    @IBAction func actionLogin(_ sender: Any) {
        self.view.endEditing(true)
        guard self.viewModel.validateCredential() else{
            return
        }
        self.makeLoginRequest()
    }
    
    private func makeLoginRequest()  {
        KRProgressHUD.show()
        self.viewModel.loginUser()
    }
    
    private func showWebView(token:String) {
        guard let vc = storyboard?.instantiateViewController(identifier: WebViewController.storybordId, creator: { coder in
            return WebViewController(coder: coder, token:token)
        }) else {
            fatalError("Failed to load WebViewController from storyboard.")
        }
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
}

extension LoginVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
