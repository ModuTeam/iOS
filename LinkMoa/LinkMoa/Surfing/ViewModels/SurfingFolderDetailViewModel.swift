//
//  SurfingFolderDetailViewModel.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/11.
//

import Foundation

protocol SurfingFolderDetailViewModelOutputs {
    var folderDetail: Observable<FolderDetail.Result> { get }
}

protocol SurfingFolderDetailViewModelInputs {
    func fetchFolderDetail(folder: Int)
    func likeFolder(folder: Int)
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
    
    var folderDetail: Observable<FolderDetail.Result> = Observable(FolderDetail.Result(userIndex: 0, folderIndex: 0, name: "", type: "", likeCount: 0, linkCount: 0, folderUpdatedAt: "", likeStatus: 0, hashTagList: [], linkList: []))
   
    func fetchFolderDetail(folder: Int) {
        surfingManager.fetchFolderDetail(folder: folder) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                DEBUG_LOG(error)
            case .success(let response):
                if let data = response.result {
                    self.folderDetail.value = data
                }
            }
        }
    }
    
    func likeFolder(folder: Int) {
        surfingManager.likeFolder(folder: folder) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                DEBUG_LOG(error)
            case .success(let response):
                print(response.message)
                self.fetchFolderDetail(folder: folder)
            }
        }
    }
}


