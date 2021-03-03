//
//  ShareFolderSelectionViewModel.swift
//  LinkMoaShareExtension
//
//  Created by won heo on 2021/02/26.
//

import Foundation
import RealmSwift
import Realm

protocol ShareFolderSelectionViewModelOutputs {
    var folders: Observable<[Folder]> { get }
}

protocol ShareFolderSelectionViewModelInputs {
    func fetchFolders()
    func save(target folder: Folder)
}

protocol ShareFolderSelectionViewModelType {
    var inputs: ShareFolderSelectionViewModelInputs { get }
    var outputs: ShareFolderSelectionViewModelOutputs { get }
}

final class ShareFolderSelectionViewModel: ShareFolderSelectionViewModelInputs, ShareFolderSelectionViewModelOutputs, ShareFolderSelectionViewModelType {

    init() {
        self.realmService = RealmService()
    }
    
    deinit {
        foldersToken?.invalidate()
    }
    
    private let realmService: RealmService

    let folders: Observable<[Folder]> = Observable([])
    
    var inputs: ShareFolderSelectionViewModelInputs { return self }
    var outputs: ShareFolderSelectionViewModelOutputs { return self }
    
    var foldersToken: NotificationToken?
    
    func fetchFolders() {
        realmService.fetch(Folder.self, fetchOption: .date, completeHandler: { results in
            self.foldersToken = results.observe({ [unowned self] changes in
                switch changes {
                case .initial(let folders):
                    self.folders.value = folders.map { $0 }
                    print("FolderViewModel - init")
                case .update(let folders, _, _, _):
                    self.folders.value = folders.map { $0 }
                    print("FolderViewModel - update")
                case .error(let error):
                    print(error)
                    fatalError()
                }
            })
        })
    }
    
    func save(target folder: Folder) {
        realmService.add(folder)
    }
}
