//
//  RealmService.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/06.
//

import Foundation
import RealmSwift
import Realm

public enum FolderFetchOption: String {
    case name = "name"
    case date = "date"
}

public struct RealmService {
//    private var config: Realm.Configuration {
//        didSet {
//            let fileURL = FileManager.default
//                .containerURL(forSecurityApplicationGroupIdentifier: "group.LinkMoa")!
//                .appendingPathComponent("shared.realm")
//            let config = Realm.Configuration(fileURL: fileURL)
//            Realm.Configuration.defaultConfiguration = config
//        }
//    }
     
    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError()
        }
    }
    
    init() {
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.LinkMoa")!
            .appendingPathComponent("shared.realm")
        let config = Realm.Configuration(fileURL: fileURL)
        Realm.Configuration.defaultConfiguration = config
    }
    
    private func write(_ handler: (Realm) -> ()) {
        do {
            try self.realm.write {
                handler(realm)
            }
        } catch {
            fatalError()
        }
    }
}

extension RealmService {
    func add(_ object: Object) {
        write { $0.add(object) }
    }
    
    func delete(_ object: Object) {
        write { $0.delete(object, cascading: true) }
    }
    
    func delete<T: Object>(_ list: List<T>) {
        write { $0.delete(list, cascading: true) }
    }
    
    func update(_ handler: @escaping () -> ()) {
        write { _ in handler() }
    }
    
    func deleteAll(_ object: Object) {
        write { $0.deleteAll() }
    }
    
    func fetch<T: Object>(_ type: T.Type, fetchOption: FolderFetchOption = .date, completeHandler: (Results<T>) -> ()) {
        
        let models = realm.objects(type).sorted(byKeyPath: fetchOption.rawValue, ascending: true)
        completeHandler(models)
    }
    
    func fetch<T: Object, String>(_ type: T.Type, key primaryKey: String) -> T? {
        return realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
}

protocol CascadeDeleting {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool)
}

extension Realm: CascadeDeleting {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object {
        for obj in objects {
            delete(obj, cascading: cascading)
        }
    }
    
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool) {
        if cascading {
            cascadeDelete(entity)
        } else {
            delete(entity)
        }
    }
}

private extension Realm {
    private func cascadeDelete(_ entity: RLMObjectBase) {
        guard let entity = entity as? Object else { return }
        var toBeDeleted = Set<RLMObjectBase>()
        toBeDeleted.insert(entity)
        while !toBeDeleted.isEmpty {
            guard let element = toBeDeleted.removeFirst() as? Object,
                !element.isInvalidated else { continue }
            resolve(element: element, toBeDeleted: &toBeDeleted)
        }
    }
    
    private func resolve(element: Object, toBeDeleted: inout Set<RLMObjectBase>) {
        element.objectSchema.properties.forEach {
            guard let value = element.value(forKey: $0.name) else { return }
            if let entity = value as? RLMObjectBase {
                toBeDeleted.insert(entity)
            } else if let list = value as? RealmSwift.ListBase {
                for index in 0 ..< list._rlmArray.count {
                    if let realmObject = list._rlmArray.object(at: index) as? RLMObjectBase {
                        toBeDeleted.insert(realmObject)
                    }
                }
            }
        }
        delete(element)
    }
}
