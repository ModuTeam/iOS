//
//  SurfingViewModels.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/09.
//

import Foundation

protocol SurfingViewModelOutputs {
    var likedFolders: Observable<[LikedFolder.Result]> { get }
}

protocol SurfingViewModelInputs {
    func fetchLikedFolders()
    
}

protocol SurfingViewModelType {
    var inputs: SurfingViewModelInputs { get }
    var outputs: SurfingViewModelOutputs { get }
}

final class SurfingViewModel: SurfingViewModelOutputs, SurfingViewModelInputs, SurfingViewModelType {
    
    init() {
        self.surfingManager = SurfingManager()
    }
    
    private let surfingManager: SurfingManager
    
    var inputs: SurfingViewModelInputs { return self }
    var outputs: SurfingViewModelOutputs { return self }
    
    var likedFolders: Observable<[LikedFolder.Result]> = Observable([])
    
    func fetchLikedFolders() {
        surfingManager.fetchLikedFolders { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                if let data = response.result {
                    self.likedFolders = Observable(data)
                }
            }
        }
    }
}
