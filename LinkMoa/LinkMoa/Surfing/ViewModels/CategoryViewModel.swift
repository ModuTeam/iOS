//
//  CategoryViewModel.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/11.
//

import Foundation

protocol CategoryViewModelOutputs {
    var categoryFolders: Observable<[CategoryFolder.FolderList]> { get }
}

protocol CategoryViewModelInputs {
    func fetchCategoryFolder(index: Int, page: Int)
}

protocol CategoryViewModelType {
    var inputs: CategoryViewModelInputs { get }
    var outputs: CategoryViewModelOutputs { get }
}

final class CategoryViewModel: CategoryViewModelOutputs, CategoryViewModelInputs, CategoryViewModelType {
    
    init() {
        self.surfingManager = SurfingManager()
    }
    
    private let surfingManager: SurfingManager
    
    var inputs: CategoryViewModelInputs { return self }
    var outputs: CategoryViewModelOutputs { return self }
    
    var categoryFolders: Observable<[CategoryFolder.FolderList]> = Observable([])
        
    func fetchCategoryFolder(index: Int, page: Int) {
        let params: [String: Any] = ["page" : page,
                                     "limit" : 30
        ]
      
        surfingManager.fetchCategoryFolders(folder: index, params: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                DEBUG_LOG(error)
            case .success(let response):
                let data = response.result.list
                self.categoryFolders.value = data
            }
        }
    }
}
