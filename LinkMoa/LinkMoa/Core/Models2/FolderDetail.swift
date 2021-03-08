//
//  FolderDetail.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation

///폴더상세조회
struct FolderDetail: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: Result?
    
    struct Result: Codable {
        let userIndex: Int
        let name, type: String
        let linkCount: Int
        let hashTagList: [HashTag]
        let linkList: [Link]
        
        enum CodingKeys: String, CodingKey {
            case userIndex = "userIdx"
            case name = "folderName"
            case type = "folderType"
            case linkCount = "folderLinkCount"
            case hashTagList
            case linkList
        }
    }
    
    struct HashTag: Codable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name = "tagName"
        }
    }
    
    struct Link: Codable {
        let index: Int
        let name: String
        let url: String
        
        enum CodingKeys: String, CodingKey {
            case index = "linkIdx"
            case name = "linkName"
            case url = "linkUrl"
        }
    }
    
}
