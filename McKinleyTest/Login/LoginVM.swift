//
//  LoginVM.swift
//  McKinleyTest
//
//  Created by Narendra on 17/03/20.
//  Copyright © 2020 Narendra. All rights reserved.
//

import UIKit
import Combine

enum LoginStates{
    case success(_token:String)
    case failure(_ errorMessage: String)
}

class LoginVM {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    private(set) var apiClient : APIClient
    var loginHandler : (LoginStates) -> Void = {_ in}
    
    init(apiClient:APIClient) {
        self.apiClient = apiClient
    }
    
    
    func validateCredential() -> Bool {
        print("email = \(email)")
        guard self.email.count > 0 else {
            self.loginHandler(.failure("Enter email address."))
            return false
        }
        guard self.validEmail == true else {
            self.loginHandler(.failure("Invalid email address."))
            return false
        }
        guard self.password.count > 0 else {
            self.loginHandler(.failure("Enter password."))
            return false
        }
        return true
    }
    
    func loginUser() {
        let loginModel = LoginRequestModel(email: email, password: password)
        self.apiClient.loginRequest(login:loginModel) { [weak self] (result) in
            switch result{
            case .success(let response):
                UserDefaults.standard.setValue(response.token, forKey: Constants.token)
                self?.loginHandler(.success(_token: response.token))
            case .failure(let error):
                self?.loginHandler(.failure(error.localizedDescription))
                
            }
        }
    }
}


extension LoginVM{
    var validEmail:Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self.email)
    }
}
