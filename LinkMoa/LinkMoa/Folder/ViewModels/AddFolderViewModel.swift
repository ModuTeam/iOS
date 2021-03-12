//
//  AddFolderViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/09.
//

import Foundation

protocol AddFolderViewModelOutputs {}

protocol AddFolderViewModelInputs {
    func addFolder(folderParam param: [String : Any], completionHandler: @escaping ((Result<NewFolder, Error>) -> ()))
    func editFolder(folder index: Int, params: [String : Any], completion: @escaping (Result<FolderResponse, Error>) -> ())
}

protocol AddFolderViewModelType {
    var inputs: AddFolderViewModelInputs { get }
    var outputs: AddFolderViewModelOutputs { get }
}

final class AddFolderViewModel: AddFolderViewModelType, AddFolderViewModelOutputs, AddFolderViewModelInputs {
    
    private let myScallopManager = MyScallopManager()
    
    var inputs: AddFolderViewModelInputs { return self }
    var outputs: AddFolderViewModelOutputs { return self }

    func addFolder(folderParam param: [String : Any], completionHandler: @escaping ((Result<NewFolder, Error>) -> ())) {
        myScallopManager.addNewFolder(params: param, completion: completionHandler)
    }
    
    
    //MARK:- 폴더생성
    //        let params: [String: Any] = ["folderName": "test",
    //                                     "hashTagList": ["test1","test2"],
    //                                     "categoryIdx": 1,
    //                                     "folderType": "private"
    //        ]
    //
    //        myScallopManager.addNewFolder(params: params) { result in
    //            print("🥺test", result)
    //        }
    
    func editFolder(folder index: Int, params: [String : Any], completion: @escaping (Result<FolderResponse, Error>) -> ()) {
        myScallopManager.editFolder(folder: index, params: params, completion: completion)
    }
    
    //MARK:- 폴더수정
    //        let params: [String: Any] = ["folderName": "edit",
    //                                     "hashTagList": ["edit1","edit2"],
    //                                     "categoryIdx": 1,
    //                                     "folderType": "private"
    //        ]
    //
    //        myScallopManager.editFolder(folder: 8, params: params) { result in
    //            print("🥺test", result)
    //        }
}
