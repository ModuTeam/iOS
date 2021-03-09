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
    var folders: Observable<[FolderList.Result]> { get }
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
    
    private let myScallopManager = MyScallopManager()
    private(set) var fetchOption: FolderFetchOption = .date

    var folders: Observable<[FolderList.Result]> = Observable([])
    
    var inputs: FolderViewModelInputs { return self }
    var outputs: FolderViewModelOutputs { return self }
    
    // var foldersToken: NotificationToken?
    
    func fetchFolders() {
        myScallopManager.fetchMyFolderList(completion: { result in
            switch result {
            case .success(let value):
                if let folders = value.result {
                    self.folders.value = folders
                }
            case .success(let error):
                print(error)
            default:
                break
            }
            
        })
    }

    func setFetchOption(option fetchOption: FolderFetchOption) {
        self.fetchOption = fetchOption
    }
    
    func remove(target object: Object) {
        // realmService.delete(object)
    }
    
    func remove<T: Object>(target list: List<T>) {
        // realmService.delete(list)
    }
    
    func save(target folder: Folder) {
        // realmService.add(folder)
    }
    
    func update(handler updateHandler: @escaping () -> ()) {
//        realmService.update {
//            updateHandler()
//        }
    }
}
