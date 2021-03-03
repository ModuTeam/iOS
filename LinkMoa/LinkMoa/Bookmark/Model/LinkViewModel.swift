//
//  LinkViewModel.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/17.
//

import Foundation
import RealmSwift
import Realm

protocol LinkViewModelOutputs {
    var links: Observable<[Link]> { get }
    var tags: Observable<[String]> { get }
    var folderName: Observable<String> { get }
    var isShared: Observable<Bool> { get }
}

protocol LinkViewModelInputs {
    func attachObserver()
    func removeFolder(target folder: Folder)
    func removeLink(target link: Link)
    func update(handler updateHandler: @escaping () -> ())
}

protocol LinkViewModelType {
    var inputs: LinkViewModelInputs { get }
    var outputs: LinkViewModelOutputs { get }
}

final class LinkViewModel: LinkViewModelInputs, LinkViewModelOutputs, LinkViewModelType {

    init() {
        self.realmService = RealmService()
    }
    
    deinit {
        folderToken?.invalidate()
        print("links deinit")
    }
    
    private let realmService: RealmService
    private var folderToken: NotificationToken?
    var folderSource: Folder?

    let links: Observable<[Link]> = Observable([])
    let tags: Observable<[String]> = Observable([])
    let folderName: Observable<String> = Observable("")
    let isShared: Observable<Bool> = Observable(false)
    
    var inputs: LinkViewModelInputs { return self }
    var outputs: LinkViewModelOutputs { return self }
    
    func attachObserver() {
        folderToken = folderSource?.observe({ [unowned self] changes in
            switch changes {
            case .change(_, let properties):
                print("linkViewModel - change")
                for property in properties {
                    switch property.name {
                    case "name":
                        if let name = property.newValue as? String {
                            self.folderName.value = name
                        }
                    case "links":
                        if let links = property.newValue as? List<Link> {
                            self.links.value = links.map { $0 }
                        }
                    case "tags":
                        if let tags = property.newValue as? List<Tag> {
                            self.tags.value = tags.map { $0.name }
                        }
                    case "isShared":
                        if let isShared = property.newValue as? Bool {
                            self.isShared.value = isShared
                        }
                    default:
                        break
                    }
                }
            case .deleted:
                print("linkViewModel - deleted")
            case .error(let error):
                print(error)
                fatalError()
            }
        })
    }
    
    func removeFolder(target folder: Folder) {
        realmService.delete(folder)
    }
    
    func removeLink(target link: Link) {
        realmService.delete(link)
    }
    
    func update(handler updateHandler: @escaping () -> ()) {
        realmService.update {
            updateHandler()
        }
    }
}
