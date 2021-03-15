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
        let userIndex, folderIndex: Int
        let name, type: String
        let likeCount, linkCount: Int
        let folderUpdatedAt: String
        let likeStatus: Int
        let hashTagList: [HashTag]
        let linkList: [Link]
        
        enum CodingKeys: String, CodingKey {
            case userIndex = "userIdx"
            case folderIndex = "folderIdx"
            case name = "folderName"
            case type = "folderType"
            case likeCount = "folderLikeCount"
            case linkCount = "folderLinkCount"
            case folderUpdatedAt, likeStatus, hashTagList, linkList
        }
    }
    
    struct HashTag: Codable {
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case name = "tagName"
        }
    }
    
    struct Link: Codable, Equatable {
        let index: Int
        let name: String
        let url: String
        let faviconURL: String
        let updateDate: String
        
        enum CodingKeys: String, CodingKey {
            case index = "linkIdx"
            case name = "linkName"
            case url = "linkUrl"
            case faviconURL = "linkFaviconUrl"
            case updateDate = "linkUpdatedAt"
        }
        
        static func == (lhs: Link, rhs: Link) -> Bool {
            return lhs.index == rhs.index
        }
    }
}
