//
//  ShareViewModel.swift
//  LinkMoaShareExtension
//
//  Created by won heo on 2021/02/26.
//

import Foundation

protocol ShareViewModelOutputs {}
protocol ShareViewModelInputs {
    func save(target folder: Folder)
    func update(handler updateHandler: @escaping () -> ())
}

protocol ShareViewModelType {
    var inputs: ShareViewModelInputs { get }
    var outputs: ShareViewModelOutputs { get }
}

final class ShareViewModel: ShareViewModelOutputs, ShareViewModelInputs, ShareViewModelType {
    
//    init() {
//        self.realmService = RealmService()
//    }
    
    // private let realmService: RealmService
    
    var inputs: ShareViewModelInputs { return self }
    var outputs: ShareViewModelOutputs { return self }
    
    func save(target folder: Folder) {
        // realmService.add(folder)
    }
    
    func update(handler updateHandler: @escaping () -> ()) {
//        realmService.update {
//            updateHandler()
//        }
    }
}
