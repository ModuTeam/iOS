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
    func setFetchOption(option fetchOption: FolderFetchOption)
    func fetchFolderDetail(folderIndex index: Int, completionHandler: @escaping (Result<FolderDetail, Error>) -> ())
    func removeFolder(folderIndex index: Int, completionHandler: @escaping ((Result<FolderResponse, Error>) -> ()))
    var fetchOption: FolderFetchOption { get }
}

protocol FolderViewModelType {
    var inputs: FolderViewModelInputs { get }
    var outputs: FolderViewModelOutputs { get }
}

final class FolderViewModel: FolderViewModelInputs, FolderViewModelOutputs, FolderViewModelType {
    
    private let myScallopManager = MyScallopManager()
    private let surfingManager = SurfingManager()
    
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

    func removeFolder(folderIndex index: Int, completionHandler: @escaping ((Result<FolderResponse, Error>) -> ())) {
        myScallopManager.deleteFolder(folder: index, completion: completionHandler)
    }
    
    func fetchFolderDetail(folderIndex index: Int, completionHandler: @escaping (Result<FolderDetail, Error>) -> ()) {
        surfingManager.fetchFolderDetail(folder: index, completion: completionHandler)
    }
    
    func setFetchOption(option fetchOption: FolderFetchOption) {
        self.fetchOption = fetchOption
    }
}
