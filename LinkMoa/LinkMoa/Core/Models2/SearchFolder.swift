//
//  SearchFolder.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/10.
//

import Foundation

struct SearchFolder: Codable {
    let isSuccess: Bool
    let code, userIndex: Int
    let message: String
    let result: [Result]
    
    enum CodingKeys: String, CodingKey {
        case isSuccess, code
        case userIndex = "userIdx"
        case message, result
    }
    
    struct Result: Codable {
        let folderIndex, folderLinkCount, userIndex, categoryIndex: Int
        let categoryName: String
        let detailCategoryIndex: Int
        let detailCategoryName, folderName, folderType: String
        let likeFolderCount: Int
        let linkImageURL: String
        let likeStatus: Int
        
        enum CodingKeys: String, CodingKey {
            case folderIndex = "folderIdx"
            case folderLinkCount
            case userIndex = "userIdx"
            case categoryIndex = "categoryIdx"
            case categoryName
            case detailCategoryIndex = "detailCategoryIdx"
            case detailCategoryName, folderName, folderType, likeFolderCount
            case linkImageURL = "linkImageUrl"
            case likeStatus
        }
    }
    
}
