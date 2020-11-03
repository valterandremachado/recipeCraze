//
//  RealmService.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 6/20/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import RealmSwift

class RealmService {
    
    private init() {}
    static let shared = RealmService()
    let realm = try! Realm()
    
    func create <T: Object> (_ object: T) {
            do {
            try realm.write {
//                if object != object {
                realm.add(object, update: .all)
//                } else {
//                    print("Data already exists")
//                }
            }
            
            } catch {
                postError(error)
            }
    }
    
    func update <T: Object> (_ object: T, with dictionary: [String: Any?]) {
            do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
            
            } catch {
                postError(error)
            }
    }
    
    func delete <T: Object> (_ object: T) {
        do {
        try realm.write {
            realm.delete(object)
        }
            
        } catch {
            postError(error)
        }
    }
    
    func postError(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmError(in vc: UIViewController, completion: @escaping (Error?) -> Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"),
                                               object: nil,
                                               queue: nil) { (notification) in
                                                completion(notification.object as? Error)
        }
    }
    
    func stopObservingError(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
    
}
