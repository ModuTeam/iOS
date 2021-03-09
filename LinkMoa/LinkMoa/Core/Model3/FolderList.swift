//
//  FolderList.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation

///폴더조회(나의 가리비)
struct FolderList: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [Result]?
    
    struct Result: Codable, Equatable {
        let index: Int
        let name: String
        let linkCount: Int
        let folderType: String
        
        static func == (lhs: Result, rhs: Result) -> Bool {
            return lhs.index == rhs.index
        }
        
        enum CodingKeys: String, CodingKey {
            case index = "folderIdx"
            case name = "folderName"
            case linkCount = "folderLinkCount"
            case folderType
        }
    }
}
