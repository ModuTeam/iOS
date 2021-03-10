//
//  SurfingManager.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/08.
//

import Foundation
import Moya

protocol SurfingNetworkable {
    var provider: MoyaProvider<SurfingAPI> { get }

    func fetchTopTenFolder(completion: @escaping (Result<TopTenFolder, Error>) -> ())
    
    func fetchLikedFolders(completion: @escaping (Result<LikedFolder, Error>) -> ())
    
    func fetchFolderDetail(folder index: Int, completion: @escaping (Result<FolderDetail, Error>) -> ())
    
    
    
}

struct SurfingManager: SurfingNetworkable {
    var provider: MoyaProvider<SurfingAPI> = MoyaProvider<SurfingAPI>(plugins: [])
    
    func fetchTopTenFolder(completion: @escaping (Result<TopTenFolder, Error>) -> ()) {
        request(target: .topTenFolder, completion: completion)
    }
    
    func fetchLikedFolders(completion: @escaping (Result<LikedFolder, Error>) -> ()) {
        request(target: .likedFolder, completion: completion)
    }
    
    func fetchFolderDetail(folder index: Int, completion: @escaping (Result<FolderDetail, Error>) -> ()) {
        request(target: .folderDetail(index: index), completion: completion)
    }
    
}

private extension SurfingManager {
    private func request<T: Decodable>(target: SurfingAPI, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
//                    print(String(data: response.data, encoding: .utf8))
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    // for test
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
