//
//  SurfingFolderDetailViewModel.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/11.
//

import Foundation

protocol SurfingFolderDetailViewModelOutputs {
    var folderDetail: Observable<FolderDetail.Result>? { get }
}

protocol SurfingFolderDetailViewModelInputs {
    func fetchFolderDetail(folder: Int)
}

protocol SurfingFolderDetailViewModelType {
    var inputs: SurfingFolderDetailViewModelInputs { get }
    var outputs: SurfingFolderDetailViewModelOutputs { get }
}

final class SurfingFolderDetailViewModel: SurfingFolderDetailViewModelOutputs, SurfingFolderDetailViewModelInputs, SurfingFolderDetailViewModelType {
    
    init() {
        self.surfingManager = SurfingManager()
    }
    
    private let surfingManager: SurfingManager
    
    var inputs: SurfingFolderDetailViewModelInputs { return self }
    var outputs: SurfingFolderDetailViewModelOutputs { return self }
    
    var folderDetail: Observable<FolderDetail.Result>?
   
    func fetchFolderDetail(folder: Int) {
        surfingManager.fetchFolderDetail(folder: 0) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                if let data = response.result {
                    self.folderDetail?.value = data
                }
            }
        }
    }
}


