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
    
    struct Result: Codable {
        let index: Int
        let name: String
        let linkCount: Int
        
        enum CodingKeys: String, CodingKey {
            case index = "folderIdx"
            case name = "folderName"
            case linkCount = "folderLinkCount"
        }
    }
}
