//
//  Like.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation

struct Like: Codable {
 
    struct Response: Codable {
        let isSuccess: Bool
        let code: Int
        let userIndex: String
        let message: String
   
        enum CodingKeys: String, CodingKey {
            case isSuccess, code, message
            case userIndex = "userIdx"
            
        }
    }
    
}
