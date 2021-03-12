//
//  AddLinkViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/03/10.
//

import Foundation

protocol AddLinkViewModelOutputs {}

protocol AddLinkViewModelInputs {
    func addLink(folder index: Int, params: [String : Any], completionHandler: @escaping (Result<LinkResponse, Error>) -> ())
    func editLink(link index: Int, params: [String: Any], completionHandler: @escaping (Result<LinkResponse, Error>) -> ())
    func deleteLink(link index: Int, completionHandler: @escaping (Result<LinkResponse, Error>) -> ())
}

protocol AddLinkViewModelType {
    var inputs: AddLinkViewModelInputs { get }
    var outputs: AddLinkViewModelOutputs { get }
}


final class AddLinkViewModel: AddLinkViewModelOutputs, AddLinkViewModelInputs, AddLinkViewModelType {

    private let myScallopManager = MyScallopManager()

    var inputs: AddLinkViewModelInputs { return self }
    var outputs: AddLinkViewModelOutputs { return self }

    func addLink(folder index: Int, params: [String : Any], completionHandler: @escaping (Result<LinkResponse, Error>) -> ()) {
        myScallopManager.addLink(folder: index, params: params, completion: completionHandler)
    }
    
    //MARK:- 링크추가
    //        let params: [String: Any] = ["linkName": "testLInk",
    //                                     "linkUrl": "https://velopert.com/2389"
    //        ]
    //
    //        myScallopManager.addLink(folder: 8, params: params) { result in
    //            print("🥺test", result)
    //        })
    
    func editLink(link index: Int, params: [String : Any], completionHandler: @escaping (Result<LinkResponse, Error>) -> ()) {
        myScallopManager.editLink(link: index, params: params, completion: completionHandler)
    }
    
    func deleteLink(link index: Int, completionHandler: @escaping (Result<LinkResponse, Error>) -> ()) {
        myScallopManager.deleteLInk(link: index, completion: completionHandler)
    }
}
