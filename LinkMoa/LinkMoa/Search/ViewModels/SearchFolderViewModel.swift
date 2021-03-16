//
//  SearchFolderViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/25.
//

import Foundation

protocol SearchFolderViewModelOutputs {
    var searchedFolders: Observable<[SearchFolder.Result]> { get }
    var searchedLinks: Observable<[SearchLink.Result]> { get }
}

protocol SearchFolderViewModelInputs {
    func searchFolder(word: String, page: Int)
    func searchLink(word: String, page: Int)
}

protocol SearchFolderViewModelViewModelType {
    var inputs: SearchFolderViewModelInputs { get }
    var outputs: SearchFolderViewModelOutputs { get }
}

final class SearchFolderViewModel: SearchFolderViewModelOutputs, SearchFolderViewModelInputs, SearchFolderViewModelViewModelType {
    
    init() {
        self.surfingManager = SurfingManager()
    }
    private let surfingManager: SurfingManager
    var searchedFolders: Observable<[SearchFolder.Result]> = Observable([])
    var searchedLinks: Observable<[SearchLink.Result]> = Observable([])
    
    var inputs: SearchFolderViewModelInputs { return self }
    var outputs: SearchFolderViewModelOutputs { return self }
    

    func searchFolder(word: String, page: Int) {
        let params: [String: Any] = ["word" : word,
                                     "page" : page,
                                     "limit" : 30
        ]

        DEBUG_LOG(word)
        surfingManager.searchFolder(params: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.searchedFolders.value = []
                DEBUG_LOG(error)
            case .success(let response):
                if let data = response.result {
                    self.searchedFolders.value = data
                } else {
                    self.searchedFolders.value = []
                }
            }
        }
    }
    

    func searchLink(word: String, page: Int) {
        let params: [String: Any] = ["word" : word,
                                     "page" : page,
                                     "limit" : 30
        ]

        DEBUG_LOG(word)
        surfingManager.searchLink(params: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.searchedLinks.value = []
                DEBUG_LOG(error)
            case .success(let response):
                if let data = response.result {
                    self.searchedLinks.value = data
                } else {
                    self.searchedLinks.value = []
                }
            }
        }
    }

}
