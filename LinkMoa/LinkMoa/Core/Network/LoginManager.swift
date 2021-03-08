//
//  LoginManager.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/08.
//

import Foundation
import Moya

protocol LoginNetworkable {
    var provider: MoyaProvider<LoginApi> { get }

    func appleLogin(authCode code: String, completion: @escaping (Result<AppleLogin.Response, Error>) -> ())
}

struct LoginManager: LoginNetworkable {
    
    var provider: MoyaProvider<LoginApi> = MoyaProvider<LoginApi>(plugins: [NetworkLoggerPlugin()])
    
    func appleLogin(authCode code: String, completion: @escaping (Result<AppleLogin.Response, Error>) -> ()) {
        request(target: .appleLogin(authCode: code), completion: completion)
    }
}

private extension LoginManager {
    private func request<T: Decodable>(target: LoginApi, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    print(String(data: response.data, encoding: .utf8))

                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    // for test
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

struct AppleLogin: Codable {
    struct Requests: Codable {}
    
    struct Response: Codable {
        let isSuccess: Bool
        let code: Int
        let message: String
        let result: Result?
    }
    
    struct Result: Codable {
        let jwt: String
        let userIdx: Int
        let member: String
    }
}
