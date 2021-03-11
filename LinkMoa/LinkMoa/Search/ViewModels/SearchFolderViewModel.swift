//
//  SearchFolderViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/25.
//

import Foundation

protocol SearchFolderViewModelOutputs {
    var searchedFolders: Observable<[SearchFolder.Result]> { get }
}

protocol SearchFolderViewModelInputs {
    func searchFolder(word: String)
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
    
    var inputs: SearchFolderViewModelInputs { return self }
    var outputs: SearchFolderViewModelOutputs { return self }
    
    func searchFolder(word: String) {
        let params: [String: Any] = ["word": word]
        print("🥺", word)
        surfingManager.searchFolder(params: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.searchedFolders.value = []
                print(error)
            case .success(let response):
                if let data = response.result {
                    self.searchedFolders.value = data
                    print(data)
                }
            }
        }
    }
   
}
