//
//  SearchLinkViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/24.
//

import Foundation

//MARK:- 폐기

protocol SearchLinkViewModelOutputs {
    var searchedLinks: Observable<[SearchLink.Result]> { get }
}

protocol SearchLinkViewModelInputs {
    func searchLink(word: String)
}

protocol SearchLinkViewModelType {
    var inputs: SearchLinkViewModelInputs { get }
    var outputs: SearchLinkViewModelOutputs { get }
}

class SearchLinkViewModel: SearchLinkViewModelInputs, SearchLinkViewModelOutputs, SearchLinkViewModelType {
    
    init() {
        self.surfingManager = SurfingManager()
    }
    private let surfingManager: SurfingManager
    var searchedLinks: Observable<[SearchLink.Result]> = Observable([])
    
    var inputs: SearchLinkViewModelInputs { return self }
    var outputs: SearchLinkViewModelOutputs { return self }
 
    func searchLink(word: String) {
        let params: [String: Any] = ["word": word]
        print("🥺", word)
        surfingManager.searchLink(params: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.searchedLinks.value = []
                print(error)
            case .success(let response):
                if let data = response.result {
                    self.searchedLinks.value = data
                    print(data)
                }
            }
        }
    }
}
