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
    
    case topTenFolder
    case category(index: Int, params: [String: Any])
    case likedFolder(params: [String: Any])
    
    case searchFolder(params: [String: Any])
    case searchLink(params: [String: Any])
    
    case report(params: [String: Any])
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
        
        
        case .topTenFolder:
            return "/folders/top"
        case .category(let index, _):
            return "/categories/\(index)/folders"
        case .likedFolder:
            return "/users/like"
            
        case .searchFolder:
            return "/folders/search"
        case .searchLink:
            return "/links/search"
            
        case .report:
            return "/reports"
        }
    }
    
    var method: Method {
        switch self {
        case .folderDetail, .topTenFolder, .category, .likedFolder, .searchFolder, .searchLink:
            return .get
        case .like, .report:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .folderDetail, .like, .topTenFolder:
            return .requestPlain
        case .category(_, let params), .likedFolder(let params), .searchFolder(let params), .searchLink(let params), .report(params: let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json",
                "x-access-token" : testToken]
    }
}


