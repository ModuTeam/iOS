//
//  FolderDetail.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation

struct FolderDetail: Codable {
 
    struct Response: Codable {
        let isSuccess: Bool
        let code: Int
        let message: String
        let result: Result?
    }
    
    struct Result: Codable {
        let userIndex: Int
        let name, type: String
        let linkCount: Int
        let hashTagList: [HashTagList]
        let linkList: [LinkList]
        
        enum CodingKeys: String, CodingKey {
            case userIndex = "userIdx"
            case name = "folderName"
            case type = "folderType"
            case linkCount = "folderLinkCount"
            case hashTagList
            case linkList
        }
    }
    
    struct HashTagList: Codable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name = "tagName"
        }
    }
    
    struct LinkList: Codable {
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
