//
//  LoginViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/08.
//

import Foundation

protocol LoginViewModelOutputs {}

protocol LoginViewModelInputs {
    func appleLogin(authCode code: String, handler completionHandler: @escaping (Result<AppleLogin.Response, Error>) -> ())
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

final class LoginViewModel: LoginViewModelOutputs, LoginViewModelInputs, LoginViewModelType {

    init() {
        self.loginManager = LoginManager()
    }
    
    private let loginManager: LoginManager
    
    var inputs: LoginViewModelInputs { return self }
    var outputs: LoginViewModelOutputs { return self }
    
    func appleLogin(authCode code: String, handler completionHandler: @escaping (Result<AppleLogin.Response, Error>) -> ()) {
        loginManager.appleLogin(authCode: code, completion: { result in
            completionHandler(result)
        })
    }
}