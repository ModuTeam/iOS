//
//  Link.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/06.
//

import Foundation
import RealmSwift

class Link: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var webPreview: Data? = nil
    @objc dynamic var favicon: Data? = nil
    @objc dynamic var date: Date = Date()

    convenience init(name: String, url: String) {
        self.init()
        self.name = name
        self.url = url
    }
    
    convenience init(name: String, url: String, webPreview: Data?, favicon: Data?) {
        self.init()
        self.name = name
        self.url = url
        self.webPreview = webPreview
        self.favicon = favicon
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
