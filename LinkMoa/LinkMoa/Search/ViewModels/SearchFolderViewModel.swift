//
//  SearchFolderViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/25.
//

import Foundation
import RealmSwift
import Realm


protocol SearchFolderViewModelOutputs {
    var folders: Observable<[Folder]> { get }
    var links: Observable<[Link]> { get }
}

protocol SearchFolderViewModelInputs {
    func fetchFolders()
    func fetchLinks()
//    func remove(target object: Object)
//    func remove<T: Object>(target list: List<T>)
//    func save(target folder: Folder)
//    func update(handler updateHandler: @escaping () -> ())
//    func setFetchOption(option fetchOption: FolderFetchOption)
//    var fetchOption: FolderFetchOption { get }
}

protocol SearchFolderViewModelViewModelType {
    var inputs: SearchFolderViewModelInputs { get }
    var outputs: SearchFolderViewModelOutputs { get }
}

final class SearchFolderViewModel: SearchFolderViewModelOutputs, SearchFolderViewModelInputs, SearchFolderViewModelViewModelType {
    
    init() {
        // self.realmService = RealmService()
    }
    
    deinit {
        foldersToken?.invalidate()
        linksToken?.invalidate()
    }
    
    // private let realmService: RealmService
    
    let links: Observable<[Link]> = Observable([])
    let folders: Observable<[Folder]> = Observable([])
    
    var foldersToken: NotificationToken?
    var linksToken: NotificationToken?
    
    var inputs: SearchFolderViewModelInputs { return self }
    var outputs: SearchFolderViewModelOutputs { return self }
    
    func fetchFolders() {
//        realmService.fetch(Folder.self, fetchOption: .date, completeHandler: { results in
//            // self.folders.value = results.map { $0 }
//
//            self.foldersToken = results.observe({ [unowned self] changes in
//                switch changes {
//                case .initial(let folders):
//                    self.folders.value = folders.map { $0 }
//                    print("SearchFolderViewModel - init")
//                case .update(let folders, _, _, _):
//                    self.folders.value = folders.map { $0 }
//                    print("SearchFolderViewModel - update")
//                case .error(let error):
//                    print(error)
//                    fatalError()
//                }
//            })
//        })
    }
    
    func fetchLinks() {
//        realmService.fetch(Link.self, completeHandler: { results in
//            self.linksToken = results.observe({ [unowned self] changes in
//                switch changes {
//                case .initial(let links):
//                    self.links.value = links.map { $0 }
//                // print("FolderViewModel - init")
//                case .update(let links, _, _, _):
//                    self.links.value = links.map { $0 }
//                /// print("FolderViewModel - update")
//                case .error(let error):
//                    print(error)
//                    fatalError()
//                }
//            })
//        })
    }
}
