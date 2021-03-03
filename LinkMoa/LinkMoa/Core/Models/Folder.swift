//
//  Folder.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/06.
//

import Foundation
import RealmSwift

class Folder: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var isShared: Bool = false
    @objc dynamic var date: Date = Date()
    
    let tags: List<Tag> = List<Tag>()
    let links: List<Link> = List<Link>()
    
    var count: Int {
        return links.count
    }
    
    var shareItem: String {
        return "\(name)\n\n" + Array(links).map { link in
            return "\(link.name)\n\(link.url)"
        }.joined(separator: "\n\n")
    }
    
    convenience init(name: String, isShared: Bool, tags: [Tag]) {
        self.init()
        self.name = name
        self.isShared = isShared
        self.tags.append(objectsIn: tags)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class Tag: Object {
    @objc dynamic var name: String = ""
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
