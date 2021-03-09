//
//  SearchLinkViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/24.
//

import Foundation
import RealmSwift
import Realm

enum SearchLinkFetchOption: String {
    case name = "name"
    case date = "date"
}

protocol SearchLinkViewModelOutputs {
    var links: Observable<[Link]> { get }
}

protocol SearchLinkViewModelInputs {
    func attachObserver()
    func remove(target link: Link)
}

protocol SearchLinkViewModelType {
    var inputs: SearchLinkViewModelInputs { get }
    var outputs: SearchLinkViewModelOutputs { get }
}

class SearchLinkViewModel: SearchLinkViewModelInputs, SearchLinkViewModelOutputs, SearchLinkViewModelType {
    
    init() {
        // self.realmService = RealmService()
    }
    
    // private let realmService: RealmService
    private var folderToken: NotificationToken?
    
    var fetchOption: SearchLinkFetchOption = .date
    var folderSource: Folder?
    
    let links: Observable<[Link]> = Observable([])
    
    var inputs: SearchLinkViewModelInputs { return self }
    var outputs: SearchLinkViewModelOutputs { return self }
    
    func attachObserver() {
//        folderToken = folderSource?.observe { changes in 
//            switch changes {
//            case .change(_, let properties):
//                for property in properties {
//                    switch property.name {
//                    case "links":
//                        if let links = property.newValue as? List<Link> {
//                            self.links.value = links.sorted(byKeyPath: self.fetchOption.rawValue).map { $0 }
//                        }
//                    default:
//                        break
//                    }
//                }
//            case .deleted:
//                print("searchLinkViewModel - deleted")
//            case .error(let error):
//                print(error)
//                fatalError()
//            }
//        }
    }
    
    func remove(target link: Link) {
        // realmService.delete(link)
    }
}
