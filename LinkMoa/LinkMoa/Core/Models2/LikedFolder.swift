//
//  LikedFolder.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation

struct LikedFolder: Codable {
    struct Response: Codable {
        let isSuccess: Bool
        let code: Int
        let message: String
        let result: [Result]?
    }
    
    struct Result: Codable {
        let userIndex, categoryIndex: Int
        let categoryName: String
        let folderIndex: Int
        let folderName, folderType: String
        let status: Int
        
        enum CodingKeys: String, CodingKey {
            case userIndex = "userIdx"
            case categoryIndex = "categoryIdx"
            case folderIndex = "folderIdx"
            case categoryName, folderName, folderType, status
        }
    }
    
}
