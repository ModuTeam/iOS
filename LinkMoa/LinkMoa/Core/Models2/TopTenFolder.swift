//
//  TopTen.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/10.
//

import Foundation

struct TopTenFolder: Codable {
    let isSuccess: Bool
    let code: Int
    let userIndex: Int
    let message: String
    let result: [Result]
    
    enum CodingKeys: String, CodingKey {
        case userIndex = "userIdx"
        case isSuccess, code, message, result
    }
    
    struct Result: Codable {
        let folderIndex, userIndex, categoryIndex: Int
        let categoryName: String
        let detailCategoryIndex: Int
        let detailCategoryName, folderName, folderType: String
        let folderLinkCount, likeFolderCount: Int
        let linkImageURL: String?
        let likeStatus: Int

        enum CodingKeys: String, CodingKey {
            case folderIndex = "folderIdx"
            case userIndex = "userIdx"
            case categoryIndex = "categoryIdx"
            case detailCategoryIndex = "detailCategoryIdx"
            case categoryName, detailCategoryName, folderName, folderType, folderLinkCount, likeFolderCount
            case linkImageURL = "linkImageUrl"
            case likeStatus
        }
    }
}
