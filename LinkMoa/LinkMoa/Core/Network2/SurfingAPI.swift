//
//  SurfingAPI.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Moya

enum SurfingAPI {
    case folderDetail(index: Int)
    case like(index: Int)
    case likedFolder
    case topTenFolder
}

extension SurfingAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://dev.linkmoa.shop") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .folderDetail(let index):
            return "/folders/\(index)"
        case .like(let index):
            return "/folders/\(index)/like"
        case .likedFolder:
            return "/users/like"
        case .topTenFolder:
        return "/folder/top"
        }
    }
    
    var method: Method {
        switch self {
        case .folderDetail, .likedFolder, .topTenFolder:
            return .get
        case .like:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .folderDetail, .like, .likedFolder, .topTenFolder:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json",
                "x-access-token" : testToken]
    }
}


