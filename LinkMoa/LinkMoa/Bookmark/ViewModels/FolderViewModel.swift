//
//  FolderViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/07.
//

import Foundation
import RealmSwift
import Realm

protocol FolderViewModelOutputs {
    var folders: Observable<[Folder]> { get }
}

protocol FolderViewModelInputs {
    func fetchFolders()
    func remove(target object: Object)
    func remove<T: Object>(target list: List<T>)
    func save(target folder: Folder)
    func update(handler updateHandler: @escaping () -> ())
    func setFetchOption(option fetchOption: FolderFetchOption)
    var fetchOption: FolderFetchOption { get }
}

protocol FolderViewModelType {
    var inputs: FolderViewModelInputs { get }
    var outputs: FolderViewModelOutputs { get }
}

final class FolderViewModel: FolderViewModelInputs, FolderViewModelOutputs, FolderViewModelType {
    
    init() {
        self.realmService = RealmService()
    }
    
    deinit {
        foldersToken?.invalidate()
    }
    
    private let realmService: RealmService
    private(set) var fetchOption: FolderFetchOption = .date

    let folders: Observable<[Folder]> = Observable([])
    
    var inputs: FolderViewModelInputs { return self }
    var outputs: FolderViewModelOutputs { return self }
    
    var foldersToken: NotificationToken?
    
    func fetchFolders() {
        realmService.fetch(Folder.self, fetchOption: self.fetchOption, completeHandler: { results in
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

    func setFetchOption(option fetchOption: FolderFetchOption) {
        self.fetchOption = fetchOption
    }
    
    func remove(target object: Object) {
        realmService.delete(object)
    }
    
    func remove<T: Object>(target list: List<T>) {
        realmService.delete(list)
    }
    
    func save(target folder: Folder) {
        realmService.add(folder)
    }
    
    func update(handler updateHandler: @escaping () -> ()) {
        realmService.update {
            updateHandler()
        }
    }
}
