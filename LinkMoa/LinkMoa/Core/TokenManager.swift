//
//  TokenManager.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/08.
//

import Foundation


public enum TokenType {
    case jwt
    case userIndex
}

extension TokenType {
    var name: String {
        switch self {
        case .jwt:
            return "jwtToken"
        case .userIndex:
            return "userIndex"
        }
    }
}

public struct TokenManager {
    
    init() {
        guard let userDefault = UserDefaults(suiteName: "group.LinkMoa") else { fatalError() }
        self.userDefault = userDefault
    }
    
    private var userDefault: UserDefaults
    
    var jwtToken: String? {
        get {
            return userDefault.string(forKey: TokenType.jwt.name)
        }
        set {
            userDefault.setValue(newValue, forKey: TokenType.jwt.name)
        }
    }
    
    var userIndex: Int? {
        get {
            return Int(userDefault.integer(forKey: TokenType.userIndex.name))
        }
        set {
            userDefault.setValue(newValue, forKey: TokenType.userIndex.name)
        }
    }
}
