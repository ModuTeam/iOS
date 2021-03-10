//
//  MyScallopAPI.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Moya
let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWR4IjoxLCJpYXQiOjE2MTQ5Njg3NDQsImV4cCI6MTY0NjUwNDc0NCwic3ViIjoidXNlckluZm8ifQ.sWA9929i2jgUUa8HxtM-m-kw3zWTP371FNo5RExJeSk"

enum MyScallopAPI {
    case myFolderList(index: Int)
    case addFolder(params: [String: Any])
    case editFolder(index: Int, params: [String: Any])
    case deleteFolder(index: Int)
    case addLink(index: Int, params: [String: Any])
    case editLink(index: Int, params: [String: Any])
    case deleteLink(index: Int)
}

extension MyScallopAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://dev.linkmoa.shop") else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .myFolderList:
            return "/users/folders"
        case .addFolder:
            return "/folders"
        case .editFolder(let index, _):
            return "/folders/\(index)"
        case .deleteFolder(let index):
            return "/folders/\(index)/status"
            
        case .addLink(let index, _):
            return "/folders/\(index)/link"
        case .editLink(let index, _):
            return "/links/\(index)"
        case .deleteLink(let index):
            return "/links/\(index)/status"
        }
    }
    
    var method: Method {
        switch self {
        case .myFolderList:
            return .get
        case .addFolder, .addLink:
            return .post
        case .editFolder, .editLink, .deleteFolder, .deleteLink:
            return .patch  
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .myFolderList, .deleteFolder, .deleteLink:
            return .requestPlain
        case .addFolder(let params),
             .editFolder(_, let params),
             .addLink(_, let params),
             .editLink(_, let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        guard let jwtToken = TokenManager().jwtToken else { fatalError() }

        return ["Content-Type" : "application/json",
                "x-access-token" : jwtToken]
    }
}



