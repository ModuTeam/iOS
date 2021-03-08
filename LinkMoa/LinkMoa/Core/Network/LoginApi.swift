//
//  LoginApi.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/08.
//

import Moya

enum LoginApi {
    case appleLogin(authCode: String)
}

extension LoginApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://dev.linkmoa.shop") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .appleLogin(_):
            return "/apple-login"
        }
    }
    
    var method: Method {
        switch self {
        case .appleLogin(_):
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .appleLogin(let authCode):
            return .requestParameters(parameters: ["code" : authCode], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
}

